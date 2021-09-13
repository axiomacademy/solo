import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'dart:math';

// Components
import '../components/log_element.dart';

import '../models/models.dart';
import 'welcome.dart';
import 'progress_log.dart';
import 'challenge_log.dart';
import 'recall_log.dart';
import 'review_log.dart';
import 'challenge_complete.dart';
import 'cards.dart';

import '../services/energy_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late Stream<QuerySnapshot<Learner>> _learnerStream;

  List<Widget> _widgetOptions = <Widget>[
    ExplorePage(),
    LogPage(),
    JourneyPage()
  ];

  @override
  void initState() {
    // Setting up stream from firebase
    User user = FirebaseAuth.instance.currentUser!;
    _learnerStream = FirebaseFirestore.instance
        .collection('learners')
        .where('email', isEqualTo: user.email)
        .withConverter<Learner>(
          fromFirestore: (snapshot, _) => Learner.fromJson(snapshot.data()!),
          toFirestore: (learner, _) => learner.toJson(),
        )
        .snapshots();

    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _returnToWelcome() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(WelcomePage.route());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _learnerStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text('Something went wronggg');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Material(
                child: Scaffold(
                    body: Center(
                        child: SpinKitThreeBounce(
              color: Theme.of(context).accentColor,
              size: 50.0,
            ))));
          }

          // If the learner doesn't exist, then logout
          if (snapshot.data!.docs.length == 0) {
            _returnToWelcome();
            return Container();
          }

          Learner learner = snapshot.data!.docs.single.data() as Learner;

          return Material(
              child: Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(80.0),
                child: SafeArea(
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(children: <Widget>[
                          Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              decoration: BoxDecoration(
                                  color: Color(0xFFEEE7FA),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              margin: EdgeInsets.only(right: 10.0),
                              child: Text("🪙  ${learner.coins}",
                                  style:
                                      Theme.of(context).textTheme.headline6)),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              decoration: BoxDecoration(
                                  color: Color(0xFFEEE7FA),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Text("⚡${learner.energy}",
                                  style:
                                      Theme.of(context).textTheme.headline6)),
                          Spacer(),
                          Ink(
                              decoration: ShapeDecoration(
                                color: Theme.of(context).primaryColorLight,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                              ),
                              child: IconButton(
                                  icon: Icon(Icons.logout, size: 20.0),
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.of(context)
                                        .pushReplacement(WelcomePage.route());
                                  })),
                        ])))),
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.public),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.biotech),
                  label: 'Mission Log',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.face),
                  label: 'Journey',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Theme.of(context).primaryColor,
              onTap: _onItemTapped,
            ),
          ));
        });
  }
}

class JourneyPage extends StatefulWidget {
  JourneyPage({Key? key}) : super(key: key);

  @override
  _JourneyPageState createState() => _JourneyPageState();
}

class _JourneyPageState extends State<JourneyPage> {
  late Stream<QuerySnapshot<Mission>> _missionStream;
  late Stream<QuerySnapshot<Log>> _logStream;
  late CollectionReference<Mission> _missionRef;

  @override
  void initState() {
    // Setting up stream from firebase
    User user = FirebaseAuth.instance.currentUser!;
    _missionRef = FirebaseFirestore.instance
        .collection('learners/${user.email}/missions')
        .withConverter<Mission>(
          fromFirestore: (snapshot, _) => Mission.fromJson(snapshot.data()!),
          toFirestore: (mission, _) => mission.toJson(),
        );
    _missionStream = FirebaseFirestore.instance
        .collection('learners/${user.email}/missions')
        .withConverter<Mission>(
          fromFirestore: (snapshot, _) => Mission.fromJson(snapshot.data()!),
          toFirestore: (mission, _) => mission.toJson(),
        )
        .snapshots();
    _logStream = FirebaseFirestore.instance
        .collection('learners/${user.email}/logs')
        .withConverter<Log>(
          fromFirestore: (snapshot, _) => Log.fromJson(snapshot.data()!),
          toFirestore: (log, _) => log.toJson(),
        )
        .orderBy('timestamp', descending: true)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Container(
      padding: EdgeInsets.all(30.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          child: Text("Active Missions",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontSize: 24)),
        ),
        _buildMissions(),
        Container(
          margin: EdgeInsets.only(top: 30.0),
          child: Text("Recent Activity",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontSize: 24)),
        ),
        Expanded(child: _buildLogActivity())
      ]),
    )));
  }

  Widget _buildLogActivity() {
    return StreamBuilder<QuerySnapshot>(
        stream: _logStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                child: Center(
                    child: SpinKitThreeBounce(
              color: Theme.of(context).accentColor,
              size: 50.0,
            )));
          }

          if (snapshot.data!.docs.length == 0) {
            return Container(
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.only(top: 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: Center(
                  child: Text("Keep track of your learning by creating a log ✨",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(color: Colors.grey[600])),
                ));
          }

          List<Log> logs = snapshot.data!.docs.map((DocumentSnapshot document) {
            return document.data()! as Log;
          }).toList();

          return StickyGroupedListView<Log, DateTime>(
              elements: logs,
              order: StickyGroupedListOrder.ASC,
              groupBy: (Log log) => DateTime(
                  log.timestamp.year, log.timestamp.month, log.timestamp.day),
              groupComparator: (DateTime value1, DateTime value2) =>
                  value2.compareTo(value1),
              itemComparator: (Log log1, Log log2) =>
                  log1.timestamp.compareTo(log2.timestamp),
              groupSeparatorBuilder: (Log log) => Container(
                    height: 40,
                    margin: EdgeInsets.only(top: 20.0),
                    width: 120,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                            '${log.timestamp.day}/${log.timestamp.month}/${log.timestamp.year}',
                            style: Theme.of(context).textTheme.subtitle1)),
                  ),
              itemBuilder: (_, Log log) {
                return FutureBuilder<DocumentSnapshot>(
                    future: _missionRef.doc(log.mission).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong");
                      }

                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return Text("Document does not exist");
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Mission mission = snapshot.data!.data() as Mission;
                        return LogElement(log: log, mission: mission);
                      }

                      return Container();
                    });
              });
        });
  }

  Widget _buildMissions() {
    return StreamBuilder<QuerySnapshot>(
        stream: _missionStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Column(
              mainAxisSize: MainAxisSize.min,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Mission mission = document.data()! as Mission;
                return Container(
                    margin: EdgeInsets.only(top: 10.0),
                    padding: EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Text(mission.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(color: Colors.white)),
                            Spacer(),
                            Text("54 logs".toUpperCase(),
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .overline
                                    ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                          ]),
                          Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: Text(
                                mission.purpose,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(color: Colors.white),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ))
                        ]));
              }).toList());
        });
  }
}

class LogPage extends StatefulWidget {
  LogPage({Key? key}) : super(key: key);

  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  late Stream<QuerySnapshot<Challenge>> _challengeStream;
  late CollectionReference<Mission> _missionRef;
  late CollectionReference<ReviewCard> _cardRef;

  bool loadingReview = false;

  @override
  void initState() {
    // Setting up stream from firebase
    User user = FirebaseAuth.instance.currentUser!;
    _missionRef = FirebaseFirestore.instance
        .collection('learners/${user.email}/missions')
        .withConverter<Mission>(
          fromFirestore: (snapshot, _) => Mission.fromJson(snapshot.data()!),
          toFirestore: (mission, _) => mission.toJson(),
        );
    _cardRef = FirebaseFirestore.instance
        .collection('learners/${user.email}/cards')
        .withConverter<ReviewCard>(
          fromFirestore: (snapshot, _) => ReviewCard.fromJson(snapshot.data()!),
          toFirestore: (card, _) => card.toJson(),
        );
    _challengeStream = FirebaseFirestore.instance
        .collection('learners/${user.email}/challenges')
        .withConverter<Challenge>(
          fromFirestore: (snapshot, _) => Challenge.fromJson(snapshot.data()!),
          toFirestore: (challenge, _) => challenge.toJson(),
        )
        .snapshots();

    super.initState();
  }

  Future<List> _getDailyReview() async {
    // First, choose 10 random cards
    var rng = new Random();
    List<List<dynamic>> dailyReview = [];
    for (int i = 0; i < 10; i++) {
      var rid = rng.nextInt(100000);
      QuerySnapshot<ReviewCard> cardQuery = await _cardRef
          .where('rid', isGreaterThanOrEqualTo: rid)
          .limit(1)
          .get();
      dailyReview.add([cardQuery.docs.single.id, cardQuery.docs.single.data()]);
    }

    return dailyReview;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: SingleChildScrollView(
                child: Container(
      padding: EdgeInsets.all(30.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        (loadingReview == true)
            ? Container(
                height: 400,
                padding: EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                child: Center(
                    child: SpinKitThreeBounce(
                  color: Colors.white,
                  size: 50.0,
                )))
            : GestureDetector(
                onTap: () async {
                  setState(() {
                    loadingReview = true;
                  });
                  Navigator.of(context)
                      .push(CardsPage.route(await _getDailyReview()));
                },
                child: Container(
                    height: 400,
                    padding: EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    child: Center(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                          Text("Review your knowledge daily",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                          Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: Text(
                                  "Review your cards and retain knowledge like a pro",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(color: Colors.white)))
                        ])))),
        Container(
          margin: EdgeInsets.only(top: 20.0),
          child: Text("Challenges",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontSize: 24)),
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(top: 10.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: _challengeStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  if (snapshot.data!.docs.length == 0) {
                    return Container(
                        height: 160,
                        width: MediaQuery.of(context).size.width - 60,
                        padding: EdgeInsets.all(20.0),
                        margin: EdgeInsets.only(right: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                              "No challenges, create one to supercharge your learning 🧠",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(color: Colors.grey[600])),
                        ));
                  }

                  return Row(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                    Challenge challenge = document.data()! as Challenge;
                    String challengeId = document.id;

                    return FutureBuilder<DocumentSnapshot>(
                        future: _missionRef.doc(challenge.mission).get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text("Something went wrong");
                          }

                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return Text("Document does not exist");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Mission mission = snapshot.data!.data() as Mission;
                            return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                      ChallengeCompleteLogPage.route(
                                          challenge, challengeId));
                                },
                                child: Container(
                                    width: 300,
                                    height: 160,
                                    padding: EdgeInsets.all(20.0),
                                    margin: EdgeInsets.only(right: 10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(challenge.title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5),
                                          Container(
                                              margin: EdgeInsets.only(top: 5.0),
                                              child: Text(mission.title,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1
                                                      ?.copyWith(
                                                          color: Colors
                                                              .grey[500]))),
                                          Container(
                                              margin:
                                                  EdgeInsets.only(top: 10.0),
                                              child: Text(challenge.description,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2))
                                        ])));
                          }
                          return Container();
                        });
                  }).toList());
                })),
        Container(
          margin: EdgeInsets.only(top: 20.0),
          child: Text("Logging",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontSize: 24)),
        ),
        Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Row(children: <Widget>[
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(ContentLogPage.route());
                      },
                      child: Container(
                          height: 50,
                          margin: EdgeInsets.all(5.0),
                          padding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Center(
                              child: Text("🧠 Content",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1))))),
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(ChallengeLogPage.route());
                    },
                    child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: Center(
                            child: Text("🥊 Challenge",
                                style:
                                    Theme.of(context).textTheme.subtitle1)))),
              )
            ])),
        Row(children: <Widget>[
          Expanded(
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(ProgressLogPage.route());
                  },
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.all(5.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Center(
                          child: Text("🔥 Progress",
                              style: Theme.of(context).textTheme.subtitle1))))),
          Expanded(
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(ReviewLogPage.route());
                },
                child: Container(
                    height: 50,
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Center(
                        child: Text("🃏 Review",
                            style: Theme.of(context).textTheme.subtitle1)))),
          )
        ])
      ]),
    ))));
  }
}

class ExplorePage extends StatefulWidget {
  ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late Stream<QuerySnapshot<Learner>> _learnerStream;
  late CollectionReference<Planet> _planetRef;

  User user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    _planetRef =
        FirebaseFirestore.instance.collection('planets').withConverter<Planet>(
              fromFirestore: (snapshot, _) => Planet.fromJson(snapshot.data()!),
              toFirestore: (planet, _) => planet.toJson(),
            );
    _learnerStream = FirebaseFirestore.instance
        .collection('learners')
        .where('email', isEqualTo: user.email)
        .withConverter<Learner>(
          fromFirestore: (snapshot, _) => Learner.fromJson(snapshot.data()!),
          toFirestore: (learner, _) => learner.toJson(),
        )
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _learnerStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Material(
                child: Scaffold(
                    body: Center(
                        child: SpinKitThreeBounce(
              color: Theme.of(context).accentColor,
              size: 50.0,
            ))));
          }

          Learner learner = snapshot.data!.docs.single.data() as Learner;

          return FutureBuilder<DocumentSnapshot>(
              future: _planetRef.doc(learner.currentPlanet).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Planet planet = snapshot.data!.data() as Planet;
                  return Material(
                      child: SafeArea(
                          child: Container(
                              padding: EdgeInsets.all(30.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(planet.name,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline2),
                                    Text(planet.system,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5),
                                    Container(
                                        margin: EdgeInsets.only(top: 20.0),
                                        child: LinearProgressIndicator(
                                            minHeight: 10.0,
                                            value: (learner.mined / 100),
                                            backgroundColor: Colors.purple[50],
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    Container(
                                        margin: EdgeInsets.only(top: 5.0),
                                        child: Row(children: [
                                          Text("Mining Progress".toUpperCase(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .overline),
                                          Spacer(),
                                          Text("🪙 100",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1)
                                        ])),
                                    Container(
                                        margin: EdgeInsets.only(top: 20.0),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.all(10.0),
                                          onTap: () async {
                                            try {
                                              EnergyService.buyEnergyWithCoins(
                                                  user.email!);
                                            } on NotEnoughCoins catch (_) {
                                              print("GIVE AN ERROR");
                                            }
                                          },
                                          tileColor: Colors.grey[100],
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          leading: Icon(Icons.bolt,
                                              size: 30.0,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          title: Text("Refuel rocket",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6),
                                          subtitle: Text(
                                              "Convert 100 coins to energy",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1),
                                        )),
                                    Container(
                                        margin: EdgeInsets.only(top: 10.0),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.all(10.0),
                                          onTap: _purchaseEnergy,
                                          tileColor: Colors.grey[100],
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          leading: Icon(Icons.auto_fix_high,
                                              size: 30.0,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          title: Text("Energy Boost",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6),
                                          subtitle: Text("Buy 100 energy",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1),
                                        )),
                                    Expanded(
                                        child: Card(
                                            elevation: 0,
                                            color: Colors.grey[100],
                                            margin: EdgeInsets.only(top: 20.0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0))),
                                            child: Center(
                                                child: Container(
                                              width: 250,
                                              child: Text(
                                                  "Working on cool game elements to bring to you 🏗️",
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1
                                                      ?.copyWith(
                                                          color: Colors
                                                              .grey[600])),
                                            )))),
                                  ]))));
                }
                return Container();
              });
        });
  }

  void _purchaseEnergy() async {
    Offerings offerings = await Purchases.getOfferings();
    if (offerings.current != null) {
      try {
        PurchaserInfo purchaserInfo =
            await Purchases.purchasePackage(offerings.current!.lifetime!);
        await EnergyService.buyEnergy(user.email!);
      } on PlatformException catch (e) {
        var errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
          print(e);
        }
      }
    }
  }
}

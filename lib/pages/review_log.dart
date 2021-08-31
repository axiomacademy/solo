import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';

import '../models/models.dart';
import '../theme.dart';

class ReviewLogPage extends StatefulWidget {
  ReviewLogPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ReviewLogPage());
  }

  @override
  _ReviewLogPageState createState() => _ReviewLogPageState();
}

class _ReviewLogPageState extends State<ReviewLogPage> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      theme: buildTheme(),
      routes: {
        '/': (context) => MissionSelectView(),
        '/mission': (context) => MissionCardsView(returnHome: _returnHome),
        '/mission/add': (context) => MissionCardsAddView(),
      },
    );
  }

  void _returnHome() {
    Navigator.of(context).pop();
  }
}

class MissionCardsAddView extends StatefulWidget {
  MissionCardsAddView({Key? key}) : super(key: key);

  @override
  _MissionCardsAddViewState createState() => _MissionCardsAddViewState();
}

class _MissionCardsAddViewState extends State<MissionCardsAddView> {
  final _topController = TextEditingController();
  final _bottomController = TextEditingController();
  late CollectionReference<ReviewCard> _cardsRef;

  @override
  void initState() {
    User user = FirebaseAuth.instance.currentUser!;
    _cardsRef = FirebaseFirestore.instance
        .collection('learners/${user.email}/cards')
        .withConverter<ReviewCard>(
          fromFirestore: (snapshot, _) => ReviewCard.fromJson(snapshot.data()!),
          toFirestore: (challenge, _) => challenge.toJson(),
        );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final missionId = ModalRoute.of(context)!.settings.arguments as String;

    return Material(
        child: SafeArea(
            child: Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text("Add a new card ✨",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline2
                                  ?.copyWith(height: 1.15))),
                      Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                              "You're so awesome! Use flashcards to improve your recall and retention and you'll be nailing your goals in no time!",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(height: 1.6))),
                      Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                            controller: _topController,
                            cursorColor: Theme.of(context).primaryColor,
                            minLines: 3,
                            maxLines: 3,
                            decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: EdgeInsets.all(15),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2.0,
                                      color: Theme.of(context).primaryColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              hintText: "Top side of the card",
                              hintStyle:
                                  TextStyle(color: Theme.of(context).hintColor),
                              focusColor: Theme.of(context).primaryColor,
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            controller: _bottomController,
                            minLines: 3,
                            maxLines: 3,
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: EdgeInsets.all(15),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2.0,
                                      color: Theme.of(context).primaryColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              hintText: "Bottom side of the card",
                              hintStyle:
                                  TextStyle(color: Theme.of(context).hintColor),
                              focusColor: Theme.of(context).primaryColor,
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                await _createReviewCard(missionId);
                                _topController.clear();
                                _bottomController.clear();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              child: Row(children: <Widget>[
                                Spacer(),
                                Text("ADD"),
                                Spacer(),
                              ]))),
                      Container(
                          margin: EdgeInsets.only(top: 0.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                await _createReviewCard(missionId);
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              child: Row(children: <Widget>[
                                Spacer(),
                                Text("DONE!"),
                                Spacer(),
                              ])))
                    ]))));
  }

  Future<void> _createReviewCard(String missionId) async {
    await _cardsRef.add(ReviewCard(
        mission: missionId,
        topText: _topController.value.text,
        bottomText: _bottomController.value.text));
  }
}

class MissionCardsView extends StatefulWidget {
  MissionCardsView({Key? key, required this.returnHome}) : super(key: key);

  final VoidCallback returnHome;

  @override
  _MissionCardsViewState createState() => _MissionCardsViewState();
}

class _MissionCardsViewState extends State<MissionCardsView> {
  late CollectionReference<Mission> _missionRef;
  late CollectionReference<ReviewCard> _cardsRef;

  @override
  void initState() {
    User user = FirebaseAuth.instance.currentUser!;
    _missionRef = FirebaseFirestore.instance
        .collection('learners/${user.email}/missions')
        .withConverter<Mission>(
          fromFirestore: (snapshot, _) => Mission.fromJson(snapshot.data()!),
          toFirestore: (mission, _) => mission.toJson(),
        );

    _cardsRef = FirebaseFirestore.instance
        .collection('learners/${user.email}/cards')
        .withConverter<ReviewCard>(
          fromFirestore: (snapshot, _) => ReviewCard.fromJson(snapshot.data()!),
          toFirestore: (challenge, _) => challenge.toJson(),
        );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final missionId = ModalRoute.of(context)!.settings.arguments as String;

    return Material(
        child: SafeArea(
            child: Container(
                padding: EdgeInsets.all(30.0),
                child: FutureBuilder<DocumentSnapshot>(
                    future: _missionRef.doc(missionId).get(),
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
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Ink(
                                  decoration: ShapeDecoration(
                                    color: Theme.of(context).primaryColorLight,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                  ),
                                  child: IconButton(
                                      icon: Icon(Icons.arrow_back, size: 20.0),
                                      onPressed: () {
                                        widget.returnHome();
                                      })),
                              Container(
                                  margin: EdgeInsets.only(top: 20.0),
                                  child: Text(mission.title,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline2
                                          ?.copyWith(height: 1.15))),
                              Container(
                                  padding: EdgeInsets.only(top: 0),
                                  child: Text(mission.purpose,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(height: 1.6))),
                              Container(
                                  height: 120,
                                  padding: EdgeInsets.all(30.0),
                                  margin: EdgeInsets.only(top: 20.0),
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
                                        Text("Review all mission cards",
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                        StreamBuilder<QuerySnapshot>(
                                            stream: _cardsRef
                                                .where('mission',
                                                    isEqualTo: missionId)
                                                .snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (snapshot.hasError) {
                                                return Text(
                                                    "Something went wrong");
                                              }

                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Text("Loading");
                                              }

                                              int count = snapshot.data!.size;

                                              return Container(
                                                  margin:
                                                      EdgeInsets.only(top: 5.0),
                                                  child: Text(
                                                      "$count total cards",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1
                                                          ?.copyWith(
                                                              color: Colors
                                                                  .white)));
                                            })
                                      ]))),
                              Container(
                                  margin:
                                      EdgeInsets.only(top: 20.0, bottom: 10.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text("Cards",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                ?.copyWith(fontSize: 24)),
                                        Spacer(),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                                '/mission/add',
                                                arguments: missionId);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary:
                                                Theme.of(context).primaryColor,
                                          ),
                                          child: Text("Add".toUpperCase()),
                                        )
                                      ])),
                              StreamBuilder(
                                  stream: _cardsRef
                                      .where('mission', isEqualTo: missionId)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Something went wrong');
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Text("Loading");
                                    }

                                    List<List> cards = snapshot.data!.docs
                                        .map((DocumentSnapshot document) {
                                      return [document.id, document.data()!];
                                    }).toList();

                                    return Expanded(
                                        child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: cards.length,
                                      itemBuilder: (BuildContext ctx, index) {
                                        String cardId =
                                            cards[index][0] as String;
                                        ReviewCard cardData =
                                            cards[index][1] as ReviewCard;

                                        return Dismissible(
                                          key: UniqueKey(),
                                          direction:
                                              DismissDirection.endToStart,
                                          onDismissed: (_) {
                                            setState(() async {
                                              cards.removeAt(index);
                                              await _cardsRef
                                                  .doc(cardId)
                                                  .delete();
                                            });
                                          },
                                          child: Card(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20.0,
                                                  horizontal: 20.0),
                                              child: Text(cardData.topText,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.visible),
                                            ),
                                          ),
                                          background: Container(
                                            color: Colors.red,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            alignment: Alignment.centerRight,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      },
                                    ));
                                  })
                            ]);
                      }
                      return Container();
                    }))));
  }
}

class MissionSelectView extends StatefulWidget {
  MissionSelectView({Key? key}) : super(key: key);

  @override
  _MissionSelectViewState createState() => _MissionSelectViewState();
}

class _MissionSelectViewState extends State<MissionSelectView> {
  late Stream<QuerySnapshot<Mission>> _missionStream;

  @override
  void initState() {
    // Setting up stream from firebase
    User user = FirebaseAuth.instance.currentUser!;
    _missionStream = FirebaseFirestore.instance
        .collection('learners/${user.email}/missions')
        .withConverter<Mission>(
          fromFirestore: (snapshot, _) => Mission.fromJson(snapshot.data()!),
          toFirestore: (mission, _) => mission.toJson(),
        )
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text("Pick a Mission to review 👀",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline2
                                  ?.copyWith(height: 1.15))),
                      StreamBuilder<QuerySnapshot>(
                          stream: _missionStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text("Loading");
                            }

                            return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  Mission mission = document.data()! as Mission;
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            '/mission',
                                            arguments: document.id);
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(top: 10.0),
                                          padding: EdgeInsets.all(30.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15.0),
                                            ),
                                          ),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Row(children: <Widget>[
                                                  Text(mission.title,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6),
                                                  Spacer(),
                                                  Text("54 logs".toUpperCase(),
                                                      style: Theme.of(context)
                                                          .primaryTextTheme
                                                          .overline
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )),
                                                ]),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10.0),
                                                    child: Text(
                                                      mission.purpose,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ))
                                              ])));
                                }).toList());
                          }),
                      Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: ElevatedButton(
                              onPressed: () async {},
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              child: Row(children: <Widget>[
                                Spacer(),
                                Text("Review all cards".toUpperCase()),
                                Spacer(),
                              ])))
                    ]))));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';

import '../models/models.dart';
import '../services/energy_service.dart';
import '../theme.dart';

class ContentLogPage extends StatefulWidget {
  ContentLogPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ContentLogPage());
  }

  @override
  _ContentLogPageState createState() => _ContentLogPageState();
}

class _ContentLogPageState extends State<ContentLogPage> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Provider<ContentLogHandler>(
        create: (_) => ContentLogHandler(),
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          theme: buildTheme(),
          routes: {
            '/': (context) => MissionSelectView(),
            '/content': (context) => ContentView(),
            '/review': (context) => ReviewView(endLogFlow: _finishLog),
          },
        ));
  }

  void _finishLog() {
    Navigator.of(context).pop();
  }
}

class ContentLogHandler {
  String _missionId = '';
  String _content = '';
  String _review = '';

  void setMissionId(String id) {
    _missionId = id;
  }

  void setContentTitle(String content) {
    _content = content;
  }

  void setReview(String review) {
    _review = review;
  }

  Future<void> createLog() async {
    User? user = FirebaseAuth.instance.currentUser!;
    // Check if the energy requirements are met
    await EnergyService.completeLog(user.email!);
    final logRef = FirebaseFirestore.instance
        .collection('learners/${user.email}/logs')
        .withConverter<Log>(
          fromFirestore: (snapshot, _) => Log.fromJson(snapshot.data()!),
          toFirestore: (log, _) => log.toJson(),
        );

    await logRef.add(Log(
        type: 'content',
        mission: _missionId,
        timestamp: DateTime.now(),
        contentTitle: _content,
        contentReview: _review));
  }
}

class ReviewView extends StatefulWidget {
  ReviewView({Key? key, required this.endLogFlow}) : super(key: key);

  final VoidCallback endLogFlow;

  @override
  _ReviewViewState createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Expanded(
                                child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3.0)),
                                        color:
                                            Theme.of(context).primaryColor))),
                            Expanded(
                                child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3.0)),
                                        color:
                                            Theme.of(context).primaryColor))),
                            Expanded(
                                child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3.0)),
                                        color:
                                            Theme.of(context).primaryColor))),
                          ]),
                          Container(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Text("Notes that you will never forget 😋",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline2
                                      ?.copyWith(height: 1.15))),
                          Container(
                              margin: EdgeInsets.only(top: 20.0),
                              child: TextFormField(
                                controller: _controller,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(height: 1.6),
                                cursorColor: Theme.of(context).primaryColor,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  hintMaxLines: 10,
                                  hintText:
                                      "Wow you've learnt some new stuff! The best way to ensure you don't foget what you've learnt is to practice free recall. Write down everything you remember here, it doesn't matter if you've forgotten some of it!\n\nUse bullet points or write in full sentences, it doesn't matter.\n\nSoon, you'll be a recollection superstar!",
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                          height: 1.5, color: Colors.grey[500]),
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.only(top: 20.0),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    Provider.of<ContentLogHandler>(context,
                                            listen: false)
                                        .setReview(_controller.value.text);

                                    try {
                                      await Provider.of<ContentLogHandler>(
                                              context,
                                              listen: false)
                                          .createLog();
                                    } catch (e) {
                                      print("HII");
                                    } finally {
                                      widget.endLogFlow();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                  ),
                                  child: Row(children: <Widget>[
                                    Spacer(),
                                    Text("Submit Log".toUpperCase()),
                                    Spacer(),
                                  ])))
                        ])))));
  }
}

class ContentView extends StatefulWidget {
  ContentView({Key? key}) : super(key: key);

  @override
  _ContentViewState createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Expanded(
                                child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3.0)),
                                        color:
                                            Theme.of(context).primaryColor))),
                            Expanded(
                                child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3.0)),
                                        color:
                                            Theme.of(context).primaryColor))),
                            Expanded(
                                child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    height: 10,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3.0)),
                                        color: Colors.grey[200]))),
                          ]),
                          Container(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Text("What did you learn today?",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline2
                                      ?.copyWith(height: 1.15))),
                          Container(
                              padding: EdgeInsets.only(top: 30.0),
                              child: Text(
                                  "That's awesome someone's closer to being a genius today! Let's practice active learning to make sure that you never forget what you now know 🧠.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(height: 1.6))),
                          Container(
                              margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
                              child: Text("What did you just learn 😎",
                                  style:
                                      Theme.of(context).textTheme.headline6)),
                          Container(
                              margin: EdgeInsets.only(top: 0.0),
                              child: TextFormField(
                                controller: _controller,
                                cursorColor: Theme.of(context).primaryColor,
                                decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: EdgeInsets.all(15),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2.0,
                                          color:
                                              Theme.of(context).primaryColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  hintText:
                                      "What does general relativity mean?",
                                  hintStyle: TextStyle(
                                      color: Theme.of(context).hintColor),
                                  focusColor: Theme.of(context).primaryColor,
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.only(top: 20.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    Provider.of<ContentLogHandler>(context,
                                            listen: false)
                                        .setContentTitle(
                                            _controller.value.text);
                                    Navigator.of(context).pushNamed('/review');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                  ),
                                  child: Row(children: <Widget>[
                                    Spacer(),
                                    Text("NEXT"),
                                    Spacer(),
                                  ])))
                        ])))));
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
        .where('completed', isEqualTo: false)
        .withConverter<Mission>(
          fromFirestore: (snapshot, _) => Mission.fromJson(snapshot.data()!),
          toFirestore: (mission, _) => mission.toJson(),
        )
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5.0),
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                    color: Theme.of(context).primaryColor))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5.0),
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                    color: Colors.grey[200]))),
                      ]),
                      Spacer(),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text("Which mission are you logging?",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline2
                                  ?.copyWith(
                                      fontSize: width / 7, height: 1.15))),
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
                                        Provider.of<ContentLogHandler>(context,
                                                listen: false)
                                            .setMissionId(document.id);
                                        // Figure out how store ID
                                        Navigator.of(context)
                                            .pushNamed('/content');
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
                    ]))));
  }
}

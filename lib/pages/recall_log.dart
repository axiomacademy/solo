import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';

import '../models/learner.dart';
import '../theme.dart';

class RecallLogPage extends StatefulWidget {
  RecallLogPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => RecallLogPage());
  }

  @override
  _RecallLogPageState createState() => _RecallLogPageState();
}

class _RecallLogPageState extends State<RecallLogPage> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      theme: buildTheme(),
      routes: {
        '/': (context) => MissionSelectView(),
      },
    );
  }
}

class ReviewView extends StatefulWidget {
  ReviewView({Key? key}) : super(key: key);

  @override
  _ReviewViewState createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
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
                                    color: Theme.of(context).primaryColor))),
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(5.0),
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0)),
                                    color: Theme.of(context).primaryColor))),
                      ]),
                      Container(
                          padding: EdgeInsets.only(top: 50.0),
                          child: Text("Notes that you will never forget 😋",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline2
                                  ?.copyWith(height: 1.15))),
                      Expanded(
                          child: Container(
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
                                      "Wow you've learnt some new stuff! The best way to ensure you don't foget what you've learnt is to practice free recall. Write down everything you remember here, it doesn't matter if you've forgotten some of it!\n\n Use bullet points or write in full sentences, it doesn't matter. Soon, you'll be a recollection superstar",
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                          height: 1.5, color: Colors.grey[500]),
                                ),
                              ))),
                      Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: ElevatedButton(
                              onPressed: () async {},
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              child: Row(children: <Widget>[
                                Spacer(),
                                Text("Submit Log".toUpperCase()),
                                Spacer(),
                              ])))
                    ]))));
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
    return Material(
        child: SafeArea(
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
                          child: Text("What did you learn today?",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline2
                                  ?.copyWith(height: 1.15))),
                      Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                              "That's awesome someone's closer to being a genius today! Let's practice active learning to make sure that you never forget what you now know 🧠.",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(height: 1.6))),
                      Container(
                          margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                          child: Text("What did you just learn 😎",
                              style: Theme.of(context).textTheme.headline6)),
                      Container(
                          margin: EdgeInsets.only(top: 30.0),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2.0,
                                      color: Theme.of(context).primaryColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              hintText: "What does general relativity mean?",
                              hintStyle:
                                  TextStyle(color: Theme.of(context).hintColor),
                              focusColor: Theme.of(context).primaryColor,
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              child: Row(children: <Widget>[
                                Spacer(),
                                Text("NEXT"),
                                Spacer(),
                              ])))
                    ]))));
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
                                        // Figure out how store ID
                                        Navigator.of(context)
                                            .pushNamed('/level');
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
                    ]))));
  }
}

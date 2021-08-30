import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solo/services/energy_service.dart';

import '../models/models.dart';
import '../theme.dart';

class ChallengeLogPage extends StatefulWidget {
  ChallengeLogPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ChallengeLogPage());
  }

  @override
  _ChallengeLogPageState createState() => _ChallengeLogPageState();
}

class _ChallengeLogPageState extends State<ChallengeLogPage> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Provider<ChallengeHandler>(
        create: (_) => ChallengeHandler(),
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          theme: buildTheme(),
          routes: {
            '/': (context) => MissionSelectView(),
            '/challenge': (context) =>
                ChallengeCreateView(endLogFlow: _finishLog),
          },
        ));
  }

  void _finishLog() {
    Navigator.of(context).pop();
  }
}

class ChallengeHandler {
  String _missionId = '';
  String _title = '';
  String _description = '';

  void setMissionId(String id) {
    _missionId = id;
  }

  void setChallengeParameters(String title, String description) {
    _title = title;
    _description = description;
  }

  Future<void> createChallenge() async {
    User? user = FirebaseAuth.instance.currentUser!;
    // Take the energy requirements
    await EnergyService.createChallenge(user.email!);

    final logRef = FirebaseFirestore.instance
        .collection('learners/${user.email}/challenges')
        .withConverter<Challenge>(
          fromFirestore: (snapshot, _) => Challenge.fromJson(snapshot.data()!),
          toFirestore: (challenge, _) => challenge.toJson(),
        );

    await logRef.add(Challenge(
        mission: _missionId,
        title: _title,
        description: _description,
        completed: false));
  }
}

class ChallengeCreateView extends StatefulWidget {
  ChallengeCreateView({Key? key, required this.endLogFlow}) : super(key: key);

  final VoidCallback endLogFlow;

  @override
  _ChallengeCreateViewState createState() => _ChallengeCreateViewState();
}

class _ChallengeCreateViewState extends State<ChallengeCreateView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

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
                      ]),
                      Spacer(),
                      Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text("Set yourself a challenge 🔥",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline2
                                  ?.copyWith(height: 1.15))),
                      Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                              "There is no learning without doing. Set yourself practice sessions and directly train your skills, and you'll be a master in no time 💪. \n\nRemember challenges expire after a week so do them as soon as possible!",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(height: 1.6))),
                      Container(
                          margin: EdgeInsets.only(top: 30.0),
                          child: TextFormField(
                            controller: _titleController,
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
                              hintText: "What is your challenge?",
                              hintStyle:
                                  TextStyle(color: Theme.of(context).hintColor),
                              focusColor: Theme.of(context).primaryColor,
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: TextFormField(
                            controller: _descriptionController,
                            minLines: 5,
                            maxLines: 5,
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
                              hintText:
                                  "Describe it in greater detail and layout your plan",
                              hintStyle:
                                  TextStyle(color: Theme.of(context).hintColor),
                              focusColor: Theme.of(context).primaryColor,
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                Provider.of<ChallengeHandler>(context,
                                        listen: false)
                                    .setChallengeParameters(
                                        _titleController.value.text,
                                        _descriptionController.value.text);
                                try {
                                  await Provider.of<ChallengeHandler>(context,
                                          listen: false)
                                      .createChallenge();
                                } catch (e) {
                                  print("HIII");
                                } finally {
                                  widget.endLogFlow();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              child: Row(children: <Widget>[
                                Spacer(),
                                Text("CREATE CHALLENGE"),
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
                                        Provider.of<ChallengeHandler>(context,
                                                listen: false)
                                            .setMissionId(document.id);
                                        // Figure out how store ID
                                        Navigator.of(context)
                                            .pushNamed('/challenge');
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

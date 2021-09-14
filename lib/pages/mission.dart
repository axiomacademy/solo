import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selectable_container/selectable_container.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';

import '../models/models.dart';
import './home.dart';
import '../theme.dart';
import '../services/energy_service.dart';

class MissionCreatePage extends StatefulWidget {
  MissionCreatePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => MissionCreatePage());
  }

  @override
  _MissionCreatePageState createState() => _MissionCreatePageState();
}

class _MissionCreatePageState extends State<MissionCreatePage> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Provider<MissionCreateHandler>(
        create: (_) => MissionCreateHandler(),
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          theme: buildTheme(),
          routes: {
            '/': (context) => MissionNamePage(),
            '/motivation': (context) => MotivationPage(),
            '/motivation/self': (context) => MotivationSelfPage(),
            '/motivation/career': (context) => MotivationCareerPage(),
            '/motivation/switch': (context) => MotivationSwitchPage(),
            '/purpose': (context) => PurposePage(endFlow: _finish),
          },
        ));
  }

  void _finish() {
    Navigator.of(context).pop();
    Navigator.of(context).push(HomePage.route());
  }
}

class MissionCreateHandler {
  String _missionTitle = '';
  String _missionPurpose = '';

  void setMissionTitle(String missionTitle) {
    _missionTitle = missionTitle;
  }

  void setMissionPurpose(String missionPurpose) {
    _missionPurpose = missionPurpose;
  }

  Future<void> createMission() async {
    // Create learner
    User? user = FirebaseAuth.instance.currentUser!;
    // Create learner missions
    final missionRef = FirebaseFirestore.instance
        .collection('learners/${user.email}/missions')
        .withConverter<Mission>(
          fromFirestore: (snapshot, _) => Mission.fromJson(snapshot.data()!),
          toFirestore: (mission, _) => mission.toJson(),
        );
    await missionRef.add(
      Mission(title: _missionTitle, purpose: _missionPurpose, completed: false),
    );
  }
}

class PurposePage extends StatefulWidget {
  PurposePage({Key? key, required this.endFlow}) : super(key: key);

  final VoidCallback endFlow;

  @override
  _PurposePageState createState() => _PurposePageState();
}

class _PurposePageState extends State<PurposePage> {
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
                        children: [
                          Image(image: AssetImage('assets/img/purpose.png')),
                          Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: Text("Mission Objectives",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline4
                                      ?.copyWith(
                                          height: 1.15,
                                          fontWeight: FontWeight.w500))),
                          Container(
                              margin: EdgeInsets.only(top: 15.0),
                              child: Text(
                                  "It's essential to define your learning goals and the purpose of your mission. Think about why you want to learn this, how you can use this ability and imagine yourself doing it to supercharge your motivation",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(height: 1.5))),
                          Container(
                              margin: EdgeInsets.only(top: 20.0),
                              padding: EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: Colors.purple[50],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Text(
                                  '💡 Learning Tip: If your motivation is extrinsic (related to a promotion or other reward), then make sure you check with an expert on whether doing this will actually get you the reward.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(height: 1.5))),
                          Container(
                              margin: EdgeInsets.only(top: 30.0),
                              child: TextFormField(
                                controller: _controller,
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2.0,
                                          color:
                                              Theme.of(context).primaryColor),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  hintText: "Why do you want to learn it?",
                                  hintStyle: TextStyle(
                                      color: Theme.of(context).hintColor),
                                  focusColor: Theme.of(context).primaryColor,
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    Provider.of<MissionCreateHandler>(context,
                                            listen: false)
                                        .setMissionPurpose(
                                            _controller.value.text);
                                    Provider.of<MissionCreateHandler>(context,
                                            listen: false)
                                        .createMission();
                                    widget.endFlow();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                  ),
                                  child: Row(children: <Widget>[
                                    Spacer(),
                                    Text("START MISSION"),
                                    Spacer(),
                                  ])))
                        ])))));
  }
}

class MissionNamePage extends StatefulWidget {
  MissionNamePage({Key? key}) : super(key: key);

  @override
  _MissionNamePageState createState() => _MissionNamePageState();
}

class _MissionNamePageState extends State<MissionNamePage> {
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
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Text(
                                "Exciting, you're starting a new mission 🚀",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline4
                                    ?.copyWith(
                                        height: 1.15,
                                        fontWeight: FontWeight.w500))),
                        Container(
                            margin: EdgeInsets.only(top: 15.0),
                            child: Text(
                                "Starting a new mission can be stressful, we'll help guide you along your goal-setting process. Remember, if you aim at nothing, you won't hit anything",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(height: 1.5))),
                        Container(
                            margin: EdgeInsets.only(top: 20.0),
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.purple[50],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: Text(
                                '💡 Learning Tip:\nWrite action based goals, research shows that direct action greatly improves learner skill retention.\n\nFor example, instead of saying "Computer Science" say "Build an App"',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(height: 1.5))),
                        Container(
                            margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                            child: Text("Create your first mission 💎",
                                style: Theme.of(context).textTheme.headline6)),
                        Container(
                            margin: EdgeInsets.only(top: 5.0),
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
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                hintText: "What do you want to learn?",
                                hintStyle: TextStyle(
                                    color: Theme.of(context).hintColor),
                                focusColor: Theme.of(context).primaryColor,
                              ),
                            )),
                        Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  Provider.of<MissionCreateHandler>(context,
                                          listen: false)
                                      .setMissionTitle(_controller.value.text);
                                  Navigator.of(context)
                                      .pushNamed('/motivation');
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                ),
                                child: Row(children: <Widget>[
                                  Spacer(),
                                  Text("START MISSION"),
                                  Spacer(),
                                ])))
                      ],
                    )))));
  }
}

class MotivationSwitchPage extends StatelessWidget {
  MotivationSwitchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Text("You made the right call!",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline4
                                  ?.copyWith(
                                      height: 1.15,
                                      fontWeight: FontWeight.w500))),
                      Container(
                          margin: EdgeInsets.only(top: 15.0),
                          child: Text(
                              "On average companies estimate that around 40% of workers will require reskilling of 6 months or less.  By choosing to explore new fields, you are opening yourself to new opportunities and staying ahead of the curve!",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(height: 1.5))),
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Image(
                              image: AssetImage('assets/img/reskill.png'))),
                      Spacer(),
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/purpose');
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              child: Row(children: <Widget>[
                                Spacer(),
                                Text("LET'S START"),
                                Spacer(),
                              ])))
                    ]))));
  }
}

class MotivationCareerPage extends StatelessWidget {
  MotivationCareerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Text("You're gonna kill it!",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline4
                                  ?.copyWith(
                                      height: 1.15,
                                      fontWeight: FontWeight.w500))),
                      Container(
                          margin: EdgeInsets.only(top: 15.0),
                          child: Text(
                              '"94% of business leaders report that they expect employees to pick up new skills on the job."',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(height: 1.5))),
                      Container(
                          margin: EdgeInsets.only(top: 15.0),
                          child: Text(
                              "With your interest in upskilling, you are on the right track!",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(height: 1.5))),
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Image(
                              image: AssetImage('assets/img/upskill.png'))),
                      Spacer(),
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/purpose');
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              child: Row(children: <Widget>[
                                Spacer(),
                                Text("LET'S START"),
                                Spacer(),
                              ])))
                    ]))));
  }
}

class MotivationSelfPage extends StatelessWidget {
  MotivationSelfPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Text("Woah, that's awesome!",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline4
                                  ?.copyWith(
                                      height: 1.15,
                                      fontWeight: FontWeight.w500))),
                      Container(
                          margin: EdgeInsets.only(top: 15.0),
                          child: Text(
                              "Great! You are intrinsically motivated and don't shy from challenges. Axiom provides you with the system you need to explore a wide variety of interests and information.",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(height: 1.5))),
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Image(
                              image:
                                  AssetImage('assets/img/self-learner.png'))),
                      Spacer(),
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/purpose');
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              child: Row(children: <Widget>[
                                Spacer(),
                                Text("LET'S START"),
                                Spacer(),
                              ])))
                    ]))));
  }
}

class MotivationPage extends StatefulWidget {
  MotivationPage({Key? key}) : super(key: key);

  @override
  _MotivationPageState createState() => _MotivationPageState();
}

class _MotivationPageState extends State<MotivationPage> {
  bool _select1 = false;
  bool _select2 = false;
  bool _select3 = false;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Container(
                padding: EdgeInsets.all(30.0),
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      Image(image: AssetImage('assets/img/hard.png')),
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Text("We know learning can be hard.",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline4
                                  ?.copyWith(
                                      height: 1.15,
                                      fontWeight: FontWeight.w500))),
                      Container(
                          margin: EdgeInsets.only(top: 15.0),
                          child: Text(
                              "Learning feels uncomfortable and sometimes you just want to kick back, relax and watch some Netflix.",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(height: 1.5))),
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Text(
                              "It's okay, we all falter once in a while, what's important is that you have the motivation to get back on track and we're here to help you with that",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(height: 1.5))),
                      Container(
                          margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                          child: Text("What's your motivation to learn?",
                              style: Theme.of(context).textTheme.headline6)),
                      SelectableContainer(
                          unselectedBorderColor: Colors.grey[400],
                          unselectedOpacity: 1.0,
                          selected: _select1,
                          onValueChanged: (newValue) {
                            setState(() {
                              _select1 = newValue;
                              _select2 = false;
                              _select3 = false;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(12.0),
                              width: double.infinity,
                              child: Center(
                                  child: Text("🧠  Personal Interest",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1)))),
                      SelectableContainer(
                          unselectedBorderColor: Colors.grey[400],
                          unselectedOpacity: 1.0,
                          selected: _select2,
                          onValueChanged: (newValue) {
                            setState(() {
                              _select2 = newValue;
                              _select3 = false;
                              _select1 = false;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(12.0),
                              width: double.infinity,
                              child: Center(
                                  child: Text("⚙️  Professional Growth",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1)))),
                      SelectableContainer(
                          unselectedBorderColor: Colors.grey[400],
                          unselectedOpacity: 1.0,
                          selected: _select3,
                          onValueChanged: (newValue) {
                            setState(() {
                              _select3 = newValue;
                              _select2 = false;
                              _select1 = false;
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.all(12.0),
                              width: double.infinity,
                              child: Center(
                                  child: Text("🔀  Career Switch",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1)))),
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: ElevatedButton(
                              onPressed: () {
                                if (_select1) {
                                  Navigator.of(context)
                                      .pushNamed('/motivation/self');
                                } else if (_select2) {
                                  Navigator.of(context)
                                      .pushNamed('/motivation/career');
                                } else if (_select3) {
                                  Navigator.of(context)
                                      .pushNamed('/motivation/switch');
                                } else {
                                  Navigator.of(context)
                                      .pushNamed('/motivation/self');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              child: Row(children: <Widget>[
                                Spacer(),
                                Text("I'M READY TO COMMIT"),
                                Spacer(),
                              ])))
                    ])))));
  }
}

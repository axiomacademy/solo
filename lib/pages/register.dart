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

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => RegisterPage());
  }

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Provider<RegisterHandler>(
        create: (_) => RegisterHandler(),
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          theme: buildTheme(),
          routes: {
            '/': (context) => NamePage(),
            '/motivation': (context) => MotivationPage(),
            '/motivation/self': (context) => MotivationSelfPage(),
            '/motivation/career': (context) => MotivationCareerPage(),
            '/motivation/switch': (context) => MotivationSwitchPage(),
            '/story': (context) => StoryPage(),
            '/purpose': (context) => PurposePage(),
            '/energy': (context) =>
                EnergyPage(endRegisterFlow: _finishRegistration)
          },
        ));
  }

  void _finishRegistration() {
    Navigator.of(context).pop();
    Navigator.of(context).push(HomePage.route());
  }
}

class RegisterHandler {
  String _name = 'Learner';
  String _email = '';
  String _missionTitle = '';
  String _missionPurpose = '';

  final learnerRef =
      FirebaseFirestore.instance.collection('learners').withConverter<Learner>(
            fromFirestore: (snapshot, _) => Learner.fromJson(snapshot.data()!),
            toFirestore: (learner, _) => learner.toJson(),
          );

  String get getName {
    return _name;
  }

  void setName(String name) {
    _name = name;
  }

  void setEmail(String email) {
    _email = email;
  }

  void setMissionTitle(String missionTitle) {
    _missionTitle = missionTitle;
  }

  void setMissionPurpose(String missionPurpose) {
    _missionPurpose = missionPurpose;
  }

  Future<void> createUser() async {
    // Create learner
    User? user = FirebaseAuth.instance.currentUser!;
    await learnerRef.doc(user.email).set(
          Learner(email: user.email!, name: _name, energy: 0, coins: 0),
        );

    // Create learner missions
    final missionRef = FirebaseFirestore.instance
        .collection('learners/${user.email}/missions')
        .withConverter<Mission>(
          fromFirestore: (snapshot, _) => Mission.fromJson(snapshot.data()!),
          toFirestore: (mission, _) => mission.toJson(),
        );
    await missionRef.add(
      Mission(title: _missionTitle, purpose: _missionPurpose),
    );
  }
}

class EnergyPage extends StatelessWidget {
  EnergyPage({Key? key, required this.endRegisterFlow}) : super(key: key);

  final VoidCallback endRegisterFlow;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Container(
                padding: EdgeInsets.all(30.0),
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Text("You need energy ⚡",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline4
                                  ?.copyWith(
                                      height: 1.15,
                                      fontWeight: FontWeight.w500))),
                      Container(
                          margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                          child: Text(
                              "You need energy to mine planets. As you learn and mine more knowledge from a planet, you earn coins. And you can use coins to treat yourself with Starbucks, buy cool trophies and earn other rewards!",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(height: 1.6))),
                      Image(image: AssetImage('assets/img/convert.png')),
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Text(
                              "Invest in yourself, and charge your ship with energy. Don't worry you can start with as little as 5 dollars which gives you 50 energy points! This helps you stay on track and remain motivated throughout your learning journey.",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(height: 1.6))),
                      Container(
                          margin: EdgeInsets.only(top: 30.0),
                          child: TextFormField(
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              suffixText: "SGD",
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
                              hintText: "5",
                              hintStyle:
                                  TextStyle(color: Theme.of(context).hintColor),
                              focusColor: Theme.of(context).primaryColor,
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                Provider.of<RegisterHandler>(context,
                                        listen: false)
                                    .createUser();
                                endRegisterFlow();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              child: Row(children: <Widget>[
                                Spacer(),
                                Text("CHARGE SHIP"),
                                Spacer(),
                              ])))
                    ])))));
  }
}

class PurposePage extends StatefulWidget {
  PurposePage({Key? key}) : super(key: key);

  @override
  _PurposePageState createState() => _PurposePageState();
}

class _PurposePageState extends State<PurposePage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Container(
                padding: EdgeInsets.all(30.0),
                child: SingleChildScrollView(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2.0,
                                      color: Theme.of(context).primaryColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              hintText: "Why do you want to learn it?",
                              hintStyle:
                                  TextStyle(color: Theme.of(context).hintColor),
                              focusColor: Theme.of(context).primaryColor,
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: ElevatedButton(
                              onPressed: () {
                                Provider.of<RegisterHandler>(context,
                                        listen: false)
                                    .setMissionPurpose(_controller.value.text);
                                Navigator.of(context).pushNamed('/energy');
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

class StoryPage extends StatefulWidget {
  StoryPage({Key? key}) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final _controller = TextEditingController();

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
                        child: Text("You are now an intrepid explorer 🚀",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headline4
                                ?.copyWith(
                                    height: 1.15,
                                    fontWeight: FontWeight.w500))),
                    Container(
                        margin: EdgeInsets.only(top: 15.0),
                        child: Text(
                            "Having travelled the universe for eons, you've come to realise that all resources are abundant... except for knowledge.\n\nYour species has sent you to mine planets for knowledge, and it is your job to harvest and send knowledge back home. Good luck explorer!",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(height: 1.5))),
                    Container(
                        margin: EdgeInsets.only(top: 20.0),
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Text(
                            '💡 Learning Tip:\nWrite action based goals, research shows that direct action greatly improves learner skill retention.\n\nFor example, instead of saying "Computer Science" say "Build an App"',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(height: 1.5))),
                    Spacer(),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2.0,
                                    color: Theme.of(context).primaryColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            hintText: "What do you want to learn?",
                            hintStyle:
                                TextStyle(color: Theme.of(context).hintColor),
                            focusColor: Theme.of(context).primaryColor,
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: ElevatedButton(
                            onPressed: () {
                              Provider.of<RegisterHandler>(context,
                                      listen: false)
                                  .setMissionTitle(_controller.value.text);
                              Navigator.of(context).pushNamed('/purpose');
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
                ))));
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
                                Navigator.of(context).pushNamed('/story');
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
                                Navigator.of(context).pushNamed('/story');
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
                                Navigator.of(context).pushNamed('/story');
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
                          child: Text("Hey Shan, we know learning can be hard.",
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

class NamePage extends StatefulWidget {
  NamePage({Key? key}) : super(key: key);

  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("This the the first step to a better you",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline4
                              ?.copyWith(
                                  height: 1.15, fontWeight: FontWeight.w500)),
                      Container(
                          margin: EdgeInsets.only(top: 15.0),
                          child: Text(
                              "At Axiom, we've spent a lot of time thinking about how to help people become the best versions of themselves. We use various cognitive strategies to help you learn in the best way possible, so that you grow everyday.",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(height: 1.5))),
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Image(
                              image: AssetImage('assets/img/explore.png'))),
                      Spacer(),
                      Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: Text("So, what is your name?",
                              style: Theme.of(context).textTheme.headline6)),
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
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
                              hintText: "Jane Doe",
                              hintStyle:
                                  TextStyle(color: Theme.of(context).hintColor),
                              focusColor: Theme.of(context).primaryColor,
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: ElevatedButton(
                              onPressed: () {
                                // Commit the name to the register state
                                Provider.of<RegisterHandler>(context,
                                        listen: false)
                                    .setName(_controller.value.text);
                                Navigator.of(context).pushNamed('/motivation');
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              child: Row(children: <Widget>[
                                Spacer(),
                                Text("LET'S GO!"),
                                Spacer(),
                              ])))
                    ]))));
  }
}

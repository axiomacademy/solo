import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';

import '../services/energy_service.dart';
import '../models/models.dart';
import '../theme.dart';

class ChallengeCompleteLogPage extends StatefulWidget {
  ChallengeCompleteLogPage(
      {Key? key, required this.challenge, required this.id})
      : super(key: key);

  final Challenge challenge;
  final String id;

  static Route route(Challenge challenge, String id) {
    return MaterialPageRoute<void>(
        builder: (_) => ChallengeCompleteLogPage(challenge: challenge, id: id));
  }

  @override
  _ChallengeCompleteLogPageState createState() =>
      _ChallengeCompleteLogPageState();
}

class _ChallengeCompleteLogPageState extends State<ChallengeCompleteLogPage> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Provider<ChallengeCompleteHandler>(
        create: (_) => ChallengeCompleteHandler(widget.challenge, widget.id),
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          theme: buildTheme(),
          routes: {
            '/': (context) => ChallengeCompleteView(endLogFlow: _finishLog),
            '/log': (context) => ChallengeTextView(endLogFlow: _finishLog),
          },
        ));
  }

  void _finishLog() {
    Navigator.of(context).pop();
  }
}

class ChallengeCompleteHandler {
  final Challenge challenge;
  final String id;
  String _text = '';

  ChallengeCompleteHandler(this.challenge, this.id);

  void setChallengeText(String text) {
    _text = text;
  }

  Future<void> createLog() async {
    User? user = FirebaseAuth.instance.currentUser!;
    // Give the reward
    await EnergyService.completeChallenge(user.email!);

    final logRef = FirebaseFirestore.instance
        .collection('learners/${user.email}/logs')
        .withConverter<Log>(
          fromFirestore: (snapshot, _) => Log.fromJson(snapshot.data()!),
          toFirestore: (log, _) => log.toJson(),
        );

    await logRef.add(Log(
        type: 'challenge',
        mission: challenge.mission,
        challengeTitle: challenge.title,
        challengeDescription: challenge.description,
        challengeText: _text));

    print(id);

    await FirebaseFirestore.instance
        .collection('learners/${user.email}/challenges')
        .doc(id)
        .delete();
  }
}

class ChallengeTextView extends StatefulWidget {
  ChallengeTextView({Key? key, required this.endLogFlow}) : super(key: key);

  final VoidCallback endLogFlow;

  @override
  _ChallengeTextViewState createState() => _ChallengeTextViewState();
}

class _ChallengeTextViewState extends State<ChallengeTextView> {
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
                      ]),
                      Container(
                          padding: EdgeInsets.only(top: 50.0),
                          child: Text("Talk about your challenge 💪",
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
                                      "You crushed it! Talk about how you did your challenge and add in any pictures of your work. This is super useful when you look back and monitor your progress.\n\n* I drew this...\n* Attach photo",
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
                              onPressed: () async {
                                Provider.of<ChallengeCompleteHandler>(context,
                                        listen: false)
                                    .setChallengeText(_controller.value.text);
                                try {
                                  await Provider.of<ChallengeCompleteHandler>(
                                          context,
                                          listen: false)
                                      .createLog();
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
                                Text("Submit Log".toUpperCase()),
                                Spacer(),
                              ])))
                    ]))));
  }
}

class ChallengeCompleteView extends StatelessWidget {
  ChallengeCompleteView({Key? key, required this.endLogFlow}) : super(key: key);

  final VoidCallback endLogFlow;

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
                          child: Text("You're a superstar learner ⭐",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline2
                                  ?.copyWith(height: 1.15))),
                      Container(
                          padding: EdgeInsets.only(top: 24),
                          child: Text(
                              "Congrats on finishing another task, keep this up soon you'll be a master at your skill!\n\nIt's important to log your challenges so you can see whow far you've come, so write down some proof for your work",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                      height: 1.6,
                                      fontWeight: FontWeight.w400))),
                      Container(
                          margin: EdgeInsets.only(top: 48.0),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/log');
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              child: Row(children: <Widget>[
                                Spacer(),
                                Text("Hurray!".toUpperCase()),
                                Spacer(),
                              ]))),
                      Container(
                          margin: EdgeInsets.only(top: 0.0),
                          child: ElevatedButton(
                              onPressed: () {
                                endLogFlow();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey[200],
                                elevation: 0.0,
                              ),
                              child: Row(children: <Widget>[
                                Spacer(),
                                Text(
                                    "Oh, no I haven't finished :("
                                        .toUpperCase(),
                                    style: Theme.of(context).textTheme.button),
                                Spacer(),
                              ])))
                    ]))));
  }
}

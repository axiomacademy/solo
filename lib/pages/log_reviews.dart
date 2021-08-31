import 'package:flutter/material.dart';

import '../models/models.dart';

class ChallengeLogReview extends StatelessWidget {
  final Log log;
  final Mission mission;

  ChallengeLogReview(
      {Key? key, required Log this.log, required Mission this.mission})
      : super(key: key);

  static Route route(Log log, Mission mission) {
    return MaterialPageRoute<void>(
        builder: (_) => ChallengeLogReview(log: log, mission: mission));
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
                      Ink(
                          decoration: ShapeDecoration(
                            color: Theme.of(context).primaryColorLight,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                          ),
                          child: IconButton(
                              icon: Icon(Icons.arrow_back, size: 20.0),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })),
                      Container(
                          padding: EdgeInsets.only(top: 30.0),
                          child: Text(log.challengeTitle!,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline2
                                  ?.copyWith(height: 1.15))),
                      Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(log.challengeDescription!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(height: 1.15))),
                      Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text("Mission: ${mission.title}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(height: 1.15))),
                      Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(log.challengeText!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(height: 1.6))),
                    ]))));
  }
}

class ContentLogReview extends StatelessWidget {
  final Log log;
  final Mission mission;

  ContentLogReview(
      {Key? key, required Log this.log, required Mission this.mission})
      : super(key: key);

  static Route route(Log log, Mission mission) {
    return MaterialPageRoute<void>(
        builder: (_) => ContentLogReview(log: log, mission: mission));
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
                      Ink(
                          decoration: ShapeDecoration(
                            color: Theme.of(context).primaryColorLight,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                          ),
                          child: IconButton(
                              icon: Icon(Icons.arrow_back, size: 20.0),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })),
                      Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(log.contentTitle!,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline2
                                  ?.copyWith(height: 1.15))),
                      Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text("Mission: ${mission.title}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(height: 1.15))),
                      Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(log.contentReview!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(height: 1.6))),
                    ]))));
  }
}

class ProgressLogReview extends StatelessWidget {
  final Log log;
  final Mission mission;

  ProgressLogReview(
      {Key? key, required Log this.log, required Mission this.mission})
      : super(key: key);

  static Route route(Log log, Mission mission) {
    return MaterialPageRoute<void>(
        builder: (_) => ProgressLogReview(log: log, mission: mission));
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
                      Ink(
                          decoration: ShapeDecoration(
                            color: Theme.of(context).primaryColorLight,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                          ),
                          child: IconButton(
                              icon: Icon(Icons.arrow_back, size: 20.0),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })),
                      Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text("Progress Log",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline2
                                  ?.copyWith(height: 1.15))),
                      Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text("Mission: ${mission.title}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(height: 1.15))),
                      Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(log.progressLog!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(height: 1.6))),
                    ]))));
  }
}

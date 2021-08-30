import 'package:flutter/material.dart';

import '../models/models.dart';
import '../pages/log_reviews.dart';

class LogElement extends StatelessWidget {
  final Log log;
  final Mission mission;

  LogElement({Key? key, required Log this.log, required Mission this.mission})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title;
    final String label;

    switch (log.type) {
      case 'progress':
        title = 'Progress Log';
        label = '🔥 Progress';
        break;
      case 'content':
        title = log.contentTitle!;
        label = '🧠 Content';
        break;
      case 'challenge':
        title = log.challengeTitle!;
        label = '🥊 Challenge';
        break;
      default:
        title = 'Error';
        label = 'error';
    }

    return GestureDetector(
        onTap: () {
          switch (log.type) {
            case 'progress':
              Navigator.of(context).push(ProgressLogReview.route(log, mission));
              break;
            case 'content':
              Navigator.of(context).push(ContentLogReview.route(log, mission));
              break;
            case 'challenge':
              Navigator.of(context)
                  .push(ChallengeLogReview.route(log, mission));
              break;
            default:
              break;
          }
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
            child: Row(children: <Widget>[
              Container(
                  width: 180.0,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(title,
                            overflow: TextOverflow.fade,
                            style: Theme.of(context).textTheme.headline6),
                        Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: Text(mission.title,
                                style: Theme.of(context).textTheme.subtitle1))
                      ])),
              Spacer(),
              Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                      color: Color(0xFFEEE7FA),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Text(label,
                      style: Theme.of(context).textTheme.bodyText1)),
            ])));
  }
}

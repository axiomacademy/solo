import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/models.dart';

class CardsPage extends StatefulWidget {
  CardsPage({Key? key, required this.cards}) : super(key: key);

  // List of lists [['id', Card], ['id', Card]]
  final List cards;

  static Route route(List cards) {
    return MaterialPageRoute<void>(builder: (_) => CardsPage(cards: cards));
  }

  @override
  _CardsPageState createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  bool flipped = false;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final ReviewCard currentCard = widget.cards[index][1];
    final String currentCardId = widget.cards[index][0];

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
                          padding: EdgeInsets.only(top: 20.0, bottom: 30.0),
                          child: Text("Review\nCards",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline2
                                  ?.copyWith(height: 1.15))),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              flipped = !flipped;
                            });
                          },
                          child: Card(
                              color: (flipped)
                                  ? Theme.of(context).primaryColor
                                  : null,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Container(
                                  padding: EdgeInsets.all(30.0),
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  child: Center(
                                      child: Text(
                                          (flipped)
                                              ? currentCard.bottomText
                                              : currentCard.topText,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              ?.copyWith(
                                                  color: (flipped)
                                                      ? Colors.white
                                                      : null)))))),
                      Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 4.0,
                                      primary: Colors.white,
                                      fixedSize: Size(100.0, 100.0)),
                                  onPressed: () {},
                                  child: Icon(Icons.close,
                                      color: Colors.red, size: 50),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 4.0,
                                      primary: Colors.white,
                                      fixedSize: Size(100.0, 100.0)),
                                  onPressed: () {},
                                  child: Icon(Icons.check,
                                      color: Colors.green, size: 50),
                                )
                              ])),
                    ]))));
  }
}

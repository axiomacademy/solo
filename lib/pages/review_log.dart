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
        '/': (context) => MissionCardsAddView(),
      },
    );
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
                              onPressed: () async {},
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                              ),
                              child: Row(children: <Widget>[
                                Spacer(),
                                Text("ADD ANOTHER"),
                                Spacer(),
                              ]))),
                      Container(
                          margin: EdgeInsets.only(top: 0.0),
                          child: ElevatedButton(
                              onPressed: () async {},
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
}

class MissionCardsView extends StatefulWidget {
  MissionCardsView({Key? key}) : super(key: key);

  @override
  _MissionCardsViewState createState() => _MissionCardsViewState();
}

class _MissionCardsViewState extends State<MissionCardsView> {
  List myProducts = List.generate(100, (index) {
    return {
      "id": index,
      "top":
          "Product 3fdgfdgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfgdfdfsdfsdokpokkmwelkrnwpeormwerdfgdfgdfg",
      "bottom": index
    };
  });

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text("Build an App",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline2
                                  ?.copyWith(height: 1.15))),
                      Container(
                          padding: EdgeInsets.only(top: 0),
                          child: Text("pew pew",
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
                                            fontWeight: FontWeight.w500)),
                                Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    child: Text("605 total cards",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            ?.copyWith(color: Colors.white)))
                              ]))),
                      Container(
                          margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Cards",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(fontSize: 24)),
                                Spacer(),
                                ElevatedButton(
                                  onPressed: () async {},
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                  ),
                                  child: Text("Add".toUpperCase()),
                                )
                              ])),
                      Expanded(
                          child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: myProducts.length,
                        itemBuilder: (BuildContext ctx, index) {
                          // Display the list item
                          return Dismissible(
                            key: UniqueKey(),

                            // only allows the user swipe from right to left
                            direction: DismissDirection.endToStart,

                            // Remove this product from the list
                            // In production enviroment, you may want to send some request to delete it on server side
                            onDismissed: (_) {
                              setState(() {
                                myProducts.removeAt(index);
                              });
                            },

                            // Display item's title, price...
                            child: Card(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 20.0),
                                child: Text(myProducts[index]["top"],
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                    softWrap: true,
                                    overflow: TextOverflow.visible),
                              ),
                            ),

                            // This will show up when the user performs dismissal action
                            // It is a red background and a trash icon
                            background: Container(
                              color: Colors.red,
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ))
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
                                      onTap: () {},
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

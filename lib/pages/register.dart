import 'package:flutter/material.dart';
import 'package:selectable_container/selectable_container.dart';

class MotivationPage extends StatefulWidget {
  MotivationPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => MotivationPage());
  }

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
                                Navigator.of(context)
                                    .push(MotivationPage.route());
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

class NamePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => NamePage());
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
                                Navigator.of(context)
                                    .push(MotivationPage.route());
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

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_service.dart';
import '../models/models.dart';
import './register.dart';
import './home.dart';

/// WelcomePage, redirect to this for unauthneticated user
class WelcomePage extends StatefulWidget {
  /// Default WelcomePage constructor
  WelcomePage({Key? key}) : super(key: key);

  /// Convenience method to route to WelcomePage
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => WelcomePage());
  }

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _controller = PageController();
  final learnerRef =
      FirebaseFirestore.instance.collection('learners').withConverter<Learner>(
            fromFirestore: (snapshot, _) => Learner.fromJson(snapshot.data()!),
            toFirestore: (learner, _) => learner.toJson(),
          );

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
        child: Column(children: <Widget>[
          Expanded(
              child: Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                width: double.infinity,
                height: 375,
                child: PageView(controller: _controller, children: <Widget>[
                  InformationPage(
                      "./assets/img/boost.svg",
                      "Supercharge your learning.",
                      "Axiom uses cognitive science to boost your intrinsic motivation to learn new things"),
                  InformationPage(
                      "./assets/img/play.svg",
                      "Learning that feels like play.",
                      "Axiom believes in exploratory learning, where you chart your own learning journey"),
                  InformationPage(
                      "./assets/img/super.svg",
                      "Build your best self.",
                      "Axiom helps you grow throughout your life, so that you can do all the things you wanted to do"),
                ])),
            SmoothPageIndicator(
              controller: _controller, // PageController
              count: 3,
              effect: WormEffect(
                  dotWidth: 12.0,
                  dotHeight: 12.0,
                  activeDotColor: Color(0xFFF55F89),
                  dotColor: Color(0xFFD8D8D8)), // your preferred effect
            ),
          ]))),
          Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Hello!",
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline4
                            ?.copyWith(fontWeight: FontWeight.w500))),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Welcome to Axiom.",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 24))),
                Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: SignInWithAppleButton(
                      onPressed: () async {
                        User? user = await AuthService.signInWithApple();
                        print(user?.email);
                        final learnerQuery = await learnerRef
                            .where('email', isEqualTo: user?.email)
                            .get();
                        if (learnerQuery.size == 1) {
                          // User already exists
                          Navigator.of(context).push(HomePage.route());
                        } else {
                          Navigator.of(context).push(RegisterPage.route());
                        }
                      },
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: ElevatedButton(
                        onPressed: () async {
                          User? user = await AuthService.signInWithGoogle();
                          print(user?.email);
                          final learnerQuery = await learnerRef
                              .where('email', isEqualTo: user?.email)
                              .get();
                          if (learnerQuery.size == 1) {
                            // User already exists
                            Navigator.of(context).push(HomePage.route());
                          } else {
                            Navigator.of(context).push(RegisterPage.route());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey[200],
                          elevation: 0,
                        ),
                        child: Row(children: <Widget>[
                          SvgPicture.asset("./assets/img/google-icon.svg",
                              semanticsLabel: "Main Image",
                              width: 20,
                              height: 20),
                          Spacer(),
                          Text("SIGNIN WITH GOOGLE",
                              style: Theme.of(context).textTheme.button),
                          Spacer()
                        ]))),
              ])),
        ]),
      ),
    );
  }
}

/// InformationPage shows the sliding displays
class InformationPage extends StatelessWidget {
  /// imagePath: path to svg, titleText: the big title, subtitleText: smol text
  final String imagePath, titleText, subtitleText;

  /// Default constructor for the Information page
  InformationPage(this.imagePath, this.titleText, this.subtitleText, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 50, bottom: 50),
              child: SvgPicture.asset(imagePath,
                  semanticsLabel: "Main Image", width: 240, height: 160)),
          Padding(
              padding: EdgeInsets.only(top: 0),
              child: Text(titleText,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      ?.copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center)),
          Padding(
              padding:
                  EdgeInsets.only(top: 15, bottom: 15, left: 50.0, right: 50.0),
              child: Text(subtitleText,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Colors.grey[600], fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center)),
        ]));
  }
}

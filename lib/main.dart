import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';

// Pages
import './pages/welcome.dart';

import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Axiom",
        navigatorKey: _navigatorKey,
        theme: buildTheme(),
        home: FutureBuilder(
          // Initialize FlutterFire:
          future: _initFirebase(),
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return ErrorState(error: snapshot.error.toString());
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return WelcomePage();
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return ErrorState(error: "Loading");
          },
        ));
  }

  Future<FirebaseApp> _initFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Logged in, go straight to home page
      print("Logged in");
    }
    return firebaseApp;
  }
}

class ErrorState extends StatelessWidget {
  final String error;

  const ErrorState({required this.error, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(error));
  }
}

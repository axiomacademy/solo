import 'package:flutter/material.dart';

class LogPage extends StatefulWidget {
  LogPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: SingleChildScrollView(
                child: Container(
      padding: EdgeInsets.all(30.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        Container(
            height: 400,
            padding: EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            child: Center(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text("Review your knowledge",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w500)),
              Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text("To boost your retention",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(color: Colors.white)))
            ]))),
        Container(
          margin: EdgeInsets.only(top: 20.0),
          child: Text("Challenges",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontSize: 24)),
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(top: 10.0),
            child: Row(children: <Widget>[
              Container(
                  width: 300,
                  height: 200,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("✨ Draw a boot",
                            style: Theme.of(context).textTheme.headline5),
                        Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: Text("Mission: Draw a figure",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(color: Colors.grey[500]))),
                        Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Text(
                                "Follow the Udemy course and draw a boot to practice contour and cross contour lines",
                                style: Theme.of(context).textTheme.bodyText2))
                      ])),
            ])),
        Container(
          margin: EdgeInsets.only(top: 20.0),
          child: Text("Logging",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontSize: 24)),
        ),
        Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Row(children: <Widget>[
              Expanded(
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.all(5.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Center(
                          child: Text("🤔 Recall",
                              style: Theme.of(context).textTheme.subtitle1)))),
              Expanded(
                  child: Container(
                      height: 50,
                      padding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Center(
                          child: Text("🥊 Challenge",
                              style: Theme.of(context).textTheme.subtitle1)))),
            ])),
        Row(children: <Widget>[
          Expanded(
              child: Container(
                  height: 50,
                  margin: EdgeInsets.all(5.0),
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Center(
                      child: Text("🔥 Progress",
                          style: Theme.of(context).textTheme.subtitle1)))),
          Expanded(
              child: Container(
                  height: 50,
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Center(
                      child: Text("🧠 Cards",
                          style: Theme.of(context).textTheme.subtitle1)))),
        ])
      ]),
    ))));
  }
}

class ExplorePage extends StatefulWidget {
  ExplorePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Earth",
                          style: Theme.of(context).primaryTextTheme.headline2),
                      Text("The Solar System",
                          style: Theme.of(context).textTheme.headline5),
                      Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: LinearProgressIndicator(
                              minHeight: 10.0,
                              value: 0.5,
                              backgroundColor: Colors.purple[50],
                              color: Theme.of(context).primaryColor)),
                      Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: Row(children: [
                            Text("Mining Progress".toUpperCase(),
                                style: Theme.of(context).textTheme.overline),
                            Spacer(),
                            Text("🪙  10",
                                style: Theme.of(context).textTheme.subtitle1)
                          ])),
                      Expanded(
                          child: Card(
                              elevation: 0,
                              color: Colors.grey[100],
                              margin: EdgeInsets.only(top: 20.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              child: Center(
                                  child: Container(
                                width: 250,
                                child: Text(
                                    "Working on cool game elements to bring to you 🏗️",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(color: Colors.grey[600])),
                              )))),
                    ]))));
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> _widgetOptions = <Widget>[
    ExplorePage(),
    LogPage(),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: SafeArea(
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(children: <Widget>[
                    Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                            color: Color(0xFFEEE7FA),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        margin: EdgeInsets.only(right: 10.0),
                        child: Text("🪙 100",
                            style: Theme.of(context).textTheme.headline6)),
                    Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                            color: Color(0xFFEEE7FA),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: Text("⚡100",
                            style: Theme.of(context).textTheme.headline6)),
                    Spacer(),
                    CircleAvatar(backgroundColor: Colors.grey[300])
                  ])))),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.biotech),
            label: 'Mission Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: 'Journey',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    ));
  }
}

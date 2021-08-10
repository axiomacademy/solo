import 'package:flutter/material.dart';

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
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
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
                  margin: EdgeInsets.only(top: 10.0),
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
            label: 'Missions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: 'Me',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    ));
  }
}

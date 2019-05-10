import 'package:flutter/material.dart';

import 'tab/ConHome.dart';
import 'tab/sharedHome.dart';
import 'package:share/share.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '편의점 행사',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: TabHome(),
    );
  }
}

class TabHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TabHomeApp();
  }
}

class TabHomeApp extends State<TabHome> with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = new TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body:   new TabBarView(
        children: <Widget>[
          new ConApp(
            title: "GS25",
          ),
          new ConApp(
            title: "CU",
          ),
          new ConApp(
            title: "MINI",
          ),
          new ConApp(
            title: "7-ELEVEN",
          ),
          new ConApp(
            title: "EMART24",
          ),
          new SharedApp(),
        ],
        controller: tabController,
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.share),
          onPressed: () {
            print(tabController.index);
            Share.share('Hello World');
          }),
      bottomNavigationBar: new Material(
        color: Colors.blueGrey,
        child: new TabBar(
          tabs: <Tab>[
            new Tab(
              icon: new Text('GS25'),
            ),
            new Tab(
              icon: new Text('CU'),
            ),
            new Tab(
              icon: new Text('7-11'),
            ),
            new Tab(
              icon: new Text('MINI'),
            ),
            new Tab(
              icon: new Text('Emart'),
            ),
            new Tab(
              icon: new Icon(Icons.settings),
            ),
          ],
          controller: tabController,
        ),
      ),
    );
  }
}

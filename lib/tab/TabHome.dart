import 'package:flutter/material.dart';

import 'ConHome.dart';

class TabHome extends StatefulWidget {
  TabHome({Key key, this.itemValue, this.priceValue}) : super(key: key);
  final List<String> itemValue;
  final List<String> priceValue;

  @override
  State<StatefulWidget> createState() {
    return new TabHomeApp(itemValue, priceValue);
  }
}

class TabHomeApp extends State<TabHome> with SingleTickerProviderStateMixin {
  TabController tabController;
  List<String> itemValue;
  List<String> priceValue;

  TabHomeApp(this.itemValue, this.priceValue);

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new TabBarView(
        children: <Widget>[
          new ConApp(
            title: "GS25",
            viewArray: itemValue,
            priceArray: priceValue,
          ),
          new ConApp(
            title: "CU",
            viewArray: itemValue,
            priceArray: priceValue,
          ),
          new ConApp(
            title: "7-ELEVEN",
            viewArray: itemValue,
            priceArray: priceValue,
          ),
          new ConApp(
            title: "MINI",
            viewArray: itemValue,
            priceArray: priceValue,
          ),

          new ConApp(
            title: "EMART24",
            viewArray: itemValue,
            priceArray: priceValue,
          )
        ],
        controller: tabController,
      ),
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
              icon: new Text('E'),
            ),
          ],
          controller: tabController,
        ),
      ),
    );
  }
}

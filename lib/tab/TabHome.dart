import 'package:flutter/material.dart';

import 'ConHome.dart';

var appTitle = '';
bool voiceCheck = true;

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
    tabController.addListener(_changeTab);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: _getThemeColor(appTitle),
        title: new Text(appTitle),
        actions: <Widget>[
          new Text(
            'TTS Use',
            style: TextStyle(fontSize: 20.0, height: 1.8),
          ),
          new Switch(
            value: voiceCheck,
            onChanged: _changeVoice,
            activeColor: Colors.amber,
          )
        ],
      ),
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


  void _changeVoice(bool value) async {
    setState(() {
      voiceCheck = value;
    });
  }



  void _changeTab() {
    switch(tabController.index){
      case 0:
        setState(() {
          appTitle = "GS25";
        });
        break;
      case 1:
        setState(() {
          appTitle = "CU";
        });
        break;
      case 2:
        setState(() {
          appTitle = "7-ELEVEN";
        });
        break;
      case 3:
        setState(() {
          appTitle = "EMART24";
        });
        break;
      case 4:
        setState(() {
          appTitle = "MINISTOP";
        });
        break;
    }
  }
}

Color _getThemeColor(String title) {
  if (title.contains('CU')) {
    return Colors.red;
  } else if (title.contains('GS25')) {
    return Colors.blue;
  } else if (title.contains('7-ELEVEN')) {
    return Colors.green;
  } else if (title.contains('EMART24')) {
    return Colors.blueGrey;
  } else {
    return Colors.brown;
  }
}

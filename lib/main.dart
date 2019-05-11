import 'dart:convert';
import 'dart:io';

import 'tab/SecondConHome.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'tab/ConHome.dart';

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

//  final String url = "https://sejongchurch.cafe24.com/flutter/convi/temp.txt";
//  String data;
//
//  // Function to get the JSON data
//  Future<String> getJSONData() async {
//
//    HttpClient client = new HttpClient();
//    client.getUrl(Uri.parse(url))
//        .then((HttpClientRequest request) {
//      return request.close();
//    })
//        .then((HttpClientResponse response) {
//      response.transform(utf8.decoder).listen((contents){
//
//        setState(() {
//          data = contents;
//        });
//
//      });
//    });
//
//    return data;
//  }

  @override
  void initState() {
    super.initState();
//    this.getJSONData();
    tabController = new TabController(length: 5, vsync: this);
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
      body: new FutureBuilder(
          future: DefaultAssetBundle.of(context).loadString('temp/temp.txt'),
          builder: (context, snapshot) {
            if(snapshot.data.toString() != null)
            return new TabBarView(
              children: <Widget>[
                new ConApp(title: "GS25", data: snapshot.data.toString()),
                new ConApp(
                  title: "CU",
                  data: snapshot.data.toString(),
                ),
                new ConApp(
                  title: "MINI",
                  data: snapshot.data.toString(),
                ),
                new ConApp(
                  title: "7-ELEVEN",
                  data: snapshot.data.toString(),
                ),
                new ConApp(
                  title: "EMART24",
                  data: snapshot.data.toString(),
                ),
//            new SharedApp(),
              ],
              controller: tabController,
            );
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
              icon: new Text('E'),
            ),
//            new Tab(
//              icon: new Icon(Icons.settings),
//            ),
          ],
          controller: tabController,
        ),
      ),
    );
  }
}

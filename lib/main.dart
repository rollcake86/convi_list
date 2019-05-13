import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'tab/ConHome.dart';
import 'tab/TabHome.dart';

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
      home: InitApp(),
    );
  }
}

class InitApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new InitAppHome();
  }
}

class InitAppHome extends State<InitApp> {
  var _radioValue1 = 2;
  var _radioValue2 = 5;

  var array;
  List<String> viewArray;
  List<String> priceArray;

  bool voiceCheck = true;

  Future<String> getData() {
    return DefaultAssetBundle.of(context).loadString('temp/temp.txt');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Con List - 조건 검색'),
        ),
        body: new FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
                array = snapshot.data.toString().split("\n");
                _resetData();
                return new Container(
                  child: new Center(
                    child: new Column(
                      children: <Widget>[
                        new Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Radio(
                                value: 0,
                                groupValue: _radioValue1,
                                onChanged: _handleRadioValueChange1,
                              ),
                              new Text(
                                '1+1',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                              new Radio(
                                value: 1,
                                groupValue: _radioValue1,
                                onChanged: _handleRadioValueChange1,
                              ),
                              new Text(
                                '2+1',
                                style: new TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              new Radio(
                                value: 2,
                                groupValue: _radioValue1,
                                onChanged: _handleRadioValueChange1,
                              ),
                              new Text(
                                '전부',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Radio(
                                value: 0,
                                groupValue: _radioValue2,
                                onChanged: _handleRadioValueChange2,
                              ),
                              new Text(
                                '음료',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                              new Radio(
                                value: 1,
                                groupValue: _radioValue2,
                                onChanged: _handleRadioValueChange2,
                              ),
                              new Text(
                                '생활용품',
                                style: new TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              new Radio(
                                value: 2,
                                groupValue: _radioValue2,
                                onChanged: _handleRadioValueChange2,
                              ),
                              new Text(
                                '과자',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                              new Radio(
                                value: 3,
                                groupValue: _radioValue2,
                                onChanged: _handleRadioValueChange2,
                              ),
                              new Text(
                                '식품',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        new Padding(
                          padding: EdgeInsets.only(top: 20.0 ,bottom: 20.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Radio(
                                value: 4,
                                groupValue: _radioValue2,
                                onChanged: _handleRadioValueChange2,
                              ),
                              new Text(
                                '아이스크림',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                              new Radio(
                                value: 5,
                                groupValue: _radioValue2,
                                onChanged: _handleRadioValueChange2,
                              ),
                              new Text(
                                '전부',
                                style: new TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        new FlatButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TabHome(
                                          itemValue: viewArray,
                                          priceValue: priceArray,
                                        )),
                              );
                            },
                            padding: EdgeInsets.all(15.0),
                            shape: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0))),
                            child: new Text(
                              '검색 하기',
                              style: TextStyle(
                                  fontSize: 25.0, color: Colors.black),
                            ))
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                );
            }));
  }

  void _handleRadioValueChange1(value) async {
    setState(() {
      _radioValue1 = value;
      _resetData();
    });
  }

  void _handleRadioValueChange2(value) async {
    setState(() {
      _radioValue2 = value;
      _resetData();
    });
  }

  void _resetData() {
    viewArray = new List();
    priceArray = new List();
    for (int i = 0; i < array.length - 2;) {
      if (_partCheck(array[i + 1])) {
        if (_productCheck(array[i])) {
          viewArray.add(array[i]);
          priceArray.add(_getCharge(array[i + 1]));
        }
      }
      i = i + 2;
    }
  }

  bool _checkCompany(String array, String s) {
    if (array.contains(s)) {
      return true;
    }
    return false;
  }

  String _getCharge(String array) {
    String result = array.substring(array.length - 4, array.length);
    return result;
  }

  bool _partCheck(String array) {
    if (_radioValue1 == 0) {
      if (array.contains("1+1")) {
        return true;
      } else {
        return false;
      }
    } else if (_radioValue1 == 1) {
      if (array.contains("2+1")) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  bool _productCheck(String array) {
    if (_radioValue2 == 0) {
      if (array.contains('음료')) {
        return true;
      } else {
        return false;
      }
    } else if (_radioValue2 == 1) {
      if (array.contains('생활용품')) {
        return true;
      } else {
        return false;
      }
    } else if (_radioValue2 == 2) {
      if (array.contains('과자')) {
        return true;
      } else {
        return false;
      }
    } else if (_radioValue2 == 3) {
      if (array.contains('식품')) {
        return true;
      } else {
        return false;
      }
    } else if (_radioValue2 == 4) {
      if (array.contains('아이스크림')) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }


}

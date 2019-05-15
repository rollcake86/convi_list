import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'TabHome.dart';

class ConApp extends StatefulWidget {
  ConApp({Key key, this.title, this.viewArray, this.priceArray})
      : super(key: key);
  final String title;
  final List<String> viewArray;
  final List<String> priceArray;

  @override
  State<StatefulWidget> createState() {
    return new ConHome(title, viewArray, priceArray);
  }
}

enum TtsState { playing, stopped }

class ConHome extends State<ConApp> {
  FlutterTts flutterTts;
  dynamic languages;
  dynamic voices;
  String language;
  String voice;

  var array;

  List<String> conViewArray;
  List<String> conPriceArray;
  String companyName;

  String _newVoiceText;
  var counter = 20;

  TtsState ttsState = TtsState.stopped;

  int voiceStart = 0;

  ConHome(String title, List<String> itemArray, List<String> priceArray ) {
    companyName = title;

    conViewArray = new List();
    conPriceArray = new List();
    for (int i = 0; i < itemArray.length; i++) {
      if (itemArray[i].contains(title)) {
        this.conViewArray.add(itemArray[i]);
        this.conPriceArray.add(priceArray[i]);
      }
    }
  }

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  @override
  void initState() {
    super.initState();
    initTts();
    setState(() {
      appTitle = widget.title;
    });
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      body: new Container(
        child: new Column(
          children: <Widget>[
            Expanded(
              child: new ListView.builder(
                  itemCount: conViewArray.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: new Card(
                        child: new Column(
                          children: <Widget>[
                            new Padding(
                              padding: EdgeInsets.only(
                                  top: 20.0, left: 10.0, right: 10.0),
                              child: new Text(
                                _productName(_getShowItem(
                                    _getCompany(conViewArray[index]))),
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: counter.toDouble()),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            new Padding(
                              padding: EdgeInsets.only(bottom: 20.0, top: 15.0),
                              child: new Text(conPriceArray[index],
                                  style: new TextStyle(
                                      fontSize: counter.toDouble(),
                                      color: Colors.red),
                                  textAlign: TextAlign.start),
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                        ),
                        shape: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0))),
                      ),
                      onTap: () {
                        if (voiceCheck)
                          _onChange(_productName(
                              _getShowItem(_getCompany(conViewArray[index]))));
                      },
                      onLongPress: () {
                        Clipboard.setData(new ClipboardData(
                            text: _productName(_getShowItem(
                                    _getCompany(conViewArray[index]))) +
                                conPriceArray[index]));
                        Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text("복사되었습니다"),
                        ));
                      },
                    );
                  }),
            ),
            new Container(
              color: Colors.blueGrey,
              height: 2,
            ),
            new Row(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: new FlatButton(
                      onPressed: () {
                        setState(() {
                          if (counter > 11) {
                            counter--;
                            counter--;
                          }
                        });
                      },
                      shape: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0))),
                      child: new Text(
                        '-',
                        style: TextStyle(fontSize: 40.0),
                      )),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: new FlatButton(
                      onPressed: () {
                        setState(() {
                          if (counter < 99) {
                            counter++;
                            counter++;
                          }
                        });
                      },
                      shape: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0))),
                      child: new Text(
                        '+',
                        style: TextStyle(fontSize: 40.0),
                      )),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: new FlatButton(
                      onPressed: () {
                        _onChange(_productName(_getShowItem(_getCompany(conViewArray[voiceStart]))) + conPriceArray[voiceStart]);
                        voiceStart++;
                      },
                      shape: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0))),
                      child: new Icon(Icons.list , size: 48.0,)),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: new FlatButton(
                    onPressed: () {},
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            )
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.share),
          onPressed: () {
            StringBuffer sb = new StringBuffer();
            sb.write(widget.title + "\n\n");
            for (int i = 0; i < conViewArray.length; i++) {
              sb.write(
                  _productName(_getShowItem(_getCompany(conViewArray[i]))) +
                      "\n" +
                      conPriceArray[i] +
                      "\n\n");
            }
            Share.share(sb.toString());
          }),
    );
  }



  initTts() async {
    flutterTts = FlutterTts();

    await flutterTts.setPitch(0.9);

    if (Platform.isAndroid) {
      flutterTts.ttsInitHandler(() {
        _getLanguages();
        _getVoices();
      });
    } else if (Platform.isIOS) {
      _getLanguages();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    if (languages != null) setState(() => languages);
  }

  Future _getVoices() async {
    voices = await flutterTts.getVoices;
    if (voices != null) setState(() => voices);
  }

  Future _speak() async {
    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        var result = await flutterTts.speak(_newVoiceText);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
      _speak();
    });
  }

  String _productName(String viewArray) {
    if (viewArray.contains("생활용품")) {
      return viewArray.substring(4, viewArray.length);
    } else if (viewArray.contains("음료")) {
      return viewArray.substring(2, viewArray.length);
    } else if (viewArray.contains("아이스크림")) {
      return viewArray.substring(5, viewArray.length);
    } else if (viewArray.contains("과자")) {
      return viewArray.substring(3, viewArray.length);
    } else if (viewArray.contains("음료")) {
      return viewArray.substring(2, viewArray.length);
    } else if (viewArray.contains("식품")) {
      return viewArray.substring(2, viewArray.length);
    } else {
      return viewArray;
    }
  }

  String _getCompany(String title) {
    if (title.contains('CU')) {
      return title.substring('CU(씨유)'.length, title.length);
    } else if (title.contains('GS25')) {
      return title.substring('GS25(지에스25)'.length, title.length);
    } else if (title.contains('7-ELEVEN')) {
      return title.substring('7-ELEVEN(세븐일레븐)'.length, title.length);
    } else if (title.contains('EMART24')) {
      return title.substring('EMART24(이마트24)'.length, title.length);
    } else {
      return title.substring('MINISTOP(미니스톱)'.length, title.length);
    }
  }

  String _getProduct(String array, String value) {
    String result = array.substring(value.length, array.length);
    return result;
  }

  String _getShowItem(String getCompany) {
    int last = getCompany.lastIndexOf(" ");
    String temp = getCompany.substring(0, last);
    int price = temp.lastIndexOf(" ");
    String result = getCompany.substring(0, price) +
        "\n" +
        getCompany.substring(price + 1, temp.length);
    return result + "원";
  }


}

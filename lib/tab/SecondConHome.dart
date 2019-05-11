import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FirstConApp extends StatefulWidget{
  FirstConApp({Key key, this.title , this.data}) : super(key: key);
  final String title;
  final String data;

  @override
  State<StatefulWidget> createState() {
    return new FirstConHome();
  }
}

enum TtsState { playing, stopped }

class FirstConHome extends State<FirstConApp>{

  FlutterTts flutterTts;
  dynamic languages;
  dynamic voices;
  String language;
  String voice;

  String _newVoiceText;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;


  List<String> viewArray;
  List<String> priceArray;

  var counter = 20;
  var partValue = 2;
  var part2Value = 5;

  var _radioValue1 = 2;
  var _radioValue2 = 5;
  var array;

  @override
  void initState() {
    super.initState();
    array = widget.data.toString().split("\n");
    _resetData();
    initTts();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      appBar: new AppBar(title: Text(widget.title),),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Padding(padding: EdgeInsets.only(top: 20.0) , child: new Row(
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
            )
              ,)
            ,
            new Row(
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
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new FlatButton(onPressed: (){
                  setState(() {
                    if(counter > 11) {
                      counter--;
                      counter--;
                    }
                  });
                }, child: new Text('-' , style: TextStyle(fontSize: 20.0),)),
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
                ),  new FlatButton(onPressed: (){
                  setState(() {
                    if(counter < 99) {
                      counter++;
                      counter++;
                    }
                  });
                }, child: new Text('+' , style: TextStyle(fontSize: 20.0),)),
              ],
            ),

            Expanded(
              child:   new ListView.builder(
                  itemCount: viewArray.length,
                  itemBuilder: (BuildContext context , int index) {
                    return GestureDetector(
                      child:     new Card(
                        child: new Column(
                          children: <Widget>[
                            new Padding(padding: EdgeInsets.only(top: 20.0 , left: 10.0 , right: 10.0) , child:
                            new Text(viewArray[index] , style: new TextStyle(fontSize: counter.toDouble() ),textAlign: TextAlign.start, )  ,)
                            ,new Padding(padding: EdgeInsets.only(bottom: 20.0 , top: 15.0) , child:
                            new Text(priceArray[index] , style: new TextStyle(fontSize: counter.toDouble() , color: Colors.red ),textAlign: TextAlign.start) ,
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                        ),shape: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(25.0))),
                      ),
                    onTap: (){
                      _onChange(viewArray[index] + priceArray[index]);
                    },);
                  }),
            )
          ],
        ) ,
      ) ,floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.share),
        onPressed: () {

          StringBuffer sb = new StringBuffer();
          for(var item in viewArray){
            sb.write(item+"\n");
          }
          Share.share(sb.toString());
        }),

    );
  }

  bool _checkCompany(String array, String s) {
    if(array.contains(s)){
      return true;
    }
    return false;
  }
  String _getCharge(String array) {
    String result = array.substring(array.length - 3, array.length);
    return result;
  }

  String _getProduct(String array , String value ) {
    String result = array.substring(value.length , array.length);
    return result;
  }

  String _getCompany(String title) {
    if(title == 'CU'){
      return 'CU(씨유)';
    }else if(title == 'GS25'){
      return 'GS25(지에스25)';
    }else if(title == '7-ELEVEN'){
      return '7-ELEVEN(세븐일레븐)';
    }else if(title == 'EMART24'){
      return 'EMART24(이마트24)';
    }else {
      return 'MINISTOP(미니스톱)';
    }

  }

  bool _partCheck(String array) {
    if(_radioValue1 == 0){
      if(array.contains("1+1")){
        return true;
      }else{
        return false;
      }
    }else if(_radioValue1 ==1){
      if(array.contains("2+1")){
        return true;
      }else{
        return false;
      }
    }else{
      return true;
    }

  }

  bool _productCheck(String array) {

    if(_radioValue2 == 0){
      if(array.contains('음료')){
        return true;
      }else{
        return false;
      }
    }else if(_radioValue2 == 1){
      if(array.contains('생활용품')){
        return true;
      }else{
        return false;
      }
    }else if(_radioValue2 == 2){
      if(array.contains('과자')){
        return true;
      }else{
        return false;
      }
    }else if(_radioValue2 == 3){
      if(array.contains('식품')){
        return true;
      }else{
        return false;
      }
    }else if(_radioValue2 == 4){
      if(array.contains('아이스크림')){
        return true;
      }else{
        return false;
      }
    }else{
      return true;
    }
  }

  void _handleRadioValueChange1(value) async{
    setState(() {
      _radioValue1 = value;
      _resetData();
    });
  }

  void _handleRadioValueChange2(value) async{
    setState(() {
      _radioValue2 = value;
      _resetData();
    });
  }

  void _resetData() {
    viewArray = new List();
    priceArray = new List();
    for(int i = 0 ; i < array.length-1 ; i++){
      if(_checkCompany(array[i], widget.title)){
        if(_partCheck(array[i+1])) {
          if(_productCheck(array[i])) {
            viewArray.add(_getProduct(array[i], _getCompany(widget.title)));
            priceArray.add(_getCharge(array[i + 1]));
          }
        }
      }
    }
  }


  initTts() async{
    flutterTts = FlutterTts();

    await flutterTts.setPitch(0.8);

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


}
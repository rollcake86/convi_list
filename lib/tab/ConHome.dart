import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConApp extends StatefulWidget{
  ConApp({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() {
    return new ConHome();
  }
}

class ConHome extends State<ConApp>{

  var counter = 0;
  var key = "size";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSaveData();
  }

  void _loadSaveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = (prefs.getDouble(key) ?? 20);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: Text(widget.title),),
      body: new Container(
        child: new FutureBuilder(
            future: DefaultAssetBundle.of(context).loadString('temp/temp.txt'),
            builder: (context , snapshot){
              var array = snapshot.data.toString().split("\n");

              List<String> viewArray = new List();

              for(int i = 0 ; i < array.length-1 ; i++){
                if(_checkCompany(array[i], widget.title)){
                  viewArray.add(_getProduct(array[i] , _getCompany(widget.title) ) +'\n' + _getCharge(array[i+1]));
                }
              }

              return  new ListView.builder(
                  itemCount: viewArray.length,
                  itemBuilder: (BuildContext context , int index) {
                    return new Card(
                      child: new Text(viewArray[index] , style: new TextStyle(fontSize: counter.toDouble() ),)
                      ,
                    );
                  });
            }),
      ) ,

    );
  }

  bool _checkCompany(String array, String s) {
    if(array.contains(s)){
      return true;
    }
    return false;
  }
  String _getCharge(String array) {
    String result = array.substring(array.length - 4, array.length);
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

}
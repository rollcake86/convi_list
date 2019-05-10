import 'package:flutter/material.dart';



class MiniApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new MiniHome();
  }
}

class MiniHome extends State<MiniApp>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('MiniStop 행사'),),
      body: new Container(
        child: new FutureBuilder(
            future: DefaultAssetBundle.of(context).loadString('temp/temp.txt'),
            builder: (context , snapshot){
              var array = snapshot.data.toString().split("\n");

              List<String> viewArray = new List();

              for(int i = 0 ; i < array.length-1 ; i++){
                if(_checkCompany(array[i], 'MINISTOP(미니스톱)')){
                  viewArray.add(_getProduct(array[i] , 'CU(씨유)') +'\n' + _getCharge(array[i+1]));
                }
              }

              return  new ListView.builder(
                  itemCount: viewArray.length,
                  itemBuilder: (BuildContext context , int index) {
                    return new Card(
                      child: new Text(viewArray[index] , style: new TextStyle(fontSize: 30.0 ),)
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
    String result = array.substring(array.length -4 , array.length);
    return result;
  }
  String _getProduct(String array , String value ) {
    String result = array.substring(value.length , array.length);
    return result;
  }

}
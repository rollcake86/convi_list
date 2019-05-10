import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SharedAppHome();
  }
}

class SharedAppHome extends State<SharedApp> {
  var nameOfApp = "Presist Key Value";
  var counter = 0;
  var key = "size";
  var part = "part";
  var part2 = "part2";


  var _radioValue2 = 5;

  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSaveData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('설정'),),
      body: new Container(
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Text(
                'Font Size',
                style: TextStyle(fontSize: 20.0),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    'size : 20',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  new Text(
                    'size : 30',
                    style: TextStyle(fontSize: 30.0),
                  ),
                  new Text(
                    'size : 40',
                    style: TextStyle(fontSize: 40.0),
                  ),
                ],
              ),
              new Padding(
                padding: EdgeInsets.all(15.0),
                child: new TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Font Size',
                      hintText: '숫자를 입력하세요 (10 - 100)',
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                  controller: controller,
                ),
              ),

            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveData,
        tooltip: 'Save Size',
        child: Icon(Icons.save),
      ), // T
    );
  }

  void _loadSaveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = (prefs.getInt(key) ?? 20);
      _radioValue2 = (prefs.getInt(part2) ?? 5);
      controller.text = counter.toString();
    });
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (controller.text.length == 0) {
      return;
    }
    setState(() {
      try {
        int result = int.parse(controller.text);
        if (result < 10) {
          AlertDialog dialog = new AlertDialog(
            content: new Text('입력이 잘못되었습니다'),
          );
          showDialog(
              context: context, builder: (BuildContext context) => dialog);
        } else if (result > 100) {
          AlertDialog dialog = new AlertDialog(
            content: new Text('입력이 잘못되었습니다'),
          );
          showDialog(
              context: context, builder: (BuildContext context) => dialog);
        } else {
          prefs.setInt(key, result);
          AlertDialog dialog = new AlertDialog(
            content: new Text('저장되었습니다. 앱을 다시 재실행해주세요'),
          );
          showDialog(context: context, builder: (BuildContext context) => dialog);
        }
      } catch (error) {
        AlertDialog dialog = new AlertDialog(
          content: new Text('입력이 잘못되었습니다'),
        );
        showDialog(context: context, builder: (BuildContext context) => dialog);
      }
    });
  }



  void _handleRadioValueChange2(int value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('$part2 and $value');
    prefs.setInt(part2, value);

    setState(() {
      _radioValue2 = value;
    });
  }
}

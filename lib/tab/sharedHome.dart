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

  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSaveData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  

                ],
              ),
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
              new FlatButton(
                onPressed: () {},
                child: new Text(
                  'Save Font Size',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                color: Colors.blueAccent,
              )
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
      counter = (prefs.getDouble(key) ?? 20);
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
          prefs.setDouble(key, result.toDouble());
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('데이터가 저장되었습니다'), duration: Duration(seconds: 2)));
        }
      } catch (error) {
        AlertDialog dialog = new AlertDialog(
          content: new Text('입력이 잘못되었습니다'),
        );
        showDialog(context: context, builder: (BuildContext context) => dialog);
      }
    });
  }
}

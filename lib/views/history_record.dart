import 'dart:convert';

import 'package:flutter/material.dart';

import 'gantt_chart_painter.dart';
class historyRecords extends StatefulWidget {
  @override
  Map result;
  // In the constructor, require a Todo.
  historyRecords({Key key, @required this.result}) : super(key: key);
  _historyRecordsState createState() => _historyRecordsState();
}
class _historyRecordsState extends State<historyRecords> {
  @override
  Map<String,double> finalTimeLine=new Map();
  Widget build(BuildContext context) {
    return Scaffold(
      body: new ListView.builder(
        itemCount: widget.result.length,
        itemBuilder: (BuildContext context, int index) {
          String key = widget.result.keys.elementAt(index);
          return new Column(
            children: <Widget>[
              new ListTile(
                title: new Text("$key"),
                onTap: (){
                  var storeInfo=widget.result[key];
                  Map<String,String> timeResult = Map.castFrom(json.decode(storeInfo[0]));
                  Map<String,String> storeResult = Map.castFrom(json.decode(storeInfo[1]));
                  print("${storeInfo}");
                  Navigator.push(context,
                    MaterialPageRoute(
                    builder: (context) => MyPainter(timeln_result:timeResult, gender_result:storeResult),
                   )
                );
                },
              ),
              new Divider(
                height: 2.0,
              ),
            ],
          );
        },
      ),
    );
  }
}
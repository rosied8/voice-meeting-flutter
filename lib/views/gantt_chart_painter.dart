import 'dart:ui';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:flutter/services.dart';
var hor_margin = 20.0;
var ver_margin = 20.0;


class MyPainter extends StatelessWidget {

  @override
  Map timeln_result = Map<String, String>();
  var gender_result = Map<String, String>();
  // In the constructor, require a Todo.
  MyPainter({Key key, @required this.timeln_result, @required this.gender_result}) : super(key: key);





  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);



    return Scaffold(
      appBar: AppBar(
        title: Text('Lines'),
      ),
      body: CustomPaint(
        painter: ShapePainter(timeln_result: timeln_result, gender_result: gender_result),
        child: Container(),
      ),
    );
  }
}

TextPainter createText(String key, double scale) {
  TextSpan span =
  new TextSpan(style: new TextStyle(color: Colors.grey[600]), text: key);
  TextPainter tp = new TextPainter(
      text: span,
      textAlign: TextAlign.start,
      textScaleFactor: scale,
      textDirection: TextDirection.ltr);
  tp.layout();
  return tp;
}


class ShapePainter extends CustomPainter {



  @override

  var timeln_result;
  var gender_result;
  ShapePainter({@required this.timeln_result, @required this.gender_result});
  void paint(Canvas canvas, Size size) {

    //Map time_gender_map = data_processing(timeln_result, gender_result);
    drawTitle(canvas, size);
    drawAxes(canvas, size);
    //drawLegend(canvas, size);
    drawTime(size, canvas, gender_result);

    /*
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    Offset startingPoint = Offset(0, size.height / 2);
    Offset endingPoint = Offset(size.width, size.height / 2);

    canvas.drawLine(startingPoint, endingPoint, paint);*/
  }



  Map data_processing(timeln_result, gender_result){

    Map period_map = Map<String, String>();

    for (var key in timeln_result.keys){
      var value = timeln_result[key];
      var gender_key = key.toString() + ".wav";

      var pieces = value.split(";");


      for (var piece in pieces){
        var speaker = "Speaker" + key + " " + "gender_key";
        period_map[piece] = speaker;


      }
    }

    print("PAINT 处理好的数据：");
    print(period_map);
  }

  void drawTitle(Canvas canvas, Size size) {
    TextPainter tp = createText('Distribution of Dialogue', 2);
    tp.paint(canvas, Offset(size.width / 2 - tp.width / 2, 0));
  }


  void drawAxes(Canvas canvas, Size size){
    var paint = Paint();
    // horizontal line
    canvas.drawLine(
      Offset(hor_margin, size.height - ver_margin),
      Offset(size.width - hor_margin, size.height - ver_margin),
      paint,
    );
    // vertical line
    canvas.drawLine(
      Offset(hor_margin, size.height - ver_margin),
      Offset(hor_margin, ver_margin),
      paint,
    );

  }

/*

  void drawAxes(Canvas canvas, Size size) {
    var paint = Paint();
    // draw the horizontal line
    canvas.drawLine(
      Offset(marginLeft, size.height - marginTop),
      Offset(size.width - marginRight, size.height - marginTop),
      paint,
    );
    // draw the vertical line
    canvas.drawLine(
      Offset(marginLeft, size.height - marginTop),
      Offset(marginLeft, marginTop),
      paint,
    );
    // draw the categories on the horizontal axis
    //addCategoriesAsTextToHorizontalAxis(size, canvas);
    // draw five sizes on the vertical axis and draw lighter vertical lines
    //addHorizontalLinesAndSizes(size, canvas);
  }*/

  List calculate_lines(Map timeln_map, Map gender_map, Size size) {
    List list = [];


    var speaker_num = gender_map.length;
    // vertical segment number
    var ver_seg_num = speaker_num + 1;

    // calculate total period
    var total_period = 0.0;
    for (var key in timeln_map.keys) {
      var value = timeln_map[key];
      var pieces = value.split(";");
      for (var time in pieces) {
        var _start = time.split("==>")[0];
        var _end = time.split("==>")[1];
        _start = _start.split(":")[1];
        _end = _end.split(":")[1];
        //print("开始和结束：");
        //print(_start + _end);

        var start = double.parse('$_start');
        var end = double.parse('$_end');
        if (end > total_period) {
          total_period = end;
        }
      }
    }

    // 纵轴刻度
    var ver_calibration = (size.height - ver_margin * 2) / ver_seg_num;
    // 横轴刻度
    var hor_calibration = (size.width - hor_margin * 2) / total_period;

    // 线段坐标

    // Y轴备注
    var gender_lst = [];
    for (var i = 0; i < gender_map.length; i++) {
      var gender_key = i.toString() + ".wav";
      var i_str = i.toString();
      var speaker_info = "Speaker " + i_str + " " + gender_map[gender_key];
      gender_lst.add(speaker_info);
    }

    for (var speaker in timeln_map.keys) {
      var periods = timeln_map[speaker];
      var pieces = periods.split(";");
      for (var piece in pieces) {
        var _start = piece.split("==>")[0];
        var _end = piece.split("==>")[1];
        _start = _start.split(":")[1];
        _end = _end.split(":")[1];
        print(_start + _end);

        var start = double.parse('$_start');
        var end = double.parse('$_end');

        // X
        double x_start = hor_margin + start * hor_calibration;
        double x_end = hor_margin + end * hor_calibration;

        // Y
        var speaker_order = int.parse('$speaker') + 1;
        var y = ver_margin + speaker_order * ver_calibration;

        var coordinate = [x_start, y, x_end, y];
        list.add(coordinate);
      }



    }
    return list;
  }

  void drawTime(Size size, Canvas canvas, Map time_gender_map) {

    print("画图");
    print(timeln_result.toString());
    print(gender_result.toString());
    var draw_list = calculate_lines(timeln_result, gender_result, size);
    print(draw_list);
    for (var lst in draw_list){
      var x = lst[0];
      var y = lst[1];
      var paint = Paint();
      // horizontal line
      canvas.drawLine(
        Offset(lst[0], lst[1]),
        Offset(lst[2], lst[3]),
        paint,
      );
    }

    /*
    var paint = Paint();
    canvas.drawLine(
      Offset(0, size.height / 2 -20),
      Offset(size.width, size.height/2 -20),
      paint,
    );
    print("高为");
    print(size.height.toString());
    print("宽为");
    print(size.width.toString());
    canvas.drawLine(
      Offset(0, size.height / 2 -20),
      Offset(size.width, size.height/2 -20),
      paint,
    );


     */

  }



  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}




import 'dart:ui';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:flutter/services.dart';
import 'package:voice_reocrder/views/recorder_home_view.dart';
var hor_margin = 40.0;
var ver_margin = 40.0;
var legend_y_margin = 20.0;
var legend_x_margin = 20.0;
// var color_pool = [Colors.red, Colors.green, Colors.blue, Colors.amber, Colors.deepOrangeAccent, Colors.deepPurple, Colors.black87, Colors.tealAccent];
var male_color = Colors.teal;
var female_color = Colors.amber;


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
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecorderHomeView(title: "Welcome to voice meeting",)),
            );
          },
        ),
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

    drawTitle(canvas, size);
    drawAxes(canvas, size);
    //drawLegend(canvas, size);
    draw_legend(canvas, size);
    drawTime(size, canvas);


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
    // horizontal line legend
    TextPainter tp_hor = createText('Time(s)', 1.5);
    tp_hor.paint(canvas, Offset(size.width - ver_margin * 2, size.height - hor_margin));

    // vertical line legend
    TextPainter tp_ver = createText('Speaker', 1.5);
    tp_ver.paint(canvas, Offset(hor_margin, ver_margin));
  }

  List legend_y(Map timeln_map, Map gender_map, Size size){
    // Y轴备注
    var gender_lst = [];
    var position_lst = [];

    // 纵轴刻度
    var ver_calibration = calculate_calibration(timeln_map, gender_map, size)[0];

    for (var i = 0; i < gender_map.length; i++) {
      var gender_key = i.toString() + ".wav";
      var i_str = i.toString();
      var speaker_info = "Speaker " + i_str + " " + gender_map[gender_key];
      gender_lst.add(speaker_info);
      position_lst.add(size.height - ver_margin - (i + 1) * ver_calibration);
    }

    return [gender_lst, position_lst];
  }

  List calculate_calibration(Map timeln_map, Map gender_map, Size size){

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
    return [ver_calibration, hor_calibration];

  }

  List calculate_lines(Map timeln_map, Map gender_map, Size size) {


    // 纵轴刻度
    var ver_calibration = calculate_calibration(timeln_map, gender_map, size)[0];
    // 横轴刻度
    var hor_calibration = calculate_calibration(timeln_map, gender_map, size)[1];

    List list = [];
    // 线段坐标
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
        //var y = ver_margin + speaker_order * ver_calibration;

        var y = size.height - ver_margin - speaker_order * ver_calibration;

        var coordinate = [x_start, y, x_end, y];
        list.add(coordinate);
      }
    }
    return list;
  }

  List gender_order(Map timeln_map, Map gender_map, Size size){
    List list = [];
    for (var speaker in timeln_map.keys) {
      var periods = timeln_map[speaker];
      var pieces = periods.split(";");

      var gender_key = speaker + ".wav";
      var gender = gender_map[gender_key];
      for (var piece in pieces) {
        list.add(gender);
      }
    }

    return list;
  }

  void drawTime(Size size, Canvas canvas) {

    print("画图");
    print(timeln_result.toString());
    print(gender_result.toString());
    var draw_list = calculate_lines(timeln_result, gender_result, size);
    print(draw_list);

    var genders = gender_order(timeln_result, gender_result, size);

    print("画彩色线：");
    assert(genders.length == draw_list.length);

    for (var i = 0; i < draw_list.length; i++){
      var coordinate = draw_list[i];
      var paint = Paint();
      if (genders[i] == "Female"){
        paint.color = female_color;
      }else{
        paint.color = male_color;
      }

      paint.strokeWidth = 5;
      // horizontal line
      canvas.drawLine(
        Offset(coordinate[0], coordinate[1]),
        Offset(coordinate[2], coordinate[3]),
        paint,
      );
    }


  }

  void draw_legend(Canvas canvas, Size size){
    draw_legend_y(size, canvas);
    draw_legend_x(size, canvas);

  }

  void draw_legend_y(Size size, Canvas canvas){
    var text_y_lst = legend_y(timeln_result, gender_result, size)[0];
    var position_y_lst = legend_y(timeln_result, gender_result, size)[1];
    for (var i = 0; i < text_y_lst.length; i++){
      var text = text_y_lst[i];
      var y = position_y_lst[i];
      TextPainter tp = createText(text, 1);
      tp.paint(canvas, Offset(legend_y_margin, y));
    }
  }

  void draw_legend_x(Size size, Canvas canvas){

    var hor_calibration = calculate_calibration(timeln_result, gender_result, size)[1];

    var timeln_map = timeln_result;

    // 线段坐标
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


        x_start = double.parse((x_start).toStringAsFixed(2));
        x_end = double.parse((x_end).toStringAsFixed(2));

        var text = _start.toString();
        TextPainter tp = createText(text, 1);
        tp.paint(canvas, Offset(x_start, size.height - legend_x_margin));

        text = _end.toString();
        tp = createText(text, 1);
        tp.paint(canvas, Offset(x_end, size.height - legend_x_margin));

      }
    }


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}




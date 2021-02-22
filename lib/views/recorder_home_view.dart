import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_reocrder/views/recorded_list_view.dart';
import 'package:voice_reocrder/views/recorder_view.dart';
import 'package:http/http.dart'as http;
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:uuid/uuid.dart';
import "package:voice_reocrder/views/display.dart";
import 'package:voice_reocrder/Model/jsonreader.dart';



import 'package:flutter/services.dart';
import 'package:audiocutter/audiocutter.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'player.dart';
import 'package:wave_builder/wave_builder.dart';
import 'dart:io' as io;

class RecorderHomeView extends StatefulWidget {
  final String _title;

  const RecorderHomeView({Key key, @required String title})
      : assert(title != null),
        _title = title,
        super(key: key);

  @override
  _RecorderHomeViewState createState() => _RecorderHomeViewState();
}

class MyAudioCutter extends AudioCutter{
  static Future<String> cutAudio(String toPath, String path, double start, double end) async {
    if (start < 0.0 || end < 0.0) {
      throw ArgumentError('Cannot pass negative values.');
    }

    if (start > end) {
      throw ArgumentError('Cannot have start time after end.');
    }

    final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();


    final Directory dir = await getTemporaryDirectory();
    //final outPath = "${dir.path}/output.mp3";
    final outPath = toPath;
    var cmd =
        "-y -i \"$path\" -vn -ss $start -to $end -ar 16k -ac 2 -b:a 96k -acodec libmp3lame $outPath";
    int rc = await _flutterFFmpeg.execute(cmd);

    if (rc != 0) {
      throw ("[FFmpeg] process exited with rc $rc");
    }

    return outPath;
  }
}


class _RecorderHomeViewState extends State<RecorderHomeView> {
  var uuid;
  Directory appDirectory;
  Stream<FileSystemEntity> fileStream;
  List<String> records;
  final uploader = FlutterUploader();
  var _result;
  var current_path;

  @override
  void initState() {
    super.initState();
    records = [];
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      appDirectory.list().listen((onData) {
        records.add(onData.path);
      }).onDone(() {
        records = records.reversed.toList();
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    fileStream = null;
    appDirectory = null;
    records = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: RecordListView(
              records: records,
            ),
          ),
          Expanded(
            flex: 1,
            child: RecorderView(
              onSaved: _onRecordComplete,
            ),
          ),
          FlatButton(
              onPressed:_getResult,
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Icon(Icons.analytics_outlined),
                  Text("Result"),
                ],
              )),
          FlatButton(
              onPressed: testAPI,
            child: Column(
              children: <Widget>[
                Icon(Icons.analytics_outlined),
                Text("Test"),
              ],
            )),
        ],
      ),
    );
  }

  _onRecordComplete() async{
    records.clear();
    appDirectory.list().listen((onData) async {
      print("There is new data");
      print(onData.path);

      // 存储路径
      if (onData.path.substring(onData.path.length-3)=="wav"){
        current_path = onData.path;
      }

      records.add(onData.path);
      // var req = http.MultipartRequest('POST', Uri.parse(""));
      // uuid = Uuid();
      //method 1
      // req.files.add(
      //     http.MultipartFile(
      //         'audio',
      //         File(onData.path).readAsBytes().asStream(),
      //         File(onData.path).lengthSync(),
      //         filename: onData.path.split("/").last
      //     )
      // );
      // var res = await req.send();
      // return res.reasonPhrase;
      // print('file name is ${onData.path.split("/").last}');
      // final taskId = await uploader.enqueue(
      //     url: "http://192.168.0.111:80/wave_factory/?uuid="+uuid.toString(), //required: url to upload to
      //     files: [FileItem(filename:onData.path.split("/").last, savedDir:onData.path, fieldname:"file")], // required: list of files that you want to upload
      //     method: UploadMethod.POST, // HTTP method  (POST or PUT or PATCH)
      //     headers: {},
      //     data: {"uuid": uuid.toString()}, // any data you want to send in upload request
      //     showNotification: false, // send local notification (android only) for upload status
      //     tag: "upload 1");
    }).onDone(() async {
      // uploader.result.listen((result) {
      //   print("The result is ${result}");
      // }, onError: (ex, stacktrace) {
      //   print(stacktrace);
      // });
      records.sort();
      records = records.reversed.toList();
      records.removeWhere((element) =>element.substring(element.length-3)!="wav");
      var req = http.MultipartRequest('POST', Uri.parse(""));
      uuid = Uuid();
      var filename=records[0].split("/").last;
      var path=records[0].replaceAll("/"+filename,"");
      final taskId = await uploader.enqueue(
              url: "http://192.168.0.111:80/wave_factory/?uuid="+uuid.v4().toString(), //required: url to upload to
              files: [FileItem(filename:records[0].split("/").last, savedDir:path, fieldname:"file")], // required: list of files that you want to upload
              method: UploadMethod.POST, // HTTP method  (POST or PUT or PATCH)
              headers: {},
              data: {"uuid": uuid.toString()}, // any data you want to send in upload request
              showNotification: false, // send local notification (android only) for upload status
              tag: "upload 1");
      uploader.result.listen((result) {
        print("The result is ${result}");
      }, onError: (ex, stacktrace) {
        print(stacktrace);
      });
      setState(() {});
    });
  }
  _getResult() async{
    var filename=current_path.split("/").last;
    current_path=current_path.replaceAll("/"+filename,"");
    current_path = current_path + "/" + records[0].split("/").last;

    _result="";
    var url='http://192.168.0.111:80/wave_factory/?uuid=${uuid}';
    final response = await http.get(url);
    // _result=response.body.toString();
    print('The result of response is ${response.body}');

    final http.Response deleteReq =await http.delete(url);
    print('The response of delete request is${deleteReq}');
    print(deleteReq.statusCode);
    if(deleteReq.statusCode==200){
      print("Success!");
    }
    var data = json.decode(response.body);
    _result=data["result"].toString();
    print("The result for timeline analysis is");
    print(_result.toString());
    var cleanResult = JsonReader().readjson(_result);
    print("干净结果:");
    print(current_path);
    print(cleanResult);
    print(cleanResult.keys);


    var dirNum = current_path.split('/').length;
    var store_path = "";
    for (var i=0;i<dirNum-1;i++){
      if (i!=dirNum-2){
        store_path = store_path + current_path.split('/')[i] + '/';
      }
      else{
        store_path = store_path + current_path.split('/')[i];
      }
    }

    print(store_path);


    print(data["result"]);
    var resultDic = data["result"];
    Map resultMap = json.decode(resultDic);
    print(resultMap.toString());
    var n = 0;
    var m = 0;
    var tempList = [];

    for (var key in resultMap.keys){
      var value = resultMap[key];
      var pieces = value.split(";");
      print("检测到不同说话人");

      var newPath = store_path + '/' + n.toString() + "_merge" + ".wav";

      // 新建空音频
      var waveBuilder = WaveBuilder();
      var silenceType = WaveBuilderSilenceType.BeginningOfLastSample;
      print("新建 waveBuilder");
      //waveBuilder.appendSilence(1000, silenceType);

      var firstPiecePath;
      var moreThanOne = false;

      for (var piece in pieces){
        var _start = piece.split("==>")[0];
        var _end = piece.split("==>")[1];
        _start = _start.split(":")[1];
        _end = _end.split(":")[1];
        print("开始和结束：");
        print(_start + _end);

        var start = double.parse('$_start');
        var end = double.parse('$_end');
        var cutPath = store_path + '/' + m.toString() + ".wav";

        if(start > end){
          start = start + 0.1;
        }

        print("切割中。。。切割的路径：");
        print(current_path);
        var outputFilePath = await MyAudioCutter.cutAudio(cutPath, current_path, start, end);

        tempList.add(outputFilePath);

        // 粘贴音频
        /*
        var audio = File(outputFilePath);
        var addedAudio = await audio.readAsBytesSync();
        //var fileOut = File('./example/assets/out/test.wav');
        waveBuilder.appendFileContents(addedAudio);
        waveBuilder.appendSilence(1000, silenceType);*/

        if (piece == pieces[0]){
          firstPiecePath = outputFilePath;
        }
        else{
          moreThanOne = true;

          var audio = File(newPath);

          // print("文件是否存在？？？");
          // print(io.File(firstPiecePath).exists().toString());
          // print(io.File(newPath).exists().toString());
          // print(io.File(outputFilePath).exists().toString());

          final FlutterFFmpeg _ffMpeg = FlutterFFmpeg();
          _ffMpeg.execute("-i " + firstPiecePath + " -i " + outputFilePath + " -c copy " + firstPiecePath)
              .then((return_code) => print("打印粘贴结果 $return_code"));

          print("在这里！！" + firstPiecePath);

        }
        tempList.add(firstPiecePath);

      }

      // 防止名字重复
      m = m + 1;

      //tempList.add(newPath);

      // 信息
      final FlutterFFprobe _flutterFFprobe = new FlutterFFprobe();
      Map info = await _flutterFFprobe.getMediaInformation(firstPiecePath);
      print("粘贴好的音频信息："+info.toString());


      // 播放测试剪辑过的音频
      print("播放 - "+firstPiecePath);
      print("大小是");
      print(File(firstPiecePath).lengthSync().toString());
      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.play(firstPiecePath, isLocal: true);

      //tempList.add(newPath);
      // 检测性别
      uuid = Uuid();

      final taskId = await uploader.enqueue(
          url: "http://192.168.0.111:5000/", //required: url to upload to
          files: [FileItem(filename:firstPiecePath.split("/").last, savedDir:store_path, fieldname:"file")], // required: list of files that you want to upload
          method: UploadMethod.POST, // HTTP method  (POST or PUT or PATCH)
          headers: {},
          // data: {"uuid": uuid.toString()}, // any data you want to send in upload request
          showNotification: false, // send local notification (android only) for upload status
          tag: "upload 3").timeout(Duration(seconds: 15));
      uploader.result.listen((result) async {
        print("性别检测回复：");
        print(result.response);
        print("删除音频");
        print(tempList.toString());
        for (var temp in tempList) {
          try {
            if (await File(temp).exists()) {
              await File(temp).delete();
            }
          } catch (e) {
            // Error in getting access to the file.
          }
        }
      }, onError: (ex, stacktrace) {
        print(stacktrace);
      });

      // 更新路径
      n = n + 1;

    }





    // 删除temp音频



    // Cutting experiments
    /*
    var timelineResult=JsonReader().readjson(_result);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TimeLine(result:timelineResult),
        )
    );*/
  }
  testAPI() async{
    uuid = Uuid();
    var filename=records[0].split("/").last;
    var path=records[0].replaceAll("/"+filename,"");
    final taskId = await uploader.enqueue(
        url: "http://192.168.0.111:5000/", //required: url to upload to
        files: [FileItem(filename:records[0].split("/").last, savedDir:path, fieldname:"file")], // required: list of files that you want to upload
        method: UploadMethod.POST, // HTTP method  (POST or PUT or PATCH)
        headers: {},
        // data: {"uuid": uuid.toString()}, // any data you want to send in upload request
        showNotification: false, // send local notification (android only) for upload status
        tag: "upload 2").timeout(Duration(seconds: 15));
    uploader.result.listen((result) {
      print("the response is: ...");
      print(result.response);
    }, onError: (ex, stacktrace) {
      print(stacktrace);
    });
  }
/*
  Future<String> _cutSong() async {
    var start = 0;
    var end = 0;
    String path = await _copyAssetAudioToLocalDir();

    // Close the keyboard.
    FocusScope.of(context).requestFocus(FocusNode());

    return await AudioCutter.cutAudio(
        path, double.parse(start), double.parse(end));
  }

  /// Copies the asset audio to the local app dir to be used elsewhere.
  Future<String> _copyAssetAudioToLocalDir() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/bensound-sunny.mp3';
    final File song = new File(path);

    if (!(await song.exists())) {
      final data = await rootBundle.load('assets/bensound-sunny.mp3');
      final bytes = data.buffer.asUint8List();
      await song.writeAsBytes(bytes, flush: true);
    }

    return path;
  }*/
}

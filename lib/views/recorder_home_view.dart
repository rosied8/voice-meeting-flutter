import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_reocrder/views/recorded_list_view.dart';
import 'package:voice_reocrder/views/recorder_view.dart';
import 'package:http/http.dart'as http;
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:uuid/uuid.dart';
import 'package:http_interceptor/http_interceptor.dart';

class RecorderHomeView extends StatefulWidget {
  final String _title;

  const RecorderHomeView({Key key, @required String title})
      : assert(title != null),
        _title = title,
        super(key: key);

  @override
  _RecorderHomeViewState createState() => _RecorderHomeViewState();
}

class _RecorderHomeViewState extends State<RecorderHomeView> {
  var uuid;
  Directory appDirectory;
  Stream<FileSystemEntity> fileStream;
  List<String> records;
  final uploader = FlutterUploader();
  var _result;

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
              url: "http://10.12.169.84/wave_factory/?uuid="+uuid.toString(), //required: url to upload to
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
    _result="";
    var url='http://10.12.169.84/wave_factory/?uuid=${uuid}';
    final response = await http.get(url);
    // _result=response.body.toString();
    print('The result of response is ${response.body}');
    // if(""==_result||("null"==_result)||("fail"==_result)||(":\"null\"}"==_result)){
    //   final response = await http.get(url);
    //   _result=response.body;
    //   print('the expected result is: ${_result}');
    // }
    final http.Response deleteReq = await http.delete(url);
    print('The response of delete request is${deleteReq}');
    print(deleteReq.statusCode);
    if(deleteReq.statusCode==200){
      print("Success!");
    }
  }
  testAPI() async{
    uuid = Uuid();
    var filename=records[0].split("/").last;
    var path=records[0].replaceAll("/"+filename,"");
    final taskId = await uploader.enqueue(
        url: "http://10.12.169.84:5000/", //required: url to upload to
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
}

import 'dart:collection';
class JsonReader {
  String a = "{\"0\": \"0:00.992==>0:32.192;0:43.828==>0:44.328;0:45.936==>1:12.21;1:18.625==>1:19.733\", \"1\": \"0:32.192==>0:43.828;0:44.328==>0:45.936;1:12.21==>1:18.625;1:19.733==>1:22.545\"}";

  int timeConvert(String time) {
    int min;
    int sec;
    int msec;
    List<String>minSec = time.split(':');
    print(minSec.toString());
    min = int.parse(minSec[0]);
    print(min.toString());
    List<String> secMsec = minSec[1].split(".");
    sec = int.parse(secMsec[0]);
    msec = int.parse(secMsec[1]);
    print(sec);
    print(msec);
    return msec + 1000 * sec + 60000 * min;
  }

  Map<List,int> readjson(String result){
    List<String> sentences = a.split(",");
    List<String> temp = List.filled(sentences.length, "");
    int numOfSpeaker = sentences.length;
    int start = 0;
    for (String sentence in sentences) {
      sentence = sentence.replaceAll("\"", "").replaceAll("\\{", "").replaceAll(
          "\\}", "").replaceAll("}", "");
      sentence = sentence.substring(3);
      temp[start] = sentence;
      start++;
    }
    Map<List<int>,int> finalTimeLine=new Map();
    int speakerNo = 1;
    for (String sentence in temp) {
      List<String> timeline = sentence.split(";");
      print(timeline);
      for (String times in timeline) {
        print(times);
        List<String> startEnd = times.split("==>");
        int start = timeConvert(startEnd[0]);
        int end = timeConvert(startEnd[1]);
        List<int> startFinish = List.filled(2, 0);
        startFinish[0] = start;
        startFinish[1] = end;
        // Add the speaker Id to the start time and finish time of each speech
        // finalTimeLine.add(speakerNo,startFinish);
        print("This is result of time line");
        print(startFinish.toString());
        print(speakerNo.toString());
        finalTimeLine[startFinish] = speakerNo;
        print(finalTimeLine.toString());
      }
      speakerNo++;
    }
    print(finalTimeLine);
    var newMap = Map.fromEntries(finalTimeLine.entries.toList()..sort((e1, e2) =>
        (e1.key[0]).compareTo(e2.key[0])));
    print(newMap.toString());
    return newMap;
  }
}
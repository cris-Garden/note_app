import 'dart:io';
import 'package:flutter_app/util/file_util.dart';
import 'package:path/path.dart' as p;

class Diary {
  static final splitString = '&%&!';
  static final imagePreString = '#%#!Image_';

  Diary({this.path}) {
    print(path);

    file = File(path);
    fileName = p.basenameWithoutExtension(path);

    createDateTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(p.basenameWithoutExtension(path)));

//    print('${createDateTime.year}年${createDateTime.month}月${createDateTime.day}日${createDateTime.hour}時${createDateTime.minute}分${createDateTime.microsecond}秒');
    name =
        '${createDateTime.year}年${createDateTime.month}月${createDateTime.day}日${createDateTime.hour}時${createDateTime.minute}分${createDateTime.microsecond}秒';
    dataString = file.readAsStringSync();
    final dataList = dataString.split(splitString);
    if(dataList.length == 1 && dataList[0]==''){
      return;
    }
    textList.addAll(dataList);
  }

  String path;

  String name;

  String fileName;

  File file;

  DateTime createDateTime;

  DateTime updateTime;

  String dataString;

  // 'text' 'image_xxx'
  List<String> textList = [];

  void save() {
    dataString = '';
    for (int i = 0; i < textList.length; i++) {
      if (i == textList.length - 1) {
        dataString = dataString + textList[i];
      } else {
        dataString = dataString + textList[i] + splitString;
      }
    }
    file.writeAsStringSync(dataString, flush: true);
  }
}

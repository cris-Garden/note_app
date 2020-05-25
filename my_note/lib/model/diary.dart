import 'dart:io';
import 'package:my_note/util/file_util.dart';
import 'package:path/path.dart' as p;

class Diary {
  static final splitString = '&%&!';
  static final imagePreString = '#%#!Image_';
  static final titlePreString = '####_';

  Diary({this.path}) {
    print(path);

    file = File(path);
    fileName = p.basenameWithoutExtension(path);

    createDateTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(p.basenameWithoutExtension(path)));

//    print('${createDateTime.year}年${createDateTime.month}月${createDateTime.day}日${createDateTime.hour}時${createDateTime.minute}分${createDateTime.microsecond}秒');
    createTimeString =
        '${createDateTime.year}年${createDateTime.month}月${createDateTime.day}日';
    dataString = file.readAsStringSync();
    final dataList = dataString.split(splitString);
    if(dataList.length == 1 && dataList[0]==''){
      //新規の時、ディフォルトファイルタイトル
      title = '見出し';
      return;
    }else{
      title = dataList.first.split('_').last;
    }

    textList.addAll(dataList..removeAt(0));
  }

  String path;

  String title;

  String createTimeString;

  //1590112372085.txt => 1590112372085,
  String fileName;

  File file;

  DateTime createDateTime;

  DateTime updateTime;

  String dataString;

  // 'text' 'image_xxx'
  List<String> textList = [];

  void save() {
    dataString = '$titlePreString$title' + splitString;
    for (int i = 0; i < textList.length; i++) {
      if (i == textList.length - 1) {
        dataString = dataString + textList[i];
      } else {
        dataString = dataString + textList[i] + splitString;
      }
    }
    file.writeAsStringSync(dataString, flush: true);
  }

  void delete(){
    //delete txt
    file.deleteSync();
    //delete Image
    final imagePath =
    FileUtil().fileFromDocsDir('image/$fileName');
    Directory(imagePath)..deleteSync(recursive: true);

  }
}

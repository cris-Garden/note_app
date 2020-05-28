import 'dart:convert';
import 'dart:io';
import 'package:my_note/model/section.dart';
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
    final dataString = file.readAsStringSync();
    final dataList = dataString.split(splitString);
    if(dataList.length == 1 && dataList[0]==''){
      //新規の時、ディフォルトファイルタイトル
      title = '見出し';
      return;
    }else{
      title = dataList.first.split('_').last;
    }

    //老版本解析适配
    if(dataString.startsWith(titlePreString)){
      for(final data in dataList) {
        //原title
        if(data.startsWith(titlePreString)){
          sections.add(Section(title:data.split('_').last,type: SectionType.title));
          continue;
        }
        //原图片
        if(data.startsWith(imagePreString)){
          sections.add(Section(imagePath:data.split('_').last,type: SectionType.image));
          continue;
        }
        //原文本
        sections.add(Section(text:data,type: SectionType.text));
      }
    }else{
      //新版本解析适配
      final mapsList = jsonDecode(dataString) as List;
      print(mapsList);
      sections = List.generate(mapsList.length, (index){
        final map  = mapsList[index] as Map;
        return Section.from(map);
      });
      print(sections);

    }

  }

  List<Section> sections = [];

  String path;

  String title;

  String createTimeString;

  //1590112372085.txt => 1590112372085,
  String fileName;

  File file;

  DateTime createDateTime;

  DateTime updateTime;

  void save() {

     final dataString = jsonEncode(sections);
     print('dataString:$dataString');
     file.writeAsStringSync(dataString, flush: true);
  }

  Future<void> delete() async{
    //delete txt
    await file.delete();
    //delete Image
    final imagePath =
    FileUtil().fileFromDocsDir('image/$fileName');
    final imageDirectory = Directory(imagePath);
    final  hasDirectory = await imageDirectory.exists();
    if(hasDirectory){
      await imageDirectory.delete(recursive: true);
    }
  }
}

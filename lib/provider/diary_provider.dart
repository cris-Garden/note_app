import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/model/diary.dart';
import 'package:flutter_app/util/file_util.dart';



class DiaryProvider with ChangeNotifier {



  String fileName;

  String title;

  String context;

  Diary diary;

  int index = 1000;

  File _file;

  DiaryProvider(this.diary) {
//    FileUtil util = FileUtil();
//
//    final list = util.appDocsDir.listSync();
//    for(final a in list){
//      print(a);
//    }
//    if(fileName == null){
//      //新規
//      print('time ${DateTime.now().millisecondsSinceEpoch}');
//      _file = File(util.fileFromDocsDir('diary/${DateTime.now().millisecondsSinceEpoch}.txt'));
//      _file.createSync(recursive: true);
//      print(_file);
//    }else{
//      _file = File(util.fileFromDocsDir('diary/fileName.txt'));
//    }
//    diary = Diary(path:fileName);
//    diary.textList = this.context.split(splitString);
//    for (final a in diary.textList) {
//      diary.objectList.add(null);
//    }
//    diary.textList.add('image');
//
//    diary.objectList.add(File(FileUtil().fileFromDocsDir('abcd.png')));
  }



  void addText() {
    if (index == 1000) {
      diary.textList.add('');
    } else {
      int insert = index + 1 > diary.textList.length
          ? (diary.textList.length - 1 > 0 ? diary.textList.length - 1 : 0)
          : index + 1;
      diary.textList.insert(insert, '');
    }

    notifyListeners();
  }

  void saveText(String text,int index) {
    diary.textList[index] = text;
  }

  void saveDiary() {
    diary.save();
    notifyListeners();
  }

  void addImage(File image) {
    if (image == null) return;

    final imageName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final imagePath = FileUtil().fileFromDocsDir('image/${diary.fileName}/$imageName');
    File(imagePath).createSync(recursive: true);
    image.copy(imagePath).then((newFile) {
      if (index == 1000) {
        diary.textList.add('${Diary.imagePreString}$imageName');
      } else {
        int insert = index + 1 > diary.textList.length
            ? (diary.textList.length - 1 > 0 ? diary.textList.length - 1 : 0)
            : index + 1;
        diary.textList.insert(insert, '${Diary.imagePreString}$imageName');
      }

      print(newFile);
      notifyListeners();
    });
  }

  void delete() {
    if (index == 1000) return;
    if (diary.textList.length == 0) return;
    diary.textList.removeAt(index);
    index = 1000;
    notifyListeners();
  }

  String imagePath(int index){
    final imageName = diary.textList[index].split('_').last;
    final imagePath = FileUtil().fileFromDocsDir('image/${diary.fileName}/$imageName');
    return imagePath;
  }
}



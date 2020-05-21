import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/model/diary.dart';
import 'package:flutter_app/util/file_util.dart';



class DiaryProvider with ChangeNotifier {


  bool didChange = false;

  bool isEditing = false;

  Diary diary;

  int index = 1000;

  void changeEditing(){
    didChange = true;
    isEditing = !isEditing;
    saveDiary();
  }

  DiaryProvider(this.diary);



  void addText() {
    if (index == 1000) {
      diary.textList.add('');
    } else {
      int insert = index + 1 > diary.textList.length
          ? (diary.textList.length - 1 > 0 ? diary.textList.length - 1 : 0)
          : index + 1;
      diary.textList.insert(insert, '');
    }
    didChange = false;
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
      didChange = false;
      notifyListeners();
    });
  }

  void delete() {
    if (index == 1000) return;
    if (diary.textList.length == 0) return;
    final text = diary.textList[index];
    if(text.startsWith(Diary.imagePreString)){
      final imageName = diary.textList[index].split('_').last;
      final imagePath = FileUtil().fileFromDocsDir('image/${diary.fileName}/$imageName');
      File(imagePath).delete();
    }
    diary.textList.removeAt(index);
    index = 1000;
    didChange = false;
    notifyListeners();
  }

  String imagePath(int index){
    final imageName = diary.textList[index].split('_').last;
    final imagePath = FileUtil().fileFromDocsDir('image/${diary.fileName}/$imageName');
    return imagePath;
  }
}



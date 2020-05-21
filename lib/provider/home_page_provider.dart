import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/model/diary.dart';
import 'package:flutter_app/util/file_util.dart';

class HomePageProvider with ChangeNotifier {

  bool changeFlag = false;

  List<String> diaryFilePaths = FileUtil().diaryFiles;

  List<Diary> diarys = List.generate(FileUtil().diaryFiles.length, (index) {
      return Diary(path: FileUtil().diaryFiles[index]);
    });

  Diary newDiary(){
      final filePath = FileUtil().fileFromDocsDir('diary/${DateTime.now().millisecondsSinceEpoch}.txt');
      final file = File(filePath);
      file.createSync(recursive: true);
      final diary = Diary(path: filePath);
      diarys.insert(0, diary);
      diary.save();
      return diary;
  }

  void didChange(){
    changeFlag = !changeFlag;
    notifyListeners();
  }

}

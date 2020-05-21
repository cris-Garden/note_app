import 'package:flutter/material.dart';
import 'package:flutter_app/model/diary.dart';
import 'package:flutter_app/util/file_util.dart';

class HomePageProvider with ChangeNotifier {
  bool changeFlag = false;

  List<String> diaryFilePaths = FileUtil().diaryFiles;
  List<Diary> get diarys{
    return List.generate(diaryFilePaths.length, (index) {
      return Diary(path: diaryFilePaths[index]);
    });
  }

}

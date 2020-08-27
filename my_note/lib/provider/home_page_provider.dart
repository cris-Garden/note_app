import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_note/model/diary.dart';
import 'package:my_note/util/file_util.dart';

class HomePageProvider with ChangeNotifier {
  bool changeFlag = false;

  void doChange() {
    changeFlag = true;
    notifyListeners();
  }

  List<String> diaryFilePaths = FileUtil().diaryFiles;

  List<Diary> diarys = List.generate(FileUtil().diaryFiles.length, (index) {
    return Diary(path: FileUtil().diaryFiles[index]);
  });

  Diary newDiary() {
    final filePath = FileUtil()
        .fileFromDocsDir('diary/${DateTime.now().millisecondsSinceEpoch}.txt');
    final file = File(filePath);
    file.createSync(recursive: true);
    final diary = Diary(path: filePath);
    diarys.insert(0, diary);
    diary.save();
    return diary;
  }

  void didChange() {
    changeFlag = !changeFlag;
    notifyListeners();
  }

  Map<String, List<Diary>> get diaryTimeMap {
    Map<String, List<Diary>> map = {};
    for (final diary in diarys) {
      if (map[diary.createTimeString] == null) {
        map[diary.createTimeString] = <Diary>[];
      }
      map[diary.createTimeString].add(diary);
    }
    return map;
  }
}

import 'dart:async' show Future;
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:my_note/model/diary.dart';
import 'package:my_note/util/file_util.dart';
import 'package:my_note/util/user_defaults.dart';

class GuideUtil {

  Diary useDiary;
  Diary backUpDiary;
  static final GuideUtil _util = GuideUtil._internal();

  GuideUtil._internal();

  factory GuideUtil() {
    return _util;
  }

  Future<Diary> getUserDiary() async{
    //初始化使用说明
    //get diary data
    final diaryData = await rootBundle.loadString('assets/use.txt');
    return Diary.initFromString(diaryData)..isLocalDiary = true;
  }

  Future<Diary> getBackUpUseDiary() async {
    //初始化使用说明
    //get diary data
    final diaryData = await rootBundle.loadString('assets/backup.txt');
    return Diary.initFromString(diaryData)..isLocalDiary = true;
  }

}

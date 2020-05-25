import 'dart:async' show Future;
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:my_note/util/file_util.dart';
import 'package:my_note/util/user_defaults.dart';

class GuideUtil {
  static final GuideUtil _util = GuideUtil._internal();

  GuideUtil._internal();

  factory GuideUtil() {
    return _util;
  }

  Future<void> init() async {
    final isInit = await UserDefaults().getBoolData('guide_init');
    if (isInit == null || isInit == false) {
      print('not init');

      //get diary data
      final guide1 = await rootBundle.load('assets/images/guide1.png');
      final guide2 = await rootBundle.load('assets/images/guide2.png');
      final diaryData = await rootBundle.loadString('assets/1590365233267.txt');

      //write data
      final fileUti = FileUtil();
      await fileUti.writeImage('guide1.png', '1590365233267', guide1);
      await fileUti.writeImage('guide2.png', '1590365233267', guide2);
      await fileUti.writeDiary('1590365233267.txt', diaryData);
      UserDefaults().saveBoolData('guide_init', true);
    }
  }
}

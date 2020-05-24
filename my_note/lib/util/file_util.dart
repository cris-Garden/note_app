import 'dart:io';

import 'package:path/path.dart' as p;

class FileUtil {
  static final FileUtil _util = FileUtil._internal();

  FileUtil._internal();

  factory FileUtil(){
    return _util;
  }

  Directory appDocsDir;

  String fileFromDocsDir(String filename) {
    String pathName = p.join(appDocsDir.path, filename);
    return pathName;
  }

  List<String> get diaryFiles{
    final diaryPath = fileFromDocsDir('diary');
    final  diaryDirectory = Directory(diaryPath);
    diaryDirectory.createSync(recursive: true);
    final subFiles = diaryDirectory.listSync();
    return List.generate(subFiles.length, (index){
      return subFiles[index].path.endsWith('.txt')?subFiles[index].path:null;
    })..removeWhere((element) => element==null);
  }

}
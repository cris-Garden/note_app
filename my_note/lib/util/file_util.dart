import 'dart:io';

import 'package:flutter/services.dart';
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

  //
  Future<void> writeImage(String name, String diaryFileName,ByteData data) async {
    
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final imagePath =
    FileUtil().fileFromDocsDir('image/$diaryFileName/$name');
    final file = File(imagePath);
    if(file.existsSync()) return;
    final newFile  = await file.create(recursive: true);
    await newFile.writeAsBytes(bytes);
  }

  Future<void> writeDiary(String diaryName,String diaryData) async
  {
    final diaryPath = FileUtil().fileFromDocsDir('diary/$diaryName');
    final file = File(diaryPath);
    if(file.existsSync()) return;
    final newFile  = await file.create(recursive: true);
    await newFile.writeAsString(diaryData);
  }
}
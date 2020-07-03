import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:path/path.dart' as p;

class FileUtil {
  static final FileUtil _util = FileUtil._internal();

  FileUtil._internal();

  factory FileUtil(){
    return _util;
  }

  Directory appDocsDir;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return image;
  }

  //输入图片名字例：和日志名字：1590655478140.png例：1590638902713
  String imagePath(String diaryName,String path) {
    if(path == null){
      return null;
    }
    final imagePath =
    fileFromDocsDir('image/$diaryName/$path');
    return imagePath;
  }

  //截取长屏到本地
  Future<void> capturePng(GlobalKey rootWidgetKey) async {
    try {
      RenderRepaintBoundary boundary =
      rootWidgetKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      String dataImagePath = await ImagePickers.saveByteDataImageToGallery(
        pngBytes,
      );
    } catch (e) {
      print(e);
    }
    return;
  }

  String fileFromDocsDir(String filename) {
    String pathName = p.join(appDocsDir.path, filename);
    return pathName;
  }

  //获取用户日志的分类
  List<String> get userDiaryCategory{
    final diaryPath = fileFromDocsDir('diary');
    final  diaryDirectory = Directory(diaryPath);
    diaryDirectory.createSync(recursive: true);
    final subFiles = diaryDirectory.listSync();
    return List.generate(subFiles.length, (index){
      final path = p.basenameWithoutExtension(subFiles[index].path);
      if(path.startsWith('user_')){
        return path.replaceFirst('user_', '');
      }
      return null;

    })..removeWhere((element) => element==null);
  }

  //获取系统日志的分类下的日志
  List<String> get systemDiarys{
    final diaryPath = fileFromDocsDir('diary');
    final  diaryDirectory = Directory(diaryPath);
    diaryDirectory.createSync(recursive: true);
    final subFiles = diaryDirectory.listSync();
    final file = subFiles.firstWhere((element){
      final path = p.basenameWithoutExtension(element.path);
      return path.startsWith('sys_');
    });
    final  systemDirectory = Directory(file.path);
    final systemDiary = systemDirectory.listSync();
    return List.generate(systemDiary.length, (index){
      return systemDiary[index].path.endsWith('.txt')?subFiles[index].path:null;
    })..removeWhere((element) => element==null);
  }

  List<String> get diaryFiles {
    final diaryPath = fileFromDocsDir('diary');
    final  diaryDirectory = Directory(diaryPath);
    diaryDirectory.createSync(recursive: true);
    final subFiles = diaryDirectory.listSync();
    return List.generate(subFiles.length, (index){
      return subFiles[index].path.endsWith('.txt')?subFiles[index].path:null;
    })..removeWhere((element) => element==null);
  }

  List<String> diaryFilesFromDirectory(String fileName) {
    final diaryPath = fileFromDocsDir('diary/user_$fileName');
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

  void delete(){
    final files = appDocsDir.listSync();
    for(final file in files){
      print(file);
      if(file.path.endsWith('.png')||file.path.endsWith('.PNG')){
        file.deleteSync();
      };

    }
  }
}
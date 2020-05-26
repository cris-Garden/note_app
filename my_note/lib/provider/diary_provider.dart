import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_note/model/diary.dart';
import 'package:my_note/util/file_util.dart';

class DiaryProvider with ChangeNotifier {
  bool didChange = false;

  bool isEditing = false;

  Diary diary;

  int index = 1000;

  void setIndex(int newIndex) {
    index = newIndex;
    doChange();
  }

  void doChange() {
    didChange = true;
    notifyListeners();
  }

  void changeEditing() {
    didChange = true;
    isEditing = !isEditing;
    saveDiary();
  }

  DiaryProvider(this.diary);

  void addText() {
    if (index == 1000) {
      diary.textList.add('');
      index = diary.textList.length - 1;
    } else {
      int insert = index + 1 > diary.textList.length
          ? (diary.textList.length - 1 > 0 ? diary.textList.length - 1 : 0)
          : index + 1;
      diary.textList.insert(insert, '');
      index = index + 1;
    }
    didChange = false;
    notifyListeners();
  }

  void saveText(String text, int index) {
    diary.textList[index] = text;
    diary.save();
  }

  void saveDiary() {
    diary.save();
    notifyListeners();
  }

  void up() {
    if (index == 0 || index == 1000) {
      return;
    }
    final a = diary.textList[index];
    diary.textList[index] = diary.textList[index - 1];
    diary.textList[index - 1] = a;
    diary.save();
    index = index - 1;
    didChange = true;
    notifyListeners();
  }

  void down() {
    print(index);
    if (index == diary.textList.length - 1 || index == 1000) {
      return;
    }
    final a = diary.textList[index];
    diary.textList[index] = diary.textList[index + 1];
    diary.textList[index + 1] = a;
    diary.save();
    index = index + 1;
    didChange = true;
    notifyListeners();
  }

  void addImage(File image, {Function didSave}) {
    if (image == null) return;

    final imageName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final imagePath =
        FileUtil().fileFromDocsDir('image/${diary.fileName}/$imageName');
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
      diary.save();
      if (didSave != null) {
        didSave();
      }
      didChange = false;
      notifyListeners();
    });
  }

  Future<void> deleteDiary() async{
    await diary.delete();
  }

  void delete() {
    if (index == 1000) return;
    if (diary.textList.length == 0) return;
    final text = diary.textList[index];
    if (text.startsWith(Diary.imagePreString)) {
      final imageName = diary.textList[index].split('_').last;
      final imagePath =
          FileUtil().fileFromDocsDir('image/${diary.fileName}/$imageName');
      File(imagePath).delete();
    }
    diary.textList.removeAt(index);
    index = 1000;
    didChange = false;
    notifyListeners();
  }

  String imagePath(int index) {
    final imageName = diary.textList[index].split('_').last;
    final imagePath =
        FileUtil().fileFromDocsDir('image/${diary.fileName}/$imageName');
    return imagePath;
  }
}

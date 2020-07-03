import 'dart:io';
import 'package:my_note/model/diary.dart';
import 'package:my_note/model/section.dart';
import 'package:my_note/provider/base/base_provider.dart';
import 'package:my_note/util/file_util.dart';
import 'package:my_note/widget/section/card_view.dart';

class DiaryProvider extends BaseProvider {

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
    final addSection = Section(text:'',type: SectionType.text);
    this.addSection(addSection);
  }

  void addSection(Section addSection){
    if (index == 1000) {
      diary.sections.add(addSection);
      index = diary.sections.length - 1;
    } else {
      int insert = index + 1 > diary.sections.length
          ? (diary.sections.length - 1 > 0 ? diary.sections.length - 1 : 0)
          : index + 1;
      diary.sections.insert(insert, addSection);
      index = index + 1;
    }
    didChange = false;
    notifyListeners();
  }

  void addCard(CardViewType type) {
    SectionType sectionType;
    switch(type){
      case CardViewType.TopImage:
        sectionType = SectionType.topImageCard;
        break;
      case CardViewType.BottomImage:
        sectionType = SectionType.bottomImageCard;
        break;
      case CardViewType.LeftImage:
        sectionType = SectionType.leftImageCard;
        break;
      case CardViewType.RightImage:
        sectionType = SectionType.rightImageCard;
        break;
    }

    final addSection = Section(text:'',type: sectionType);
    this.addSection(addSection);
  }

  void saveText(String text, int index) {
    diary.sections[index].text = text;
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
    final a = diary.sections[index];
    diary.sections[index] = diary.sections[index - 1];
    diary.sections[index - 1] = a;
    diary.save();
    index = index - 1;
    didChange = true;
    notifyListeners();
  }

  void down() {
    print(index);
    if (index == diary.sections.length - 1 || index == 1000) {
      return;
    }
    final a = diary.sections[index];
    diary.sections[index] = diary.sections[index + 1];
    diary.sections[index + 1] = a;
    diary.save();
    index = index + 1;
    didChange = true;
    notifyListeners();
  }

  //创建并添加图片到日志文件
  void addImage(File image, {Function didSave}) async {
    if (image == null) return;

    final imageName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final imagePath =
        FileUtil().fileFromDocsDir('image/${diary.fileName}/$imageName');
    await File(imagePath).create(recursive: true);
    image.copy(imagePath).then((newFile) {
      final addImageSection = Section(imagePath:imageName,type: SectionType.image);
      this.addSection(addImageSection);
      print(newFile);
      diary.save();
      if (didSave != null) {
        didSave();
      }
    });
  }

  //指定section图片到日志文件
  void addImageTo(Section section,File image, {Function didSave}) async {
    if (image == null) return;

    final imageName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final imagePath =
    FileUtil().fileFromDocsDir('image/${diary.fileName}/$imageName');
    await File(imagePath).create(recursive: true);
    image.copy(imagePath).then((newFile) {
      section.imagePath = imageName;
      diary.save();
      if (didSave != null) {
        didSave();
      }
    });
  }
  

  void delete() {
    if (index == 1000) return;
    if (diary.sections.length == 0) return;
    final section = diary.sections[index];
    if (section.type == SectionType.image) {
      final imageName = section.imagePath;
      final imagePath =
          FileUtil().fileFromDocsDir('image/${diary.fileName}/$imageName');
      File(imagePath).delete();
    }
    diary.sections.removeAt(index);
    index = 1000;
    didChange = false;
    notifyListeners();
  }

  String imagePath(String path) {
    final imagePath =
        FileUtil().fileFromDocsDir('image/${diary.fileName}/$path');
    return imagePath;
  }
}

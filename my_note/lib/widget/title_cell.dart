import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_note/model/diary.dart';
import 'package:my_note/model/section.dart';
import 'package:my_note/util/file_util.dart';

class TitleCell extends StatelessWidget {
  TitleCell(
    this.diary, {
    this.onTap,
    this.showTopLine = false,
    this.showBottomLine = true,
  });
  final VoidCallback onTap;
  final Diary diary;
  final bool showTopLine;
  final bool showBottomLine;
  @override
  Widget build(BuildContext context) {
    String title;
    List<String> images = [];
    for (final section in diary.sections) {
      if (section.type == SectionType.image) {
        images.add(section.imagePath);
      } else if (section.type == SectionType.text){
        title = title == null ? section.text : title;
      }
    }
    bool hasTitle = title != null && title.length != 0;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          showTopLine?Divider(
            height: 2,
            indent: 8,
            color: Colors.grey,
          ):null,
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: Text(
              diary.title,
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.left,
            ),
          ),
          hasTitle
              ? Container(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 8,
                  ),
                )
              : null,
          images.length > 0
              ? Container(
                  padding: const EdgeInsets.all(8),
                  height: 90,
                  child: GridView.count(
                    //滚动方向
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    children:
                        List.generate([images.length, 4].reduce(min), (index) {
                      final imageName = images[index].split('_').last;
                      final imagePath = FileUtil().fileFromDocsDir(
                          'image/${diary.fileName}/$imageName');
                      return Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                      );
                    }),
                  ))
              : null,
          showBottomLine?Divider(
            height: 2,
            indent: 8,
            color: Colors.grey,
          ):null,
        ]..removeWhere((element) => element == null),
      ),
    );
  }
}

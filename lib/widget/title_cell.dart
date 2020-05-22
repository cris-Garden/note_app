import 'dart:io';
import 'dart:math';
import 'package:flutter_app/util/file_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/diary.dart';


class TitleCell extends StatelessWidget {
  TitleCell(
    this.diary, {
    this.onTap,
  });
  final VoidCallback onTap;
  final Diary diary;
  @override
  Widget build(BuildContext context) {
    String title;
    List<String> images = [];
    for (final a in diary.textList) {
      if (a.startsWith(Diary.imagePreString)) {
        images.add(a);
      } else {
        title = title == null ? a : title;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(diary.title),
          title != null ? Text(title) : null,
          images.length > 0
              ? GridView.count(
            shrinkWrap: false,
                  crossAxisCount: 4,
                  children: List.generate([images.length,4].reduce(min), (index) {
                    final imageName = images[index].split('_').last;
                    final imagePath = FileUtil().fileFromDocsDir('image/${diary.fileName}/$imageName');
                    return Image.file(File(imagePath));
                  }),
                )
              : null,
        ]..removeWhere((element) => element == null),
      ),
    );
  }
}

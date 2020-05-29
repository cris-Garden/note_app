import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_note/model/diary.dart';
import 'package:my_note/model/section.dart';
import 'package:my_note/util/file_util.dart';

class TitleCell extends StatelessWidget {
  TitleCell(
    this.diary, {
    this.onTap,
    this.onDelete,
  });
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final Diary diary;
  @override
  Widget build(BuildContext context) {
    String title;
    List<String> images = [];
    for (final section in diary.sections) {
      if (section.type == SectionType.image) {
        images.add(section.imagePath);
      } else if (section.type == SectionType.text) {
        title = title == null ? section.text : title;
      }
    }

    final imageName = images.length > 0 ? images.last : null;
    final imagePath =
        FileUtil().fileFromDocsDir('image/${diary.fileName}/$imageName');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 16, top: 16, right: 16),
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          //侧滑删除设置
          secondaryActions: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: IconSlideAction(
                caption: '删除',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("提示"),
                        content: Text("是否删除该日记？"),
                        actions: <Widget>[
                          // ボタン領域
                          FlatButton(
                            child: Text("Cancel"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          FlatButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.pop(context);
                                if(this.onDelete != null){
                                  onDelete();
                                }
                                print('删除click');
                              }
                          ),
                        ],
                      );
                    },
                  );

                },
              ),
            ),
          ],
          child: Card(
            elevation: 8,
            child: Container(
              width: double.infinity,
              height: 130,
              child: Row(
                children: <Widget>[
                  Card(
                    child: Container(
                      height: 120,
                      width: 120,
                      child: images.length == 0
                          ? Image.asset('assets/images/default.jpg')
                          : Image.file(
                              File(imagePath),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 130,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(left: 16, top: 8),
                            child: Text(
                              diary.title,
                              style: Theme.of(context).textTheme.headline2,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 16, top: 8, right: 16, bottom: 8),
                            child: Text(
                              title ?? '',
                              style: Theme.of(context).textTheme.bodyText1,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

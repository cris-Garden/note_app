import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/model/diary.dart';
import 'package:flutter_app/provider/diary_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DiaryDetailPage extends StatelessWidget with RouteAware {
  DiaryDetailPage(this.diary);

  final Diary diary;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DiaryProvider(diary),
      child: Selector<DiaryProvider, DiaryProvider>(
        shouldRebuild: (pre, next) {
          return next.didChange;
        },
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title: TextField(
                controller: TextEditingController(text: provider.diary.title,),
                decoration: null,
                textAlign: TextAlign.center,
                maxLines: 1,
                onChanged: (value){
                  diary.title = value;
                },
              ),
              actions: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  child: GestureDetector(
                      onTap: () {
                        provider.changeEditing();
                      },
                      child: Text(
                        provider.isEditing ? '完了' : '編集',
                        style: Theme.of(context).textTheme.button,
                      )),
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                provider.isEditing
                    ? Container(
                        width: double.infinity,
                        color: Colors.grey,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                              child: Icon(
                                Icons.text_fields,
                                size: 40.0,
                              ),
                              onTap: () {
                                provider.addText();
                              },
                            ),
                            GestureDetector(
                              child: Icon(
                                Icons.image,
                                size: 40.0,
                              ),
                              onTap: () {
                                getImage().then((image) {
                                  provider.addImage(image);
                                });
                              },
                            ),
                            GestureDetector(
                              child: Icon(
                                Icons.delete,
                                size: 40.0,
                              ),
                              onTap: () {
                                provider.delete();
                              },
                            ),
                            GestureDetector(
                              child: Icon(
                                Icons.save,
                                size: 40.0,
                              ),
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                provider.saveDiary();
                              },
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Selector<DiaryProvider, int>(
                  selector: (_, provider) => provider.diary.textList.length,
                  builder: (context, count, child) {
                    return Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, item) {
                          if (provider.diary.textList[item]
                              .startsWith(Diary.imagePreString)) {
                            return GestureDetector(
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 8, right: 8, top: 8, bottom: 8),
                                width: double.infinity,
                                height: 180,
                                child: Image.file(
                                  File(provider.imagePath(item)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              onTap: () {
                                provider.index = item;
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                            );
                          }
                          return Container(
                            padding: EdgeInsets.only(
                                left: 8, top: 8, right: 8, bottom: 8),
                            child: TextField(
                              enabled: provider.isEditing,
                              controller: TextEditingController(
                                  text: provider.diary.textList[item]),
                              decoration: null,
                              maxLines: null,
                              onChanged: (value) {
                                provider.saveText(value, item);
                              },
                              onSubmitted: (value) {
                                provider.index = 1000;
                              },
                              onTap: () {
                                print(item);
                                provider.index = item;
                              },
                            ),
                          );
                        },
                        itemCount: count,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
        selector: (_, provider) => provider,
      ),
    );
  }
}

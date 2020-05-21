import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/model/diary.dart';
import 'package:flutter_app/provider/diary_provider.dart';
import 'package:flutter_app/util/file_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DiaryDetailPage extends StatelessWidget {

  DiaryDetailPage(this.diary);

  final Diary diary;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('note'),
        ),
        body: ChangeNotifierProvider(
            create: (_) => DiaryProvider(diary),
            child: Selector<DiaryProvider, DiaryProvider>(
              builder: (context, provider, _) {
                return Column(
                  children: <Widget>[
                    Container(
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
                            onTap: (){
                              FocusScope.of(context)
                                  .requestFocus(FocusNode());
                              provider.saveDiary();
                            },
                          ),
                        ],
                      ),
                    ),
                    Selector<DiaryProvider, int>(
                      selector: (_, provider) => provider.diary.textList.length,
                      builder: (context, count, child) {
                        return Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, item) {
                              if (provider.diary.textList[item].startsWith(Diary.imagePreString)) {
                                return GestureDetector(
                                  child: Container(
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
                              return TextField(
                                controller: TextEditingController(text: provider.diary.textList[item]),
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
                              );
                            },
                            itemCount: count,
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
              selector: (_, provider) => provider,
            )));
  }
}
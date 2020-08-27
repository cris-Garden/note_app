import 'package:flutter/material.dart';
import 'package:my_note/model/section.dart';
import 'package:my_note/provider/diary_provider.dart';
import 'package:my_note/provider/home_page_provider.dart';
import 'package:my_note/util/file_util.dart';
import 'package:my_note/widget/section/card_view.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'full_screen_view.dart';

class DiaryDetailWidget extends StatelessWidget {
  DiaryDetailWidget({this.rootWidgetKey});

  final GlobalKey rootWidgetKey;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DiaryProvider>(context);
    final homePageProvider = Provider.of<HomePageProvider>(context);
    return Selector<DiaryProvider, int>(
      selector: (_, provider) => provider.diary.sections.length,
      builder: (context, count, child) {
        final widgets = <Widget>[];
        for (int item = 0; item < provider.diary.sections.length; item++) {
          final section = provider.diary.sections[item];
          final diary = provider.diary;
          final imagePath = diary.isLocalDiary
              ? section.imagePath
              : FileUtil().imagePath(diary.fileName, section.imagePath);
          switch (section.type) {
            case SectionType.firstTitle:
              widgets.add(null);
              break;
            case SectionType.title:
              widgets.add(null);
              break;
            case SectionType.text:
              widgets.add(Container(
                decoration: item == provider.index
                    ? BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        border: Border.all(
                            color: Colors.blue, width: 1.5), // 边色与边宽度
                      )
                    : BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                      ),
                margin: EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: TextField(
                  style: Theme.of(context).textTheme.bodyText1,
                  enabled: provider.isEditing,
                  controller: TextEditingController(
                      text: provider.diary.sections[item].text),
                  decoration: provider.isEditing
                      ? InputDecoration(hintText: "输入你想要记录的内容...")
                      : null,
                  maxLines: null,
                  onChanged: (value) {
                    provider.saveText(value, item);
                  },
                  onSubmitted: (value) {
                    provider.setIndex(1000);
                    homePageProvider.doChange();
                  },
                  onTap: () {
                    print(item);
                    provider.setIndex(item);
                  },
                ),
              ));
              break;
            case SectionType.image:
              widgets.add(provider.isEditing
                  ? GestureDetector(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 240),
                        child: Container(
                          decoration: item == provider.index
                              ? BoxDecoration(
                                  border: Border.all(
                                      color: Colors.blue, width: 1.5), // 边色与边宽度
                                )
                              : null,
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 8, bottom: 8),
                          width: double.infinity,
                          child: diary.isLocalDiary
                              ? Image.asset(imagePath)
                              : Image.file(
                                  File(imagePath),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      onTap: () {
                        if (!provider.isEditing) {
                          return;
                        }
                        provider.setIndex(item);
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    )
                  : FullScreenView(
                      tag: 'image$item',
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 240),
                        child: Container(
                          decoration: item == provider.index
                              ? BoxDecoration(
                                  border: Border.all(
                                      color: Colors.blue, width: 1.5), // 边色与边宽度
                                )
                              : null,
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 8,
                            bottom: 8,
                          ),
                          width: double.infinity,
                          child: diary.isLocalDiary
                              ? Image.asset(imagePath)
                              : Image.file(
                                  File(imagePath),
                                  fit: BoxFit.fitWidth,
                                ),
                        ),
                      ),
                      fullChild: diary.isLocalDiary
                          ? Image.asset(imagePath)
                          : Image.file(
                              File(imagePath),
                              fit: BoxFit.cover,
                            ),
                    ));
              break;
            case SectionType.topImageCard:
              widgets.add(
                CardView(
                  useLocal: diary.isLocalDiary,
                  onChanged: (value) {
                    provider.saveText(value, item);
                  },
                  onSubmitted: (value) {
                    provider.setIndex(1000);
                    homePageProvider.doChange();
                  },
                  item: item,
                  enable: provider.isEditing,
                  type: CardViewType.TopImage,
                  imagePath: imagePath,
                  text: section.text,
                  imageClick: () {
                    FileUtil().getImage().then((image) {
                      provider.addImageTo(section, image, didSave: () {
                        homePageProvider.didChange();
                      });
                    });
                  },
                ),
              );
              break;
            case SectionType.bottomImageCard:
              widgets.add(
                CardView(
                  useLocal: diary.isLocalDiary,
                  onChanged: (value) {
                    provider.saveText(value, item);
                  },
                  onSubmitted: (value) {
                    provider.setIndex(1000);
                    homePageProvider.doChange();
                  },
                  item: item,
                  enable: provider.isEditing,
                  imagePath: imagePath,
                  text: section.text,
                  imageClick: () {
                    FileUtil().getImage().then((image) {
                      provider.addImageTo(section, image, didSave: () {
                        homePageProvider.didChange();
                      });
                    });
                  },
                  type: CardViewType.BottomImage,
                ),
              );
              break;
            case SectionType.leftImageCard:
              widgets.add(CardView(
                useLocal: diary.isLocalDiary,
                item: item,
                type: CardViewType.LeftImage,
                enable: provider.isEditing,
                imagePath: imagePath,
                text: section.text,
                imageClick: () {
                  FileUtil().getImage().then((image) {
                    provider.addImageTo(section, image, didSave: () {
                      homePageProvider.didChange();
                    });
                  });
                },
                onChanged: (value) {
                  provider.saveText(value, item);
                },
                onSubmitted: (value) {
                  provider.setIndex(1000);
                  homePageProvider.doChange();
                },
              ));
              break;
            case SectionType.rightImageCard:
              widgets.add(CardView(
                useLocal: diary.isLocalDiary,
                item: item,
                type: CardViewType.RightImage,
                enable: provider.isEditing,
                imagePath: imagePath,
                text: section.text,
                imageClick: () {
                  FileUtil().getImage().then((image) {
                    provider.addImageTo(section, image, didSave: () {
                      homePageProvider.didChange();
                    });
                  });
                },
                onChanged: (value) {
                  provider.saveText(value, item);
                },
                onSubmitted: (value) {
                  provider.setIndex(1000);
                  homePageProvider.doChange();
                },
              ));
              break;
          }
        }
        widgets.removeWhere((element) => element == null);
        return widgets.length == 0
            ? Container(
                width: double.infinity,
                height: 600,
              )
            : Column(
                children: widgets,
              );
      },
    );
  }
}

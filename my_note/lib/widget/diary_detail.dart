import 'package:flutter/material.dart';
import 'package:my_note/model/section.dart';
import 'package:my_note/provider/diary_provider.dart';
import 'package:my_note/provider/home_page_provider.dart';
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
          if (provider.diary.sections[item].type == SectionType.image) {
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
                        child: Image.file(
                          File(provider.imagePath(
                              provider.diary.sections[item].imagePath)),
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
                            left: 16, right: 16, top: 8, bottom: 8),
                        width: double.infinity,
                        child: Image.file(
                          File(provider.imagePath(
                              provider.diary.sections[item].imagePath)),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    fullChild: Image.file(
                      File(provider
                          .imagePath(provider.diary.sections[item].imagePath)),
                      fit: BoxFit.cover,
                    ),
                  ));
            continue;
          }
          if (provider.diary.sections[item].type == SectionType.firstTitle) {
            widgets.add(Container());
            continue;
          }
          widgets.add(Container(
            decoration: item == provider.index
                ? BoxDecoration(
                    border:
                        Border.all(color: Colors.blue, width: 1.5), // 边色与边宽度
                  )
                : null,
            padding: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
            child: TextField(
              style: Theme.of(context).textTheme.bodyText1,
              autofocus: item == provider.index,
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
        }
        return  Column(
            children: widgets,
          );
      },
    );
  }
}

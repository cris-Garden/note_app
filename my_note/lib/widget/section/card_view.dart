import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_note/provider/diary_provider.dart';
import 'package:provider/provider.dart';
import '../full_screen_view.dart';

class CardView extends StatelessWidget {
  CardView({
    this.type = CardViewType.TopImage,
    this.isEditing = false,
    this.enable = false,
    this.imagePath,
    this.text = '',
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.imageClick,
    this.backClick,
    this.item = 0,
    this.useLocal = false,
  });

  final bool useLocal;

  final int item;

  final CardViewType type;

  bool isEditing;

  final bool enable;

  final String imagePath;

  final String text;

  final VoidCallback imageClick;

  final VoidCallback backClick;

  final VoidCallback onTap;

  final ValueChanged<String> onChanged;

  final ValueChanged<String> onSubmitted;

  bool hasImage() {
    return !(imagePath == null || imagePath.length == 0);
  }

  @override
  Widget build(BuildContext context) {
    
    final provider = Provider.of<DiaryProvider>(context);
    isEditing = provider.index == item;
    final imageV = enable
        ? GestureDetector(
            onTap: () {
              if (enable) provider.setIndex(item);
              FocusScope.of(context).requestFocus(FocusNode());
              if (hasImage()) {
                return;
              }
              this.imageClick();
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 300, minHeight: 200),
              child: Container(
                width: double.infinity,
                child: hasImage()
                    ? ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                        ),
                        child: useLocal
                            ? Image.asset(imagePath)
                            : Image.file(
                                File(imagePath ?? ''),
                                fit: BoxFit.cover,
                              ),
                      )
                    : Container(
                        child: Icon(
                          Icons.add_photo_alternate,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
          )
        : FullScreenView(
            tag: 'cardImage$item',
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 300, minHeight: 200),
              child: Container(
                width: double.infinity,
                child: hasImage()
                    ? ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                        ),
                        child: useLocal
                            ? Image.asset(imagePath)
                            : Image.file(
                                File(imagePath ?? ''),
                                fit: BoxFit.cover,
                              ),
                      )
                    : Container(
                        child: Icon(
                          Icons.add_photo_alternate,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            fullChild: Container(
              width: double.infinity,
              child: hasImage()
                  ? (useLocal
                      ? Image.asset(imagePath)
                      : Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                        ))
                  : Container(
                      child: Icon(
                        Icons.add_photo_alternate,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
            ),
          );

    final text = Container(
      alignment: AlignmentDirectional.topStart,
      padding: EdgeInsets.all(16),
      child: TextField(
        style: Theme.of(context).textTheme.bodyText1,
        enabled: enable,
        controller: TextEditingController(text: this.text ?? ''),
        decoration: enable ? InputDecoration(hintText: "输入你想要记录的内容...") : null,
        maxLines: null,
        onChanged: (value) {
          if (onChanged != null) {
            onChanged(value);
          }
        },
        onSubmitted: (value) {
          if (enable) provider.setIndex(item);
          if (onSubmitted != null) {
            onSubmitted(value);
          }
        },
        onTap: () {
          if (enable) provider.setIndex(item);
          if (onTap != null) {
            onTap();
          }
        },
      ),
    );

    return GestureDetector(
      onTap: () {
        if (enable) provider.setIndex(item);
        if (backClick != null) {
          this.backClick();
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          top: 8,
          bottom: 8,
        ),
        decoration: this.isEditing
            ? BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1.5), // 边色与边宽度
              )
            : null,
        child: Column(
          children: <Widget>[
            Card(
              elevation: 8,
              child: getView(text, imageV),
            ),
          ],
        ),
      ),
    );
  }

  Widget getView(Widget text, Widget image) {
    switch (this.type) {
      case CardViewType.LeftImage:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Card(
                child: image,
              ),
            ),
            Expanded(
              flex: 2,
              child: text,
            ),
          ],
        );
      case CardViewType.RightImage:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: text,
            ),
            Expanded(
              flex: 1,
              child: Card(
                child: image,
              ),
            ),
          ],
        );
      case CardViewType.TopImage:
        return Column(
          children: <Widget>[
            image,
            Divider(
              height: 2,
            ),
            text,
          ],
        );
      case CardViewType.BottomImage:
        return Column(
          children: <Widget>[
            text,
            Divider(
              height: 2,
            ),
            image,
          ],
        );
    }
    return Container();
  }
}

enum CardViewType {
  LeftImage,
  RightImage,
  TopImage,
  BottomImage,
}

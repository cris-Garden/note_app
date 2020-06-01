import 'package:flutter/material.dart';

void showTextAlert(
  String text,
  BuildContext context, {
  String title,
  String ok,
  String cancel,
  VoidCallback okClick,
  VoidCallback cancelClick,
}) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(title ?? '提示'),
        content: Text(text),
        actions: <Widget>[
          // ボタン領域
          FlatButton(
            child: Text(cancel ?? 'CANCEL'),
            onPressed: () {
              if (cancelClick != null) {
                cancelClick();
              }
            },
          ),
          FlatButton(
            child: Text(ok ?? 'OK'),
            onPressed: () {
              if (okClick != null) {
                okClick();
              }
            },
          ),
        ],
      );
    },
  );
}



void showSheet(
  BuildContext context,
  List<String> titles, {
  Function(int index) onClick,
}) {
  showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      child: Column(
          children: List.generate(
        titles.length,
        (index) => GestureDetector(
            child: Container(
              alignment: Alignment.center,
              height: 45.0,
              child: Text(titles[index]),
            ),
            onTap: () {
              if (onClick != null) {
                onClick(index);
              }
              Navigator.pop(context);
            }),
      )),
      height: 45 * titles.length.toDouble(),
    ),
  );
}

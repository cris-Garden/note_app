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

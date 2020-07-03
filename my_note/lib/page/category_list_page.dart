import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_note/provider/category_list_provider.dart';
import 'package:provider/provider.dart';
import 'base/base_page.dart';

class CategoryListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<CategoryProvider, CategoryProvider>(
        shouldRebuild: (pre, next) {
          return pre.didChange;
        },
        selector: (context, selector) => selector,
        builder: (context, provider, _) {
          return BasePage(
            appBar: AppBar(
              title: Text('首页'),
            ),
            body: Container(
              child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Text(''),
                    );
                  }),
            ),
          );
        });
  }
}

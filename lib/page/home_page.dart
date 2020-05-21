import 'package:flutter/material.dart';
import 'package:flutter_app/page/diary_detail_page.dart';
import 'package:flutter_app/provider/home_page_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomePageProvider(),
      builder: (context, _) {
        return Selector<HomePageProvider, HomePageProvider>(
          builder: (context, provider, _) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('HomePage'),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return DiaryDetailPage(provider.newDiary());
                    })).then((value) {
                      provider.didChange();
                    });
                  },
                  child: Icon(Icons.add),
                ),
                body: Container(
                  child: Selector<HomePageProvider, bool>(
                      builder: (_, didChange, child) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(provider.diarys[index].title),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return DiaryDetailPage(provider.diarys[index]);
                            }));
                          },
                        );
                      },
                      itemCount: provider.diarys.length,
                    );
                  }, selector: (context, provider) {
                    return provider.changeFlag;
                  }),
                ));
          },
          selector: (context, provider) => provider,
        );
      },
    );
  }
}

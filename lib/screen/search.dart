import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:prunusavium/screen/book.dart';
import 'package:prunusavium/store/search.dart';

class SearchPage extends SearchDelegate {
  final SearchStore store;

  SearchPage(this.store);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    store.searchKeywords(query);

    return Observer(
      builder: (_) {
        if (!store.hasResults) {
          return Container(
            child: LinearProgressIndicator(),
          );
        }

        if (store.books.isEmpty) {
          return Center(
            child: Text('oops ... nothing found'),
          );
        }

        return ListView.builder(
            itemCount: store.books.length,
            itemBuilder: (_, int index) {
              final book = store.books[index];
              return Card(
                margin: EdgeInsets.all(5.0),
                elevation: 5.0,
                child: ListTile(
                  title: Text(book.title),
                  onTap: () {
                    close(context, null);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => BookPage(book),
                      ),
                    );
                  },
                ),
              );
            });
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: store.history.length,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: <Widget>[
            Icon(Icons.book),
            FlatButton(
              child: SizedBox(
                // width: double.infinity,
                child: Text(
                  store.history[index],
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              onPressed: () {
                query = store.history[index];
              },
            ),
          ],
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }
}

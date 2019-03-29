import 'package:mobx/mobx.dart';
import 'package:prunusavium/model/book.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'search.g.dart';

class SearchStore = _SearchStore with _$SearchStore;

abstract class _SearchStore implements Store {
  final SharedPreferences prefs;
  _SearchStore(this.prefs);

  List<String> history = [];

  // @observable
  // ObservableList<Book> books = ObservableList<Book>();
  List<Book> books = [];

  @observable
  ObservableFuture<dynamic> searchKeywordsFuture = empty;

  static ObservableFuture<dynamic> empty = ObservableFuture.value([]);

  // @computed
  // bool get hasResults => books.isNotEmpty;

  @computed
  bool get hasResults =>
      searchKeywordsFuture != empty &&
      searchKeywordsFuture.status == FutureStatus.fulfilled;

  @action
  Future searchKeywords(query) async {
    if (query == "") {
      return;
    }

    print('search on: $query');

    books = [];

    history = prefs.getStringList("history") ?? [];

    var index = history.indexOf(query);
    if (index > 0) {
      history.remove(query);
      history.insert(0, query);
    } else if (index < 0) {
      history.insert(0, query);
    }
    prefs.setStringList("history", history);

    try {
      final future = Dio().get(
          "https://asia-northeast1-prunusavium.cloudfunctions.net/v1/search?keywords=$query");
      searchKeywordsFuture = ObservableFuture(future);
      final response = await future;
      for (var item in response.data) {
        books.add(Book.fromJson(item));
      }
    } catch (e) {
      print(e);
    }

    print('number of books returned: ${books.length}');
  }
}

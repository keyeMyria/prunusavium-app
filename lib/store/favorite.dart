import 'package:mobx/mobx.dart';
import 'package:prunusavium/model/favorite.dart';

part 'favorite.g.dart';

class FavoriteStore = _FavoriteStore with _$FavoriteStore;

abstract class _FavoriteStore implements Store {
  _FavoriteStore();

  @observable
  ObservableList<Favorite> favorites = ObservableList<Favorite>();

  @observable
  bool loaded = false;

  @observable
  ObservableFuture<List<Favorite>> fetchFavsFuture = ObservableFuture.value([]);

  @computed
  bool get updated =>
      loaded == true &&
      fetchFavsFuture != null &&
      fetchFavsFuture.status == FutureStatus.fulfilled;

  @action
  checkFavritesUpdate() {
    print("check favorite update");
    favorites.add(Favorite(
        "author2",
        "id2",
        "https://lh3.googleusercontent.com/H_6PL2Br4qdh2oLTF4QeqwgWWiPvOpre044cCFbwrA5oepf1uaFsvXOQ1HFr5uK4OYLh=s360-rw",
        "site2",
        "title2",
        "update2"));
  }

  @action
  loadFavorites() {
    print("load favorites");
    loaded = true;

    favorites.add(Favorite(
        "author",
        "id",
        "https://lh3.googleusercontent.com/H_6PL2Br4qdh2oLTF4QeqwgWWiPvOpre044cCFbwrA5oepf1uaFsvXOQ1HFr5uK4OYLh=s360-rw",
        "site",
        "title",
        "update"));
  }
}

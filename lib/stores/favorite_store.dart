import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/models/ad.dart';
import 'package:xlo_mobx/repositories/favorite_repository.dart';
import 'package:xlo_mobx/stores/user_manager_store.dart';

part 'favorite_store.g.dart';

class FavoriteStore = _FavoriteStore with _$FavoriteStore;

abstract class _FavoriteStore with Store {

  _FavoriteStore() {
    reaction((_) => userManagerStore.isLoggedIn, (_) {
      //quando o usuário estiver logado, irá trazer a lista de favoritos
      _getFavoritesList();
    });
  }

  final UserManagerStore userManagerStore = GetIt.I<UserManagerStore>();

  ObservableList<Ad> favoriteList = ObservableList<Ad>();

  @action
  Future<void> _getFavoritesList() async {
    try{
      favoriteList.clear();
      final favorites = await FavoriteRepository().getFavorites(userManagerStore.user!);
      favoriteList.addAll(favorites);
    } catch(e) {
      print(e);
    }
  }

  @action
  Future<void> toggleFavorite(Ad ad) async {
    try{
      if(favoriteList.any((a) => a.id == ad.id)) {
        //caso o anúncio já esteja na lista de favoritos
        favoriteList.removeWhere((a) => a.id == ad.id);
        await FavoriteRepository().delete(ad: ad, user: userManagerStore.user!);
      } else {
        favoriteList.add(ad);
        await FavoriteRepository().save(ad: ad, user: userManagerStore.user!);
      }
    } catch(e) {
      print(e);
    }

  }

}
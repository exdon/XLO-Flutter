import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/models/category.dart';
import 'package:xlo_mobx/repositories/ad_repository.dart';
import 'package:xlo_mobx/stores/filter_store.dart';

import '../models/ad.dart';
import 'connectivity_store.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {

  final ConnectivityStore connectivityStore = GetIt.I<ConnectivityStore>();

  _HomeStore() {
    autorun((_) async {
      connectivityStore.connected;
      //quando qualquer um dos parametros abaixo mudarem,
      //aqui será chamado, buscando a lista de anúncios
      try {
        setLoading(true);
        final newAds = await AdRepository().getHomeAdList(
          filterStore: filterStore,
          search: search,
          category: category,
          page: page,
        );
        //adicionando anúncios a lista
        addNewAds(newAds);
        setError(null);
        setLoading(false);
      } catch (e) {
        setError(e as String);
      }
    });
  }

  ObservableList<Ad> adList = ObservableList<Ad>();

  @observable // definindo a variável como observable
  String search = '';

  @action // declarando a função como uma action
  void setSearch(String value) {
    search = value;
    resetPage();
  }

  @observable
  Category? category;

  void setCategory(Category value) {
    category = value;
    resetPage();
  }

  @observable // definindo a variável como observable
  FilterStore filterStore = FilterStore();

  FilterStore get clonedFilterStore => filterStore.clone();

  @action // declarando a função como uma action
  void setFilterStore(FilterStore value) {
    filterStore = value;
    resetPage();
  }

  @observable // definindo a variável como observable
  String? error;

  @action // declarando a função como uma action
  void setError(String? value) => error = value;

  @observable // definindo a variável como observable
  bool loading = false;

  @action // declarando a função como uma action
  void setLoading(bool value) => loading = value;

  @observable // definindo a variável como observable
  int page = 0;

  @observable
  bool lastPage = false;

  @action // declarando a função como uma action
  void loadNextPage() {
    page++;
  }

  @action
  void addNewAds(List<Ad> newAds) {
    if(newAds.length < 2) lastPage = true;
    adList.addAll(newAds);
  }

  @computed
  int get itemCount => lastPage ? adList.length : adList.length + 1;

  void resetPage() {
    page = 0;
    adList.clear();
    lastPage = false;
  }

  @computed
  bool get showProgress => loading && adList.isEmpty;

}
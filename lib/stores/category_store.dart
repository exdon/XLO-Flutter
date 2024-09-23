import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/repositories/category_repository.dart';

import '../models/category.dart';
import 'connectivity_store.dart';

part 'category_store.g.dart';

class CategoryStore = _CategoryStore with _$CategoryStore;

abstract class _CategoryStore with Store {
  final ConnectivityStore connectivityStore = GetIt.I<ConnectivityStore>();

  _CategoryStore() {
    autorun((_) {
      if (connectivityStore.connected && categoryList.isEmpty) {
        _loadCategories();
      }
    });
  }

  ObservableList<Category> categoryList = ObservableList<Category>();

  //traz todas as categorias + categoria 'Todas'
  @computed
  List<Category> get allCategoryList => List.from(categoryList)
    ..insert(0, Category(id: '*', description: 'Todas'));

  @action
  void setCategories(List<Category> categories) {
    //limpando a fim de evitar categorias dupliacadas
    categoryList.clear();
    //adicionando as categorias
    categoryList.addAll(categories);
  }

  @observable // definindo a variável como observable
  String? error;

  @action // declarando a função como uma action
  void setError(String value) => error = value;

  Future<void> _loadCategories() async {
    try {
      final categories = await CategoryRepository().getList();
      setCategories(categories);
    } catch (e) {
      setError(e as String);
    }
  }
}

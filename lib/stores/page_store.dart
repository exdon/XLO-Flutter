import 'package:mobx/mobx.dart';

//Para incluir o arquivo gerado
part 'page_store.g.dart';

//Mesclando as classes (atual e gerada)
class PageStore = _PageStore with _$PageStore;

abstract class _PageStore with Store {

  @observable //definindo a variável como observable
  int page = 0;

  @action //declarando função como action
  void setPage(int value) => page = value;

}
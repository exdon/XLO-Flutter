import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/helpers/extensions.dart';
import 'package:xlo_mobx/models/address.dart';
import 'package:xlo_mobx/repositories/ad_repository.dart';
import 'package:xlo_mobx/stores/cep_store.dart';
import 'package:xlo_mobx/stores/user_manager_store.dart';

import '../models/ad.dart';
import '../models/category.dart';

part 'create_store.g.dart';

class CreateStore = _CreateStore with _$CreateStore;

abstract class _CreateStore with Store {

  _CreateStore(Ad? ad) {
    if(ad != null) {
      this.ad = ad;
      title = ad.title;
      description = ad.description;
      images = ad.images.asObservable();
      category = ad.category;
      priceText = ad.price.toStringAsFixed(2);
      hidePhone = ad.hidePhone;

      if(ad.address != null) {
        cepStore = CepStore(ad.address.cep);
      } else {
        cepStore = CepStore(null);
      }
    } else {
      this.ad = Ad();
    }
  }

  Ad? ad;

  @observable // definindo a variável como observable
  ObservableList images = ObservableList();

  @computed
  bool get imagesValid => images.isNotEmpty;
  String? get imagesError {
    if(!showErrors || imagesValid) {
      return null;
    } else {
      return 'Insira imagens';
    }
  }

  @observable // definindo a variável como observable
  String title = '';

  @action // declarando a função como uma action
  void setTitle(String value) => title = value;

  @computed
  bool get titleValid => title.length >= 6;
  String? get titleError {
    if(!showErrors || titleValid) {
      return null;
    } else if(title.isEmpty) {
      return 'Campo obrigatório';
    } else {
      return 'Título muito curto';
    }
  }

  @observable // definindo a variável como observable
  String description = '';

  @action // declarando a função como uma action
  void setDescription(String value) => description = value;

  @computed
  bool get descriptionValid => description.length >= 10;
  String? get descriptionError {
    if(!showErrors || descriptionValid) {
      return null;
    } else if(description.isEmpty) {
      return 'Campo obrigatório';
    } else {
      return 'Descrição muito curto';
    }
  }

  @observable // definindo a variável como observable
  Category? category;

  @action // declarando a função como uma action
  void setCategory(Category value) => category = value;

  @computed
  bool get categoryValid => category != null;
  String? get categoryError {
    if(!showErrors || categoryValid) {
      return null;
    } else {
      return 'Campo obrigatório';
    }
  }

  //Colocamos aqui, pois iremos utilizar na edição de anúncio também
  // com a mesma tela CreateScreen
  CepStore cepStore = CepStore(null);

  @computed
  Address? get address => cepStore.address;
  bool get addressValid => address != null;
  String? get addressError {
    if(!showErrors || addressValid) {
      return null;
    } else {
      return 'Campo obrigatório';
    }
  }

  @observable // definindo a variável como observable
  String priceText = '';

  @action // declarando a função como uma action
  void setPrice(String value) => priceText = value;

  @computed
  num? get price => num.tryParse(priceText.replaceAll('.', '').replaceAll(',', '.'));
  bool get priceValid => price != null && price! <= 9999999;
  String? get priceError {
    if(!showErrors || priceValid) {
      return null;
    } else if(priceText.isEmpty) {
      return 'Campo obrigatório';
    } else {
      return 'Preço inválido';
    }
  }

  @observable // definindo a variável como observable
  bool hidePhone = false;

  @action // declarando a função como uma action
  void setHidePhone(bool? value) => hidePhone = value!;

  @computed
  bool get formValid => imagesValid
      && titleValid
      && descriptionValid
      && categoryValid
      && addressValid
      && priceValid;

  @computed
  get sendPressed => formValid ? _send : null;

  //Para mostrar os erros apenas quando clicar no botão 'Enviar'
  @observable
  bool showErrors = false;

  @action
  void invalidSendPressed() => showErrors = true;

  @observable
  bool loading = false;

  @observable
  String? error;

  @observable
  bool savedAd = false;

  @action
  Future<void> _send() async {
    ad!.title = title;
    ad!.description = description;
    ad!.category = category!;
    ad!.hidePhone = hidePhone;
    ad!.images = images;
    ad!.address = address!;
    ad!.price = price!;
    ad!.user = GetIt.I<UserManagerStore>().user!;

    loading = true;
    try {
      //salvando o anúncio
      await AdRepository().save(ad!);
      savedAd = true;
    } catch(e) {
      error = e as String?;
    }
    loading = false;
  }
}
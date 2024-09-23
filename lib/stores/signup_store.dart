import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/helpers/extensions.dart';
import 'package:xlo_mobx/repositories/user_repository.dart';
import 'package:xlo_mobx/stores/page_store.dart';
import 'package:xlo_mobx/stores/user_manager_store.dart';

import '../models/user.dart';

part 'signup_store.g.dart';

class SignupStore = _SignupStore with _$SignupStore;

abstract class _SignupStore with Store {
  @observable //definindo a variável como observable
  String? name;

  @action //declarando função como action
  void setName(String value) => name = value;

  // Irá observar o name e retornar uma msg de erro ou não
  @computed
  bool get nameValid => name != null && name!.length > 6;
  String? get nameError {
    if (name == null || nameValid) {
      //não retorna msg de erro
      return null;
    } else if (name!.isEmpty) {
      //retornando msg de erro
      return 'Campo obrigatório';
    } else {
      //retornando msg de erro
      return 'Nome muito curto';
    }
  }

  @observable // definindo a variável como observable
  String? email;

  @action // declarando a função como uma action
  void setEmail(String value) => email = value;

  @computed
  bool get emailValid => email != null && email!.isEmailValid();
  String? get emailError {
    if (email == null || emailValid) {
      return null;
    } else if (email!.isEmpty) {
      //retornando msg de erro
      return 'Campo obrigatório';
    } else {
      //retornando msg de erro
      return 'E-mail inválido';
    }
  }


  @observable // definindo a variável como observable
  String? phone;

  @action // declarando a função como uma action
  void setPhone(String value) => phone = value;

  @computed
  bool get phoneValid => phone != null && phone!.length >= 14;
  String? get phoneError {
    if (phone == null || phoneValid) {
      return null;
    } else if (phone!.isEmpty) {
      //retornando msg de erro
      return 'Campo obrigatório';
    } else {
      //retornando msg de erro
      return 'Celular inválido';
    }
  }


  @observable // definindo a variável como observable
  String? pass1;

  @action // declarando a função como uma action
  void setPass1(String value) => pass1 = value;

  @computed
  bool get pass1Valid => pass1 != null && pass1!.length >= 6;
  String? get pass1Error {
    if (pass1 == null || pass1Valid) {
      return null;
    } else if (pass1!.isEmpty) {
      //retornando msg de erro
      return 'Campo obrigatório';
    } else {
      //retornando msg de erro
      return 'Senha muito curta';
    }
  }

  @observable // definindo a variável como observable
  String? pass2;

  @action // declarando a função como uma action
  void setPass2(String value) => pass2 = value;

  @computed
  bool get pass2Valid => pass2 != null && pass2 == pass1;
  String? get pass2Error {
    if (pass2 == null || pass2Valid) {
      return null;
    } else if (pass2!.isEmpty) {
      //retornando msg de erro
      return 'Campo obrigatório';
    } else {
      //retornando msg de erro
      return 'Senhas não coincidem';
    }
  }


  //validando os campos do formulário
  @computed
  bool get isFormValid => nameValid && emailValid && phoneValid
      && pass1Valid && pass2Valid;


  //Habilitando o botão para se cadastrar se o formulário for válido
  @computed
  get signUpPressed => (isFormValid && !loading) ? _signUp : null;

  @observable // definindo a variável como observable
  bool loading = false;

  @observable
  String? error;

  @action // declarando a função como uma action
  Future<void> _signUp() async {
    loading = true;

    final user = User(
      name: name!,
      email: email!,
      phone: phone!,
      password: pass1!,
    );
    
    try {
      // Criando a conta do usuário no Parse Server
      final resultUser = await UserRepository().signUp(user);

      //Salvando dados do user
      GetIt.I<UserManagerStore>().setUser(resultUser);
    } catch(e) {
      //exibindo msg de erro
      error = e as String?;
    }

    loading = false;
  }

}

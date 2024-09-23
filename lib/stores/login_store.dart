import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/helpers/extensions.dart';
import 'package:xlo_mobx/repositories/user_repository.dart';
import 'package:xlo_mobx/stores/user_manager_store.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  @observable // definindo a variável como observable
  String? email;

  @action // declarando a função como uma action
  void setEmail(String value) => email = value;

  @computed
  bool get emailValid => email != null && email!.isEmailValid();

  String? get emailError =>
      email == null || emailValid ? null : 'E-mail inválido';

  @observable // definindo a variável como observable
  String? password;

  @action // declarando a função como uma action
  void setPassword(String value) => password = value;

  @computed
  bool get passwordValid => password != null && password!.length >= 4;

  String? get passwordError =>
      password == null || passwordValid ? null : 'Senha inválida';

  @computed
  get loginPressed => (emailValid && passwordValid && !loading) ? _login : null;


  @observable
  bool loading = false;

  @observable
  String? error;

  @action
  Future<void> _login() async {
    loading = true;
    error = null;

    try {
      // .:: Fazendo login do usuário ::.
      final user = await UserRepository().loginWithEmail(email!, password!);

      //Salvando dados do user
      GetIt.I<UserManagerStore>().setUser(user);
    } catch(e) {
      //exibindo msg de erro
      error = e as String?;
    }
    loading = false;
  }
}

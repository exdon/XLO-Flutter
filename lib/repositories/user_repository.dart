import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:xlo_mobx/repositories/parse_errors.dart';
import 'package:xlo_mobx/repositories/table_keys.dart';

import '../models/user.dart';

class UserRepository {
  // .:: Cadastro do usuário no Parse Server ::.
  Future<User> signUp(User user) async {
    // .:: Criando um usuário no Parse Server ::.
    final parseUser = ParseUser(user.email, user.password, user.email);

    /*
    * ParseUser(String? username,
      String? password,
      String? emailAddress, {
      String? sessionToken,
      bool? debug,
      ParseClient? client)
    * */

    //No Parse Server, o login é feito com username e password
    // e-mail é usado para outras coisas

    // .:: Adicionando informações extras ::.
    parseUser.set<String>(keyUserName, user.name);
    parseUser.set<String>(keyUserPhone, user.phone);
    parseUser.set(keyUserType, user.type.index);
    //user.type.index irá transformar UserType em indice ou seja,
    // PARTICULAR = 0
    // PROFESSIONAL = 1

    // .:: Chamando função do ParseUser() para fazer cadastro do usuário no Parse Server e pegando a resposta ::.
    final response = await parseUser.signUp();

    if (response.success) {
      return mapParseToUser(response.result);
    } else {
      //Exibindo msg de erro de acordo com o código de erro informado
      return Future.error(
          ParseErrors.getDescription(response.error!.code) as Object);
    }
  }

  // .:: Login do usuário no Parse Server ::.
  Future<User> loginWithEmail(String email, String password) async {
    final parseUser = ParseUser(email, password, null);

    final response = await parseUser.login();

    if (response.success) {
      return mapParseToUser(response.result);
    } else {
      //Exibindo msg de erro de acordo com o código de erro informado
      return Future.error(
          ParseErrors.getDescription(response.error!.code) as Object);
    }
  }

  // .:: Retorna dados do usuário logado no Parse Server ::.
  Future<User?> currentUser() async {
    final parseUser = await ParseUser.currentUser();

    //verifica se o usuário foi expirado ou ainda está valido
    if (parseUser != null) {
      // passando o token que identifica o usuário para verificar se ele ainda é válido
      final response =
          await ParseUser.getCurrentUserFromServer(parseUser.sessionToken);
      if (response!.success) {
        return mapParseToUser(response.result);
      } else {
        // fazendo logout do usuário, para que ele faça login novamente
        await parseUser.logout();
      }
    }
    return null;
  }

  // .:: Salva os dados do usuário no Parse Server ::.
  Future<void> save(User user) async {
    final ParseUser? parseUser = await ParseUser.currentUser();

    if (parseUser != null) {
      parseUser.set<String>(keyUserName, user.name);
      parseUser.set<String>(keyUserPhone, user.phone);
      parseUser.set<int>(keyUserType, user.type.index);

      if (user.password != null) {
        parseUser.password = user.password;
      }

      final response = await parseUser.save();

      if (!response.success) {
        //Exibindo msg de erro de acordo com o código de erro informado
        return Future.error(
            ParseErrors.getDescription(response.error!.code) as Object);
      }

      if (user.password != null) {
        await parseUser.logout();

        final loginResponse =
            await ParseUser(user.email, user.password, user.email).login();

        if (!loginResponse.success) {
          //Exibindo msg de erro de acordo com o código de erro informado
          return Future.error(
              ParseErrors.getDescription(loginResponse.error!.code) as Object);
        }
      }
    }
  }

  // .:: Faz logout do usuário no Parse Server ::.
  Future<void> logout() async {
    final ParseUser currentUser = await ParseUser.currentUser();
    await currentUser.logout();
  }


  //Função que converte de ParseUser para User
  User mapParseToUser(ParseUser parseUser) {
    return User(
        id: parseUser.objectId,
        name: parseUser.get(keyUserName),
        email: parseUser.get("username"),
        phone: parseUser.get(keyUserPhone),
        type: UserType.values[parseUser.get(keyUserType)],
        createdAt: parseUser.get(keyUserCreatedAt));
  }
}

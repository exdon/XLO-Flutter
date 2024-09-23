// Classe de extensão, que irá extender a classe String
// e você consegue adicionar métodos/funções para a classe

import 'package:intl/intl.dart';

extension StringExtension on String {

  // Funções que serão adicionadas a classe String

  //Valida o campo de e-mail
  bool isEmailValid() {
    // regex de validação de e-mail
    final RegExp regex = RegExp(
    r"^(([^<>()[\]\\.,;:\s@\']+(\.[^<>()[\]\\.,;:\s@\']+)*)|(\'.+\'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$");

    return regex.hasMatch(this); //validando e-mail informado
    //this se refere ao valor que estará na variavel 'email', ou seja
    // o e-mail digitado pelo usuário
  }

}

extension NumberExtension on num {
  String formattedMoney() {
    return NumberFormat('R\$ ###,##0.00', 'pt-BR').format(this);
  }
}

extension DateTimeExtension on DateTime {
  String formattedDate() {
    return DateFormat('dd/MM/yyyy', 'pt-BR').format(this);
  }
}
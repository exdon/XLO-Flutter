import 'package:dio/dio.dart';
import 'package:xlo_mobx/models/address.dart';
import 'package:xlo_mobx/repositories/ibge_repository.dart';

import '../models/city.dart';
import '../models/uf.dart';

class CEPRepository {
  // .:: Busca endereço pelo CEP ::.
  Future<Address> getAddressFromApi(String cep) async {
    if (cep == null || cep.isEmpty) return Future.error('CEP Inválido');

    //Validando cep informado
    final clearCep = cep.replaceAll(RegExp('[^0-9]'), '');
    if (clearCep.length != 8) return Future.error('CEP Inválido');

    final String endpoint = 'https://viacep.com.br/ws/$clearCep/json/';

    try {
      // Fazendo chamada HTTP
      final response = await Dio().get<Map>(endpoint);

      // verificando se retornou erro na API
      if (response.data!.containsKey('erro') && response.data?['erro']) {
        return Future.error('CEP Inválido');
      }

      //obtendo nome do estado a partir do UF
      final ufList = await IBGERepository().getUFList();

      return Address(
        uf: ufList!.firstWhere((uf) => uf.initials == response.data?['uf']),
        city: City(name: response.data?['localidade']),
        cep: response.data?['cep'],
        district: response.data?['bairro'],
      );
    } catch(e) {
      //Tratando uma exception do Dio
      return Future.error('Falha ao buscar CEP');
    }
  }
}

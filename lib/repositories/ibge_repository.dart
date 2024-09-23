import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/city.dart';
import '../models/uf.dart';

class IBGERepository {
  // .:: Busca os estados ::.
  Future<List<UF>?> getUFList() async {
    // .:: Salvando os dados em Cache ::.
    final sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.containsKey('UF_LIST')) {
      //Retorna dados do Cache
      final decodedList =
          json.decode(sharedPreferences.get('UF_LIST') as String);

      return decodedList.map<UF>((j) => UF.fromJson(j)).toList();
    }

    const endpoint =
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome';

    try {
      // Fazendo chamada HTTP
      final response = await Dio().get<List>(endpoint);

      // salvando dados em Cache
      sharedPreferences.setString('UF_LIST', json.encode(response.data));

      //transformando response json em model UF
      final ufList = response.data?.map<UF>((j) => UF.fromJson(j)).toList();

      return ufList;
    } on DioException {
      //Tratando uma exception do Dio
      return Future.error('Falha ao obter lista de Estados');
    }
  }

  // .:: Busca os municípios/cidades do estado informado ::.
  Future<List<City>?> getCityListFromApi(UF uf) async {
    final String endpoint =
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados/${uf.id}/municipios?orderBy=nome';

    try {
      // Fazendo chamada HTTP
      final response = await Dio().get<List>(endpoint);

      //transformando response json em model City
      final cityList =
          response.data?.map<City>((j) => City.fromJson(j)).toList();

      return cityList;
    } on DioException {
      //Tratando uma exception do Dio
      return Future.error('Falha ao obter lista de Cidades');
    }
  }
}

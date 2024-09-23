import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:xlo_mobx/repositories/parse_errors.dart';
import 'package:xlo_mobx/repositories/table_keys.dart';

import '../models/category.dart';

class CategoryRepository {
  // .:: Retorna uma lista de categorias do Parse Server ::.
  Future<List<Category>> getList() async {
    //retorna as categorias em ordem alfabética
    final queryBuilder = QueryBuilder(ParseObject(keyCategoryTable))
      ..orderByAscending(keyCategoryDescription);

    //executando query
    final response = await queryBuilder.query();

    if(response.success) {
      //tranformando de ParseObject para Category
      return response.results!.map((p) => Category.fromParse(p)).toList();
    } else {
      //Exibindo msg de erro de acordo com o código de erro informado
      throw ParseErrors.getDescription(response.error!.code) as Object;
    }
  }
}

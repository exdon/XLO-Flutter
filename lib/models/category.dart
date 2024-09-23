import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:xlo_mobx/repositories/table_keys.dart';

class Category {
  Category({this.id, this.description});

  //Transformando um Objeto do Parse em um objeto Category
  Category.fromParse(ParseObject parseObject)
      : id = parseObject.objectId!,
        description = parseObject.get(keyCategoryDescription);

  final String? id;
  final String? description;

  @override
  String toString() {
    return 'Category{id: $id, description: $description}';
  }
}

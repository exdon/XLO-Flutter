import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:xlo_mobx/models/address.dart';
import 'package:xlo_mobx/models/city.dart';
import 'package:xlo_mobx/models/uf.dart';
import 'package:xlo_mobx/models/user.dart';
import 'package:xlo_mobx/repositories/table_keys.dart';
import 'package:xlo_mobx/repositories/user_repository.dart';

import 'category.dart';

enum AdStatus { PENDING, ACTIVE, SOLD, DELETED }

class Ad {

  Ad();

  Ad.fromParse(ParseObject object) {
    id = object.objectId!;
    title = object.get<String>(keyAdTitle)!;
    description = object.get<String>(keyAdDescription)!;
    //salvando uma lista de url das imagens
    images = object.get<List>(keyAdImages)!.map((e) => e.url).toList();
    hidePhone = object.get<bool>(keyAdHidePhone)!;
    price = object.get<num>(keyAdPrice)!;
    created = object.createdAt!;
    address = Address(
        uf: UF(initials: object.get<String>(keyAdFederativeUnit)!),
        city: City(name: object.get<String>(keyAdCity)!),
        cep: object.get<String>(keyAdPostalCode)!,
        district: object.get<String>(keyAdDistrict)!);
    //caso não tenha, o default será 0
    views = object.get<int>(keyAdViews, defaultValue: 0)!;
    user = UserRepository().mapParseToUser(object.get<ParseUser>(keyAdOwner)!);
    category = Category.fromParse(object.get<ParseObject>(keyAdCategory)!);
    status = AdStatus.values[object.get<int>(keyAdStatus)!];
  }

  late String id;
  late List images;
  late String title;
  late String description;
  late Category category;
  late Address address;
  late num price;
  late bool hidePhone;
  AdStatus status = AdStatus.PENDING;
  late DateTime created;
  late User user;
  late int views;
}

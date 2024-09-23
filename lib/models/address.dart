import 'package:xlo_mobx/models/uf.dart';

import 'city.dart';

class Address {
  Address(
      {required this.uf,
      required this.city,
      required this.cep,
      required this.district});

  late UF uf;
  late City city;
  late String cep;
  late String district;

  @override
  String toString() {
    return 'Address{uf: $uf, city: $city, cep: $cep, district: $district}';
  }
}

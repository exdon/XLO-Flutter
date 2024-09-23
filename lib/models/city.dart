class City {
  //model response da api https://servicodados.ibge.gov.br/api/v1/localidades/estados/{id}/municipios

  City({this.id, this.name});

  //factory - cria um novo objeto
  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json['id'],
        name: json['nome'],
      );

  late int? id; //id
  late String? name; //nome

  @override
  String toString() {
    return 'City{id: $id, name: $name}';
  }
}

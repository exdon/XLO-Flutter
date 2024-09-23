class UF {
  //model response da api https://servicodados.ibge.gov.br/api/v1/localidades/estados

  UF({this.id, this.initials, this.name});

  //factory - cria um novo objeto
  factory UF.fromJson(Map<String, dynamic> json) => UF(
        id: json['id'],
        initials: json['sigla'],
        name: json['nome'],
      );

  late int? id; //id
  late String? initials; //sigla
  late String? name; //nome

  @override
  String toString() {
    return 'UF{id: $id, initials: $initials, name: $name}';
  }
}

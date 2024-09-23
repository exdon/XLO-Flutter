enum UserType { PARTICULAR, PROFESSIONAL }

class User {
  User(
      { this.id, required this.name,
      required this.email,
      required this.phone,
      this.password,
      this.type = UserType.PARTICULAR,
      this.createdAt});

  late String? id;
  late String name;
  late String email;
  late String phone;
  late String? password;
  late UserType type;
  late DateTime? createdAt;


  //Sobreescrevendo o ToString para printar bonitinho o usuário
  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, phone: $phone, password: $password, type: $type, createdAt: $createdAt}';
  }

}

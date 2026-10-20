class User{
  String name;
  int? age;
  String? email;
  User({required this.name, this.age, this.email});

  String getDisplayAge() =>
      age == null ? 'Age not specified': '$age';
}
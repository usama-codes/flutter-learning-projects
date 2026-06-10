class Person {
  final int id;
  final String name;
  final int age;
  final String city;
  final String email;

  const Person({
    required this.id,
    required this.name,
    required this.age,
    required this.city,
    required this.email,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        age: json['age'] as int? ?? 0,
        city: json['city'] as String? ?? '',
        email: json['email'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'city': city,
        'email': email,
      };
}

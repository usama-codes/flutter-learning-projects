class Resource {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  const Resource({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: (json['id'] as num?)?.toInt() ?? -1,
      email: _readString(json, const ['email']),
      firstName: _readString(json, const ['firstName', 'first_name']),
      lastName: _readString(json, const ['lastName', 'last_name']),
      avatar: _readString(json, const ['image', 'avatar']),
    );
  }

  Resource copyWith({
    int? id,
    String? email,
    String? firstName,
    String? lastName,
    String? avatar,
  }) {
    return Resource(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'image': avatar,
    };
  }

  String get fullName => '$firstName $lastName'.trim();

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value == null) {
        continue;
      }

      final text = value.toString().trim();
      if (text.isNotEmpty) {
        return text;
      }
    }

    return '';
  }
}

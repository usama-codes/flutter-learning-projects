class Article {
  final int id;
  final String title;
  final String description;
  final String body;
  final bool published;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.body,
    required this.published,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'body': body,
    'published': published,
  };

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      body: json['body'] as String? ?? '',
      published: json['published'] as bool? ?? false,
    );
  }
}

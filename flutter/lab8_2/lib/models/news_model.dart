class News {
  final String title;
  final String content;
  final String date;

  News({required this.title, required this.content, required this.date});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] ?? 'Нет заголовка', // Если title == null, используем значение по умолчанию
      content: json['content'] ?? 'Нет содержимого', // Если content == null, используем значение по умолчанию
      date: json['date'] ?? 'Нет даты', // Если date == null, используем значение по умолчанию
    );
  }
}
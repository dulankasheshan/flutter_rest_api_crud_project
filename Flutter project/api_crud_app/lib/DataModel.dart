class DataModel {
  final String id;
  final String title;
  final String content;

  DataModel({
    required this.id,
    required this.title,
    required this.content,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
    );
  }
}

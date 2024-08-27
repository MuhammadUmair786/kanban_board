class BoardModel {
  final String id;
  final String name;
  final DateTime createdAt;

  BoardModel({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory BoardModel.fromJson(Map<String, dynamic> json) => BoardModel(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createdAt": createdAt.toIso8601String(),
      };
}

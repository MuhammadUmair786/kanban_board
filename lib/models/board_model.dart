class BoardModel {
  final String id;
  final String name;

  BoardModel({
    required this.id,
    required this.name,
  });

  DateTime get createdAt => DateTime.fromMicrosecondsSinceEpoch(int.parse(id));

  factory BoardModel.fromJson(Map<String, dynamic> json) => BoardModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

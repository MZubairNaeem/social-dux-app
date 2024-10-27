class DomainModel {
  final String id;
  final String name;
  final String description;

  DomainModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory DomainModel.fromJson(Map<String, dynamic> json) {
    return DomainModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

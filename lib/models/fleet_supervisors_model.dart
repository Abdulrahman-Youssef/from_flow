class FleetSupervisorsModel {
   final int id;
   final String name;

  FleetSupervisorsModel({required this.id, required this.name});

  FleetSupervisorsModel copyWith({int? id, String? name}) {
    return FleetSupervisorsModel(id: id ?? this.id, name: name ?? this.name);
  }

  FleetSupervisorsModel.fromJson(Map<String, dynamic> json)
      : id = json["id"] as int,
        name = json["name"] as String;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FleetSupervisorsModel &&
        other.id == id &&
        other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  // 3. toString: For easy debugging
  @override
  String toString() => 'FleetSupervisorsModel(id: $id, name: $name)';
}

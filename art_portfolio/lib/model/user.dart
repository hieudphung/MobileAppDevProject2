//Mostly need this for image streaming

class UserGalleryInfo {
  final String id;
  final String username;   
  final String avatar;
  final String description;

  UserGalleryInfo({
    required this.id,
    required this.username,
    required this.avatar,
    required this.description
  });

  /*
  Map<String, Object?> toMap() {
    return {
    };
  }
  */

  /*
  @override
  String toString() {
    return 'Expense{id: $id, name: $name, goalType: $goalType}';
  }

  factory Goal.fromJson(Map<String, dynamic> data) {
    return Goal(
      id: data["id"],
      name: data["name"],
      goalType: data["goalType"],
      description: data["description"],
      goalCurrent: data["goalCurrent"],
      goalTarget: data["goalTarget"],
    );
  }

  Map<String, dynamic> toJson() => {
      "id": id,
      "name" : name,
      "goalType": goalType,
      "description": description,
      "goalCurrent": goalCurrent,
      "goalTarget": goalTarget
  };
  */
}

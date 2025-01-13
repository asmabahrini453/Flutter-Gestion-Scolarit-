class Group {
  final int id;
  final String libelle;

  Group({
    required this.id,
    required this.libelle,
  });

  // Convert a Group to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'libelle': libelle,
    };
  }

  // Convert a Map to a Group
  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'],
      libelle: map['libelle'],
    );
  }
}
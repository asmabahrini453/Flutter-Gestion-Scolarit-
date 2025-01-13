class Group {
  int id;
  String libelle;

  Group({required this.id, required this.libelle});

  // Convertir un Group en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'libelle': libelle,
    };
  }

  // Convertir un Map en Group
  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'],
      libelle: map['libelle'],
    );
  }
}
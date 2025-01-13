class Student {
  final int id;
  final String nom;
  final String prenom;
  final String dateNaiss;
  final String tel;
  final String photo;
  final int groupeld;

  Student({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.dateNaiss,
    required this.tel,
    required this.photo,
    required this.groupeld,
  });

  // Convert a Student to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'dateNaiss': dateNaiss,
      'tel': tel,
      'photo': photo,
      'groupeld': groupeld,
    };
  }

  // Convert a Map to a Student
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      dateNaiss: map['dateNaiss'],
      tel: map['tel'],
      photo: map['photo'],
      groupeld: map['groupeld'],
    );
  }
}
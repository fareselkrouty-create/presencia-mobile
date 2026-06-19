class UserModel {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String matricule;
  final String role;
  final String? photo;
  final String? departement;
  final String? poste;

  UserModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.matricule,
    required this.role,
    this.photo,
    this.departement,
    this.poste,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id:          json['id'],
    nom:         json['nom'],
    prenom:      json['prenom'],
    email:       json['email'],
    matricule:   json['matricule'],
    role:        json['role'],
    photo:       json['photo'],
    departement: json['departement'],
    poste:       json['poste'],
  );

  Map<String, dynamic> toJson() => {
    'id':          id,
    'nom':         nom,
    'prenom':      prenom,
    'email':       email,
    'matricule':   matricule,
    'role':        role,
    'photo':       photo,
    'departement': departement,
    'poste':       poste,
  };

  UserModel copyWith({
    String? nom,
    String? prenom,
    String? email,
    String? photo,
    String? departement,
    String? poste,
  }) =>
      UserModel(
        id:          id,
        nom:         nom ?? this.nom,
        prenom:      prenom ?? this.prenom,
        email:       email ?? this.email,
        matricule:   matricule,
        role:        role,
        photo:       photo ?? this.photo,
        departement: departement ?? this.departement,
        poste:       poste ?? this.poste,
      );
}
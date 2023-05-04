class AppUser {
  final String uid;
  final String role;
  final String mail;
  final String name;

  AppUser(
      {required this.uid,
      required this.mail,
      required this.role,
      required this.name});

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['auth_id'],
      mail: json['mail'],
      name: json['name'],
      role: json['role'],
    );
  }
}

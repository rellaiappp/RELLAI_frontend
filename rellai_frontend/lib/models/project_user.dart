class ProjectUser {
  String id;
  String firstName;
  String lastName;
  String accessLevel;
  String email;

  ProjectUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.accessLevel,
    required this.email,
  });

  factory ProjectUser.fromJson(Map<String, dynamic> json) {
    return ProjectUser(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      accessLevel: json['accessLevel'],
      email: json['email'],
    );
  }
}

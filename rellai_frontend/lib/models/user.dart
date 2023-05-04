class AppUser {
  final String uid;
  final String role;
  final String mail;
  final String name;
  final String? phoneNumber;
  final String? address;
  final String? businessName;
  final String? profilePictureUrl;

  AppUser(
      {required this.uid,
      required this.mail,
      required this.role,
      required this.name,
      this.address,
      this.phoneNumber,
      this.businessName,
      this.profilePictureUrl});

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['auth_id'],
      mail: json['mail'],
      name: json['name'],
      role: json['role'],
      address: json['address'],
      businessName: json['business_name'],
      profilePictureUrl: json['profile_picture_url'],
    );
  }
}

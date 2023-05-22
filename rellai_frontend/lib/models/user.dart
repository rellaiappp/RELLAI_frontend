class AppUser {
  String? id;
  String firstName;
  String lastName;
  String email;
  String authId;
  DateTime? dateCreated;
  String role;
  Address? address;
  String? profileImageUrl;
  BusinessInfo? businessInfo;
  String? phone;

  AppUser(
      {this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.authId,
      this.dateCreated,
      required this.role,
      this.address,
      this.profileImageUrl,
      this.businessInfo,
      this.phone});

  AppUser.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'],
        phone = json['phone'],
        authId = json['authId'],
        dateCreated = json['dateCreated'] != null
            ? DateTime.parse(json['dateCreated'])
            : null,
        role = json['role'],
        address =
            json['address'] != null ? Address.fromJson(json['address']) : null,
        profileImageUrl = json['profileImageUrl'],
        businessInfo = json['businessInfo'] != null
            ? BusinessInfo.fromJson(json['businessInfo'])
            : null;

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'role': role,
        'address': address?.toJson(),
        'profileImageUrl': profileImageUrl,
        'businessInfo': businessInfo?.toJson(),
        'phone': phone
      };
}

class Address {
  String street;
  String city;
  String region;
  String state;
  String? zipCode;

  Address({
    required this.street,
    required this.city,
    required this.region,
    required this.state,
    this.zipCode,
  });

  Address.fromJson(Map<String, dynamic> json)
      : street = json['street'],
        city = json['city'],
        region = json['region'],
        state = json['state'],
        zipCode = json['zipCode'] ?? "";

  Map<String, dynamic> toJson() => {
        'street': street,
        'city': city,
        'region': region,
        'state': state,
        'zipCode': zipCode,
      };
}

class BusinessInfo {
  String? businessName;
  String? vatCode;

  BusinessInfo({
    this.businessName,
    this.vatCode,
  });

  BusinessInfo.fromJson(Map<String, dynamic> json)
      : businessName = json['businessName'],
        vatCode = json['vatCode'];

  Map<String, dynamic> toJson() => {
        'businessName': businessName,
        'vatCode': vatCode,
      };
}

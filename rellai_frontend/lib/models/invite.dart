class Invite {
  String id;
  Sender sender;
  ProjectInvite project;

  Invite({
    required this.id,
    required this.sender,
    required this.project,
  });

  factory Invite.fromJson(Map<String, dynamic> json) {
    return Invite(
      id: json['_id'],
      sender: Sender.fromJson(json['sender']),
      project: ProjectInvite.fromJson(json['project']),
    );
  }
}

class Sender {
  String firstName;
  String lastName;
  String email;

  Sender({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  Sender.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'] ?? '',
        lastName = json['lastName'] ?? '',
        email = json['email'] ?? '';
}

class ProjectInvite {
  String name;
  String type;
  InviteAddress address;

  ProjectInvite({
    required this.name,
    required this.type,
    required this.address,
  });

  ProjectInvite.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        type = json['type'] ?? '',
        address = InviteAddress.fromJson(json['address']);
}

class InviteAddress {
  String street;
  String city;
  String region;
  String state;
  String zipCode;

  InviteAddress(
      {required this.street,
      required this.city,
      required this.region,
      required this.state,
      required this.zipCode});

  InviteAddress.fromJson(Map<String, dynamic> json)
      : street = json['street'] ?? '',
        city = json['city'] ?? '',
        region = json['region'] ?? '',
        state = json['state'] ?? '',
        zipCode = json['zipCode'] ?? '';
}

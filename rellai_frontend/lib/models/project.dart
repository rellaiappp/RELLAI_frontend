import 'package:rellai_frontend/models/quote.dart';

class Project {
  String? id;
  Detail detail;
  Site site;
  String? role;
  String? creatorId;
  DateTime? dateCreated;
  Client client;
  String? accessLevel;
  List<Quotation> quotes; // List of Quotation objects

  Project({
    this.id,
    required this.client,
    required this.detail,
    required this.site,
    this.creatorId,
    this.dateCreated,
    this.accessLevel,
    this.quotes = const [],
  });

  Project.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        client = Client.fromJson(json['client'] ?? {}),
        detail = Detail.fromJson(json['detail'] ?? {}),
        site = Site.fromJson(json['site'] ?? {}),
        creatorId = json['creatorId'] ?? '',
        dateCreated =
            DateTime.parse(json['dateCreated'] ?? DateTime.now().toString()),
        accessLevel = json['accessLevel'] ?? '',
        quotes = (json['quotes'] as List<dynamic>? ?? [])
            .map((item) => Quotation.fromJson(item))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'client': client.toJson(),
      'detail': detail.toJson(),
      'site': site.toJson(),
      'creatorId': creatorId,
      'accessLevel': accessLevel,
      'quotes': quotes.map((item) => item.toJson()).toList(),
    };
  }
}

class Detail {
  String projectType;
  String name;
  String description;

  Detail(
      {required this.projectType,
      required this.name,
      required this.description});

  Detail.fromJson(Map<String, dynamic> json)
      : projectType = json['projectType'] ?? '',
        name = json['name'] ?? '',
        description = json['description'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'projectType': projectType,
      'name': name,
      'description': description,
    };
  }
}

class Site {
  String siteType;
  int floor; // change this to int if floor should be an integer
  Address address;

  Site({required this.siteType, required this.floor, required this.address});

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
      siteType: json['siteType'],
      floor: int.tryParse(json['floor'].toString()) ?? 0,
      address: Address.fromJson(json['address']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'siteType': siteType,
      'floor': floor,
      'address': address.toJson(),
    };
  }
}

class Client {
  String fullName;
  String email;

  Client({required this.fullName, required this.email});

  Client.fromJson(Map<String, dynamic> json)
      : fullName = json['fullName'] ?? '',
        email = json['email'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
    };
  }
}

class Address {
  String street;
  String city;
  String region;
  String state;
  String zipCode;

  Address(
      {required this.street,
      required this.city,
      required this.region,
      required this.state,
      required this.zipCode});

  Address.fromJson(Map<String, dynamic> json)
      : street = json['street'] ?? '',
        city = json['city'] ?? '',
        region = json['region'] ?? '',
        state = json['state'] ?? '',
        zipCode = json['zipCode'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'region': region,
      'state': state,
      'zipCode': zipCode,
    };
  }
}

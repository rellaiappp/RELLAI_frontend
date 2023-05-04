class Project {
  final String id;
  final int timestamp;
  final Client client;
  final String creatorId;
  final ProjectInfo projectInfo;
  final String? clientMail;
  final String? role;
  final Creator? creator;
  final String? invitationId;
  final double? total;
  final List<Quote>? quotations;
  final List<Quote>? variationOrders;
  final List<Quote>? changeOrders;

  Project(
      {required this.id,
      required this.timestamp,
      required this.client,
      required this.creatorId,
      required this.projectInfo,
      this.role,
      this.creator,
      this.clientMail,
      this.invitationId,
      this.quotations,
      this.variationOrders,
      this.total,
      this.changeOrders});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] ?? '',
      timestamp: json['timestamp'] ?? 0,
      client: Client.fromJson(json['client'] ?? {}),
      creatorId: json['creator_id'] ?? '',
      projectInfo: ProjectInfo.fromJson(json['general_info'] ?? {}),
      clientMail: json['client_mail'],
      role: json['role'],
      total: double.tryParse(json['total'].toString()),
      creator: json['creator_info'] != null
          ? Creator.fromJson(json['creator_info'])
          : null,
      invitationId: json['invitation_id'],
      quotations: json['quotations'] != null
          ? (json['quotations'] as List<dynamic>)
              .map((quotationJson) => Quote.fromJson(quotationJson))
              .toList()
          : null,
      variationOrders: json['variation_orders'] != null
          ? (json['variation_orders'] as List<dynamic>)
              .map((quotationJson) => Quote.fromJson(quotationJson))
              .toList()
          : null,
      changeOrders: json['change_orders'] != null
          ? (json['change_orders'] as List<dynamic>)
              .map((quotationJson) => Quote.fromJson(quotationJson))
              .toList()
          : null,
    );
  }
}

class Creator {
  final String id;
  final String mail;
  final String name;
  final String role;

  Creator({
    required this.id,
    required this.mail,
    required this.name,
    required this.role,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['auth_id'],
      mail: json['mail'],
      name: json['name'],
      role: json['role'],
    );
  }
}

class Client {
  final String nome;
  final String email;
  final String numeroCellulare;

  Client(
      {required this.nome, required this.email, required this.numeroCellulare});

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      nome: json['nome'],
      email: json['email'],
      numeroCellulare: json['numero_cellulare'],
    );
  }
}

class ProjectInfo {
  final String projectName;
  final String siteType;
  final double buildingAge;
  final double siteSurface;
  final String projectType;

  ProjectInfo({
    required this.projectName,
    required this.siteType,
    required this.buildingAge,
    required this.siteSurface,
    required this.projectType,
  });

  factory ProjectInfo.fromJson(Map<String, dynamic> json) {
    return ProjectInfo(
      projectName: json['nome_progetto'],
      siteType: json['tipologia_abitazione'],
      buildingAge:
          double.tryParse(json['eta_edificio']?.toString() ?? '0') ?? 0.0,
      siteSurface:
          double.tryParse(json['metri_quadrati']?.toString() ?? '0') ?? 0.0,
      projectType: json['tipo_intervento'],
    );
  }
}

class Quote {
  final String? id;
  final int? timestamp;
  final String creatorId;
  final String quoteDescription;
  final String projectId;
  final String quoteName;
  final String quoteType;
  final String quoteValidity;
  final String quoteStatus;
  final bool accepted;
  final List<Item>? items;
  final double? totalPrice;

  Quote({
    this.id,
    this.timestamp,
    required this.creatorId,
    required this.quoteDescription,
    required this.projectId,
    required this.quoteName,
    required this.quoteType,
    required this.quoteValidity,
    required this.quoteStatus,
    required this.accepted,
    this.items,
    this.totalPrice,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    List<Item>? itemList = [];
    if (json['items'] != null) {
      itemList =
          (json['items'] as List).map((item) => Item.fromJson(item)).toList();
    }
    return Quote(
      id: json['id'],
      timestamp: json['timestamp'],
      creatorId: json['creator_id'],
      quoteDescription: json['quote_description'],
      projectId: json['project_id'],
      quoteName: json['quote_name'],
      quoteType: json['quote_type'],
      quoteValidity: json['quote_validity'],
      quoteStatus: json['quote_status'],
      accepted: json['accepted'],
      totalPrice:
          double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      items: itemList,
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp,
        'creator_id': creatorId,
        'quote_description': quoteDescription,
        'project_id': projectId,
        'quote_name': quoteName,
        'quote_type': quoteType,
        'quote_validity': quoteValidity,
        'quote_status': quoteStatus,
        'accepted': accepted,
        'items': items?.map((item) => item.toJson()).toList(),
        'total_price': totalPrice,
      };
}

class Item {
  final String? id;
  final int? timestamp;
  final String? quoteId;
  final String itemName;
  final String itemType;
  final String itemDescription;
  final String itemUnit;
  final double itemNumber;
  final double itemUnitPrice;
  final double itemCompletion;

  Item({
    this.id,
    this.timestamp,
    this.quoteId,
    required this.itemName,
    required this.itemType,
    required this.itemDescription,
    required this.itemUnit,
    required this.itemNumber,
    required this.itemUnitPrice,
    required this.itemCompletion,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      timestamp: json['timestamp'],
      quoteId: json['quote_id'],
      itemName: json['item_name'],
      itemType: json['item_type'],
      itemDescription: json['item_description'],
      itemUnit: json['item_unit'].toString(),
      itemNumber: double.tryParse(json['item_number'].toString()) ?? 0.0,
      itemUnitPrice: double.tryParse(json['item_unit_price'].toString()) ?? 0.0,
      itemCompletion:
          double.tryParse(json['item_completion']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp,
        'quote_id': quoteId,
        'item_name': itemName,
        'item_type': itemType,
        'item_description': itemDescription,
        'item_unit': itemUnit,
        'item_number': itemNumber,
        'item_unit_price': itemUnitPrice,
        'item_completion': itemCompletion,
      };
}

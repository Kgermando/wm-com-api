

class AgendaModel {
  late int? id;
  late String title;
  late String description;
  late DateTime dateRappel;
  late String signature;
  late DateTime created;
  late String business;

  AgendaModel(
      {this.id,
      required this.title,
      required this.description,
      required this.dateRappel,
      required this.signature,
      required this.created,
      required this.business});

  factory AgendaModel.fromSQL(List<dynamic> row) {
    return AgendaModel(
        id: row[0],
        title: row[1],
        description: row[2],
        dateRappel: row[3],
        signature: row[4],
        created: row[5],
        business: row[6]);
  }

  factory AgendaModel.fromJson(Map<String, dynamic> json) {
    return AgendaModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        dateRappel: DateTime.parse(json['dateRappel']),
        signature: json['signature'],
        created: DateTime.parse(json['created']),
      business: json['business'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateRappel': dateRappel.toIso8601String(),
      'signature': signature,
      'created': created.toIso8601String(),
      'business': business,
    };
  }


}

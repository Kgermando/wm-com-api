class GainModel {
  late int? id;
  late double sum;
  late String succursale;
  late String signature; // celui qui fait le document
  late DateTime created;
  late String business;

  GainModel(
      {this.id,
      required this.sum,
      required this.succursale,
      required this.signature,
      required this.created,
      required this.business});

  factory GainModel.fromSQL(List<dynamic> row) {
    return GainModel(
        id: row[0],
        sum: row[1],
        succursale: row[2],
        signature: row[3],
        created: row[4],
        business: row[5]);
  }

  factory GainModel.fromJson(Map<String, dynamic> json) {
    return GainModel(
        id: json['id'],
        sum: double.parse(json['sum'].toString()),
        succursale: json['succursale'],
        signature: json['signature'],
        created: DateTime.parse(json['created']),
        business: json['business']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sum': sum,
      'succursale': succursale,
      'signature': signature,
      'created': created.toIso8601String(),
      'business': business
    };
  }

  
}

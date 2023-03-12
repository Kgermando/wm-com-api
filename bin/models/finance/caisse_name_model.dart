class CaisseNameModel {
  late int? id;
  late String nomComplet;
  late String rccm;
  late String idNat;
  late String addresse;
  late DateTime created;
  late String business;

  CaisseNameModel(
      {this.id,
      required this.nomComplet,
      required this.rccm,
      required this.idNat,
      required this.addresse,
      required this.created,
      required this.business});

  factory CaisseNameModel.fromSQL(List<dynamic> row) {
    return CaisseNameModel(
        id: row[0],
        nomComplet: row[1],
        rccm: row[2],
        idNat: row[3],
        addresse: row[4],
        created: row[5],
        business: row[6]);
  }

  factory CaisseNameModel.fromJson(Map<String, dynamic> json) {
    return CaisseNameModel(
        id: json['id'],
        nomComplet: json['nomComplet'],
        rccm: json['rccm'],
        idNat: json['idNat'],
        addresse: json['addresse'],
        created: DateTime.parse(json['created']),
        business: json['business']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomComplet': nomComplet,
      'rccm': rccm,
      'idNat': idNat,
      'addresse': addresse,
      'created': created.toIso8601String(),
      'business': business
    };
  }

 
}

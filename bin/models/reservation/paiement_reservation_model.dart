class PaiementReservationModel {
  late int? id;
  late int reference;
  late String client;
  late String motif;
  late String montant;
  late String signature; // celui qui fait le document
  late DateTime created;
  late String business;

  PaiementReservationModel({
    this.id,
    required this.reference,
    required this.client,
    required this.motif,
    required this.montant,
    required this.signature,
    required this.created,
    required this.business,
  });

  factory PaiementReservationModel.fromSQL(List<dynamic> row) {
    return PaiementReservationModel(
        id: row[0],
        reference: row[1],
        client: row[2],
        motif: row[3],
        montant: row[4],
        signature: row[5],
        created: row[6],
        business: row[7]);
  }

  factory PaiementReservationModel.fromJson(Map<String, dynamic> json) {
    return PaiementReservationModel(
      id: json["id"],
      reference: json["reference"],
      client: json["client"],
      motif: json["motif"],
      montant: json["montant"],
      signature: json['signature'],
      created: DateTime.parse(json['created']),
      business: json['business'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference': reference,
      'client': client,
      'motif': motif,
      'montant': montant,
      'signature': signature,
      'created': created.toIso8601String(),
      'business': business
    };
  }

  
}

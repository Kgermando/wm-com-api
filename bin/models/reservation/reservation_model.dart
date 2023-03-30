class ReservationModel {
  late int? id;
  late String client;
  late String telephone;
  late String email;
  late String adresse;
  late String nbrePersonne;
  late String dureeEvent; // Le temps que va durée cette manifestation
  late DateTime createdDay; // Date du SfCalendar
  late String background; // Effectuer, Interrompu, Non Effectuer
  late String eventName; // type de manifestation
  late String signature; // celui qui fait le document
  late DateTime created;
  late String montant;
  late String business;
  late String sync; // new, update, sync
  late String async;

  ReservationModel(
      {this.id,
      required this.client,
      required this.telephone,
      required this.email,
      required this.adresse,
      required this.nbrePersonne,
      required this.dureeEvent,
      required this.createdDay,
      required this.background,
      required this.eventName,
      required this.signature,
      required this.created,
      required this.montant,
      required this.business,
    required this.sync,
    required this.async,
  });

  factory ReservationModel.fromSQL(List<dynamic> row) {
    return ReservationModel(
        id: row[0],
        client: row[1],
        telephone: row[2],
        email: row[3],
        adresse: row[4],
        nbrePersonne: row[5],
        dureeEvent: row[6],
        createdDay: row[7],
        background: row[8],
        eventName: row[9],
        signature: row[10],
        created: row[11],
        montant: row[12],
        business: row[13],
        sync: row[14],
        async: row[15]);
  }

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json["id"],
      client: json["client"],
      telephone: json["telephone"],
      email: json["email"],
      adresse: json["adresse"],
      nbrePersonne: json["nbrePersonne"],
      dureeEvent: json["dureeEvent"],
      createdDay: DateTime.parse(json['createdDay']),
      background: json["background"],
      eventName: json["eventName"],
      signature: json['signature'],
      created: DateTime.parse(json['created']),
      montant: json['montant'],
        business: json['business'],
      sync: json['sync'],
      async: json['async'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client': client,
      'telephone': telephone,
      'email': email,
      'adresse': adresse,
      'nbrePersonne': nbrePersonne,
      'dureeEvent': dureeEvent,
      'createdDay': createdDay.toIso8601String(),
      'background': background,
      'eventName': eventName,
      'signature': signature,
      'created': created.toIso8601String(),
      'montant': montant,
      'business': business,
      'sync': sync,
      'async': async,
    };
  }

 
}

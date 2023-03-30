import 'package:postgres/postgres.dart';

import '../../models/reservation/paiement_reservation_model.dart';

class PaiementReservationRepository {
  final PostgreSQLConnection executor;
  final String tableName;

  PaiementReservationRepository(this.executor, this.tableName);

  Future<List<PaiementReservationModel>> getAllData(String business) async {
    var data = <PaiementReservationModel>{};

    var querySQL = "SELECT * FROM $tableName WHERE \"business\"='$business' ORDER BY \"created\" DESC;";
    List<List<dynamic>> results = await executor.query(querySQL);
    for (var row in results) {
      data.add(PaiementReservationModel.fromSQL(row));
    }
    return data.toList();
  }

  Future<void> insertData(PaiementReservationModel data) async {
    await executor.transaction((ctx) async {
      await ctx.query(
          "INSERT INTO $tableName (id, reference, client, motif,"
          "montant, succursale, signature, created,"
          "business, sync, async)"
          "VALUES (nextval('paiement_reservations_id_seq'),"
          "@1, @2, @3, @4, @5, @6, @7, @8, @9, @10)",
          substitutionValues: {
            '1': data.reference,
            '2': data.client,
            '3': data.motif,
            '4': data.montant,
            '5': data.signature,
            '6': data.signature,
            '7': data.created,
            '8': data.business,
            '9': data.sync,
            '10': data.async,
          });
    });
  }

  Future<void> update(PaiementReservationModel data) async {
    await executor.query("""UPDATE $tableName
      SET reference = @1, client = @2, motif = @3, montant = @4, succursale = @5,
        signature = @6, created = @7, business = @8, 
        sync = @9, async = @10 WHERE id = @11""",
        substitutionValues: {
          '1': data.reference,
          '2': data.client,
          '3': data.motif,
          '4': data.montant,
          '5': data.signature,
          '6': data.signature,
          '7': data.created,
          '8': data.business,
          '9': data.sync,
          '10': data.async,
          '11': data.id
        });
  }

  deleteData(int id) async {
    try {
      await executor.transaction((conn) async {
        // ignore: unused_local_variable
        var result =
            await conn.execute("DELETE FROM $tableName WHERE \"id\" = '$id';");
      });
    } catch (e) {
      'erreur $e';
    }
  }

  Future<PaiementReservationModel> getFromId(int id) async {
    var data =
        await executor.query("SELECT * FROM  $tableName WHERE \"id\" = '$id';");
    return PaiementReservationModel(
      id: data[0][0],
      reference: data[0][1],
      client: data[0][2],
      motif: data[0][3],
      montant: data[0][4],
      succursale: data[0][5],
      signature: data[0][6],
      created: data[0][7],
      business: data[0][8],
      sync: data[0][9],
      async: data[0][10],
    );
  }
}

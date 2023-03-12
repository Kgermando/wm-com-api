import 'package:postgres/postgres.dart';

import '../../models/abonnement/abonnement_model.dart';

class AbonnementRepository {
  final PostgreSQLConnection executor;
  final String tableName;

  AbonnementRepository(this.executor, this.tableName);

  Future<List<AbonnementModel>> getAllData() async {
    var data = <AbonnementModel>{};

    var querySQL = "SELECT * FROM $tableName ORDER BY \"created\" DESC;";
    List<List<dynamic>> results = await executor.query(querySQL);
    for (var row in results) {
      data.add(AbonnementModel.fromSQL(row));
    }
    return data.toList();
  }

  Future<void> insertData(AbonnementModel data) async {
    await executor.transaction((ctx) async {
      await ctx.query(
          "INSERT INTO $tableName (id, statut, date_abonnement,"
          "date_echeance, ref_code, moyen, business, signature, created)"
          "VALUES (nextval('abonnements_id_seq'), @1, @2, @3, @4, @5, @6, @7, @8)",
          substitutionValues: {
            '1': data.statut,
            '2': data.dateAbonnement,
            '3': data.dateEcheance,
            '4': data.business,
            '5': data.refCode,
            '6': data.moyen,
            '7': data.signature,
            '8': data.created
          });
    });
  }

  Future<void> update(AbonnementModel data) async {
    await executor.query("""UPDATE $tableName
      SET statut = @1, date_abonnement = @2, date_echeance = @3, ref_code = @4,
      moyen = @5, business = @6, signature = @7, created = @8 WHERE id = @9""",
        substitutionValues: {
          '1': data.statut,
          '2': data.dateAbonnement,
          '3': data.dateEcheance,
          '4': data.business,
          '5': data.refCode,
          '6': data.moyen,
          '7': data.signature,
          '8': data.created,
          '9': data.id
        });
  }

  deleteData(int id) async {
    try {
      await executor.transaction((conn) async {
        // ignore: unused_local_variable
        var result = await conn.execute('DELETE FROM $tableName WHERE id=$id;');
      });
    } catch (e) {
      'erreur $e';
    }
  }

  Future<AbonnementModel> getFromId(int id) async {
    var data =
        await executor.query("SELECT * FROM  $tableName WHERE \"id\" = '$id'");
    return AbonnementModel(
      id: data[0][0],
      statut: data[0][1],
      dateAbonnement: data[0][2],
      dateEcheance: data[0][3],
      refCode: data[0][4],
      moyen: data[0][5],
      business: data[0][6],
      signature: data[0][7],
      created: data[0][8]
    );
  }
}

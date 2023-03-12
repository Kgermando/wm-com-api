import 'package:postgres/postgres.dart';
 
import '../../models/commercial/ardoise_model.dart';

class ArdoiseRepository {
  final PostgreSQLConnection executor;
  final String tableName;

  ArdoiseRepository(this.executor, this.tableName);

  Future<List<ArdoiseModel>> getAllData(String business) async {
    var data = <ArdoiseModel>{};

    var querySQL = "SELECT * FROM $tableName WHERE \"business\"='$business' ORDER BY \"created\" DESC;";
    List<List<dynamic>> results = await executor.query(querySQL);
    for (var row in results) {
      data.add(ArdoiseModel.fromSQL(row));
    }
    return data.toList();
  }

  Future<void> insertData(ArdoiseModel data) async {
    await executor.transaction((ctx) async {
      await ctx.execute(
          "INSERT INTO $tableName (id, ardoise, ardoise_json, statut,"
          "succursale, signature, created, business)"
          "VALUES (nextval('ardoises_id_seq'), @1, @2, @3, @4, @5, @6, @7)",
          substitutionValues: {
            '1': data.ardoise,
            '2': data.ardoiseJson,
            '3': data.statut,
            '4': data.succursale,
            '5': data.signature,
            '6': data.created,
            '7': data.business
          });
    });
  }

  Future<void> update(ArdoiseModel data) async {
    await executor.query("""UPDATE $tableName
          SET ardoise = @1, ardoise_json = @2, statut = @3, succursale = @4,
          signature = @5, created = @6, business = @7 WHERE id = @8""",
        substitutionValues: {
          '1': data.ardoise,
          '2': data.ardoiseJson,
          '3': data.statut,
          '4': data.succursale,
          '5': data.signature,
          '6': data.created,
          '7': data.business, 
          '8': data.id
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

  Future<ArdoiseModel> getFromId(int id) async {
    var data =
        await executor.query("SELECT * FROM  $tableName WHERE \"id\" = '$id'");
    return ArdoiseModel(
        id: data[0][0],
        ardoise: data[0][1],
        ardoiseJson: data[0][2],
        statut: data[0][3],
        succursale: data[0][4],
        signature: data[0][5],
        created: data[0][6],
        business: data[0][7]
      );
  }
}

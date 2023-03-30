import 'package:postgres/postgres.dart';

import '../../models/restaurant/table_restaurant_model.dart';
 

class TableLivraisonRepository {
  final PostgreSQLConnection executor;
  final String tableName;

  TableLivraisonRepository(this.executor, this.tableName);

  Future<List<TableRestaurantModel>> getAllData(String business) async {
    var data = <TableRestaurantModel>{};

    var querySQL =
        "SELECT * FROM $tableName WHERE \"business\"='$business' ORDER BY \"created\" DESC;";
    List<List<dynamic>> results = await executor.query(querySQL);
    for (var row in results) {
      data.add(TableRestaurantModel.fromSQL(row));
    }
    return data.toList();
  }


  Future<void> insertData(TableRestaurantModel data) async {
    await executor.transaction((ctx) async {
      await ctx.execute(
          "INSERT INTO $tableName (id, table, part,"
          "succursale, signature, created, business, sync, async)"
          "VALUES (nextval('table_livraisons_id_seq'), @1, @2, @3, @4, @5, @6, @7, @8)",
          substitutionValues: {
            '1': data.table,
            '2': data.part,
            '3': data.succursale,
            '4': data.signature,
            '5': data.created,
            '6': data.business,
            '7': data.sync,
            '8': data.async
          });
    });
  }

  Future<void> update(TableRestaurantModel data) async {
    await executor.query("""UPDATE $tableName
      SET table = @1, part = @2, succursale = @3,
      signature = @4, created = @5, business = @6, 
      sync = @7, async = @8 WHERE id = @9""", substitutionValues: {
      '1': data.table,
      '2': data.part,
      '3': data.succursale,
      '4': data.signature,
      '5': data.created,
      '6': data.business,
      '7': data.sync,
      '8': data.async,
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

  Future<TableRestaurantModel> getFromId(int id) async {
    var data =
        await executor.query("SELECT * FROM  $tableName WHERE \"id\" = '$id'");
    return TableRestaurantModel(
      id: data[0][0],
      table: data[0][1],
      part: data[0][2],
      succursale: data[0][3],
      signature: data[0][4],
      created: data[0][5],
      business: data[0][6],
      sync: data[0][7],
      async: data[0][8],
    );
  }
}

import 'package:postgres/postgres.dart';

import '../../models/restaurant/restaurant_model.dart';
 

class TerrasseRepository {
  final PostgreSQLConnection executor;
  final String tableName;

  TerrasseRepository(this.executor, this.tableName);

  Future<List<RestaurantModel>> getAllData(String business) async {
    var data = <RestaurantModel>{};

    var querySQL =
        "SELECT * FROM $tableName WHERE \"business\"='$business' ORDER BY \"created\" DESC;";
    List<List<dynamic>> results = await executor.query(querySQL);
    for (var row in results) {
      data.add(RestaurantModel.fromSQL(row));
    }
    return data.toList();
  }

  Future<void> insertData(RestaurantModel data) async {
    await executor.transaction((ctx) async {
      await ctx.query(
          "INSERT INTO $tableName (id, identifiant, table, qty,"
          "price, unite, statut_commande, succursale, signature,"
          "created, business, sync, async)"
          "VALUES (nextval('terrasses_id_seq'), @1, @2, @3,"
          "@4, @5, @6, @7, @8, @9, @10, @11, @12)",
          substitutionValues: {
            '1': data.identifiant,
            '2': data.table,
            '3': data.qty,
            '4': data.price,
            '5': data.unite,
            '6': data.statutCommande,
            '7': data.succursale,
            '8': data.signature,
            '9': data.created,
            '10': data.business,
            '11': data.sync,
            '12': data.async
          });
    });
  }

  Future<void> update(RestaurantModel data) async {
    await executor.query("""UPDATE $tableName
      SET identifiant = @1, table = @2, qty = @3, price = @4, 
        unite = @5, statut_commande = @6, succursale = @7, signature = @8, 
        created = @9, business = @10, sync = @11, async = @12 WHERE id = @13""",
        substitutionValues: {
          '1': data.identifiant,
          '2': data.table,
          '3': data.qty,
          '4': data.price,
          '5': data.unite,
          '6': data.statutCommande,
          '7': data.succursale,
          '8': data.signature,
          '9': data.created,
          '10': data.business,
          '11': data.sync,
          '12': data.async,
          '13': data.id
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

  Future<RestaurantModel> getFromId(int id) async {
    var data =
        await executor.query("SELECT * FROM  $tableName WHERE \"id\" = '$id';");
    return RestaurantModel(
      id: data[0][0],
      identifiant: data[0][1],
      table: data[0][2],
      qty: data[0][3],
      price: data[0][4],
      unite: data[0][5],
      statutCommande: data[0][6],
      succursale: data[0][7],
      signature: data[0][8],
      created: data[0][9],
      business: data[0][10],
      sync: data[0][11],
      async: data[0][12],
    );
  }
}

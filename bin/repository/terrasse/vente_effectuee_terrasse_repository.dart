import 'package:postgres/postgres.dart';

import '../../models/restaurant/courbe_vente_gain_restaurant_model.dart';
import '../../models/restaurant/vente_chart_restaurant_model.dart';
import '../../models/restaurant/vente_restaurant_model.dart';
 

class VenteEffectueeTerrasseRepository {
  final PostgreSQLConnection executor;
  final String tableName;

  VenteEffectueeTerrasseRepository(this.executor, this.tableName);

  Future<List<VenteRestaurantModel>> getAllData(String business) async {
    var data = <VenteRestaurantModel>{};

    var querySQL =
        "SELECT * FROM $tableName WHERE \"business\"='$business' ORDER BY \"created\" DESC;";
    List<List<dynamic>> results = await executor.query(querySQL);
    for (var row in results) {
      data.add(VenteRestaurantModel.fromSQL(row));
    }
    return data.toList();
  }

  Future<List<VenteChartRestaurantModel>> getAllDataChart(String business) async {
    var data = <VenteChartRestaurantModel>{};
    var querySQL = """SELECT "identifiant", COUNT(*) 
      FROM $tableName 
      GROUP BY "identifiant" 
      ORDER BY COUNT DESC LIMIT 10;""";

    List<List<dynamic>> results = await executor.query(querySQL);
    for (var row in results) {
      data.add(VenteChartRestaurantModel.fromSQL(row));
    }
    return data.toList();
  }

  Future<List<CourbeVenteRestaurantModel>> getAllDataChartDay(String business) async {
    var data = <CourbeVenteRestaurantModel>{};

    var querySQL = """SELECT EXTRACT(HOUR FROM "created" ::TIMESTAMP), 
          SUM("price_total_cart"::FLOAT) 
          FROM $tableName WHERE "business"='$business' AND
          DATE("created") >= CURRENT_DATE AND 
          DATE("created") < CURRENT_DATE + INTERVAL '1 DAY' 
          GROUP BY EXTRACT(HOUR FROM "created" ::TIMESTAMP) 
          ORDER BY EXTRACT(HOUR FROM "created" ::TIMESTAMP) ASC;
      """;
    List<List<dynamic>> results = await executor.query(querySQL);
    for (var row in results) {
      data.add(CourbeVenteRestaurantModel.fromSQL(row));
    }
    return data.toList();
  }

  Future<List<CourbeVenteRestaurantModel>> getAllDataChartMounth(String business) async {
    var data = <CourbeVenteRestaurantModel>{};

    // Filtre est égal à l'année et le mois actuel
    var querySQL = """SELECT EXTRACT(DAY FROM "created" ::TIMESTAMP),
        SUM(price_total_cart::FLOAT) 
        FROM $tableName WHERE "business"='$business' AND
        EXTRACT(MONTH FROM "created" ::TIMESTAMP) = EXTRACT(MONTH FROM CURRENT_DATE ::TIMESTAMP) AND
        EXTRACT(YEAR FROM "created" ::TIMESTAMP) = EXTRACT(YEAR FROM CURRENT_DATE ::TIMESTAMP)
        GROUP BY EXTRACT(DAY FROM "created" ::TIMESTAMP) 
        ORDER BY EXTRACT(DAY FROM "created" ::TIMESTAMP) ASC;
      """;
    List<List<dynamic>> results = await executor.query(querySQL);
    for (var row in results) {
      data.add(CourbeVenteRestaurantModel.fromSQL(row));
    }
    return data.toList();
  }

  Future<List<CourbeVenteRestaurantModel>> getAllDataChartYear(String business) async {
    var data = <CourbeVenteRestaurantModel>{};
    // Filtre est egal à l'année actuel
    var querySQL = """SELECT EXTRACT(MONTH FROM "created" ::TIMESTAMP), 
        SUM(price_total_cart::FLOAT) 
      FROM $tableName WHERE "business"='$business' AND
      EXTRACT(YEAR FROM "created" ::TIMESTAMP) = EXTRACT(YEAR FROM CURRENT_DATE ::TIMESTAMP)
      GROUP BY EXTRACT(MONTH FROM "created" ::TIMESTAMP) 
      ORDER BY EXTRACT(MONTH FROM "created" ::TIMESTAMP) ASC;
    """;
    List<List<dynamic>> results = await executor.query(querySQL);
    for (var row in results) {
      data.add(CourbeVenteRestaurantModel.fromSQL(row));
    }
    return data.toList();
  }

 Future<void> insertData(VenteRestaurantModel data) async {
    await executor.transaction((ctx) async {
      await ctx.execute(
          "INSERT INTO $tableName (id, identifiant, table,"
          "price_total_cart, qty, price, unite,"
          "succursale, signature, created, business, sync, async)"
          "VALUES (nextval('vente_effectuee_terrasses_id_seq'),"
          "@1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12)",
          substitutionValues: {
            '1': data.identifiant,
            '2': data.table,
            '3': data.priceTotalCart,
            '4': data.qty,
            '5': data.price,
            '6': data.unite,
            '7': data.succursale,
            '8': data.signature,
            '9': data.created,
            '10': data.business,
            '11': data.sync,
            '12': data.async
          });
    });
  }

  Future<void> update(VenteRestaurantModel data) async {
    await executor.query("""UPDATE $tableName
      SET identifiant = @1, table = @2, price_total_cart = @3,
        qty = @4, price = @5, unite = @6, succursale = @7, 
        signature = @8, created = @9, business = @10, 
        sync = @11, async = @12 WHERE id = @13""", substitutionValues: {
      '1': data.identifiant,
      '2': data.table,
      '3': data.priceTotalCart,
      '4': data.qty,
      '5': data.price,
      '6': data.unite,
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
        var result = await conn.execute('DELETE FROM $tableName WHERE id=$id;');
      });
    } catch (e) {
      'erreur $e';
    }
  }

  Future<VenteRestaurantModel> getFromId(int id) async {
    var data =
        await executor.query("SELECT * FROM  $tableName WHERE \"id\" = '$id'");
    return VenteRestaurantModel(
      id: data[0][0],
      identifiant: data[0][1],
      table: data[0][2],
      priceTotalCart: data[0][3],
      qty: data[0][4],
      price: data[0][5],
      unite: data[0][6],
      succursale: data[0][7],
      signature: data[0][8],
      created: data[0][9],
      business: data[0][10],
      sync: data[0][11],
      async: data[0][12],
    );
  }
}

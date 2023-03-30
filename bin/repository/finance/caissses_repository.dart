import 'package:postgres/postgres.dart';

import '../../models/finance/charts_multi.dart';
import '../../models/finance/caisse_model.dart'; 

class CaissesRepository {
  final PostgreSQLConnection executor;
  final String tableName;

  CaissesRepository(this.executor, this.tableName);

  Future<List<CaisseModel>> getAllData(String business) async {
    var data = <CaisseModel>{};

    var querySQL = "SELECT * FROM $tableName WHERE \"business\"='$business' ORDER BY \"created\" DESC;";
    List<List<dynamic>> results = await executor.query(querySQL);
    for (var row in results) {
      data.add(CaisseModel.fromSQL(row));
    }
    return data.toList();
  }

  Future<List<ChartFinanceModel>> getAllDataChart(String business) async {
    var data = <ChartFinanceModel>{};

    var querySQL =
        "SELECT \"caisse_name\", SUM(\"montant_encaissement\"::FLOAT), SUM(\"montant_decaissement\"::FLOAT) FROM $tableName  WHERE \"business\"='$business' GROUP BY \"caisse_name\";";

    List<List<dynamic>> results = await executor.query(querySQL);
    for (var row in results) {
      data.add(ChartFinanceModel.fromSQL(row));
    }
    return data.toList();
  } 

  Future<void> insertData(CaisseModel data) async {
    await executor.transaction((ctx) async {
      await ctx.execute(
        "INSERT INTO $tableName (id, nom_complet, piece_justificative,"
        "libelle, montant_encaissement,"
        "departement, type_operation, numero_operation, signature,"
        "reference, caisse_name, created, montant_decaissement, business, sync, async)"
        "VALUES (nextval('caisses_id_seq'), @1, @2, @3, @4, @5, @6,"
        "@7, @8, @9, @10, @11, @12, @13, @14, @15)",
        substitutionValues: {
           '1': data.nomComplet,
            '2': data.pieceJustificative,
            '3': data.libelle,
            '4': data.montantEncaissement,
            '5': data.departement,
            '6': data.typeOperation,
            '7': data.numeroOperation,
            '8': data.signature,
            '9': data.reference,
            '10': data.caisseName,
            '11': data.created,
            '12': data.montantDecaissement,
            '13': data.business,
            '14': data.sync,
            '15': data.async,
        });
    });
  }

  Future<void> update(CaisseModel data) async {
    await executor.query("""UPDATE $tableName
        SET nom_complet = @1, piece_justificative = @2, libelle = @3,
        montant_encaissement = @4, departement = @5,
        type_operation = @6, numero_operation = @7, signature = @8,
        reference = @9, caisse_name = @10, created = @11, 
        montant_decaissement = @12, business = @13, 
        sync = @14, async = @15 WHERE id = @16""", substitutionValues: {
      '1': data.nomComplet,
      '2': data.pieceJustificative,
      '3': data.libelle,
      '4': data.montantEncaissement,
      '5': data.departement,
      '6': data.typeOperation,
      '7': data.numeroOperation,
      '8': data.signature,
      '9': data.reference,
      '10': data.caisseName,
      '11': data.created,
      '12': data.montantDecaissement,
      '13': data.business,
      '14': data.sync,
      '15': data.async,
      '16': data.id
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

  Future<CaisseModel> getFromId(int id) async {
    var data =
        await executor.query("SELECT * FROM  $tableName WHERE \"id\" = '$id'");
    return CaisseModel(
        id: data[0][0],
        nomComplet: data[0][1],
        pieceJustificative: data[0][2],
        libelle: data[0][3],
        montantEncaissement: data[0][4],
        departement: data[0][5],
        typeOperation: data[0][6],
        numeroOperation: data[0][7],
        signature: data[0][8],
        reference: data[0][9],
        caisseName: data[0][10],
        created: data[0][11],
       montantDecaissement: data[0][12],
      business: data[0][13],
      sync: data[0][14],
      async: data[0][15],
      );
  }


}
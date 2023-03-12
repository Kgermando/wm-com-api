import 'package:postgres/postgres.dart';

import '../../models/archive/archive_model.dart';

class ArchiveFolderRepository {
  final PostgreSQLConnection executor;
  final String tableName;

  ArchiveFolderRepository(this.executor, this.tableName);


  Future<List<ArchiveFolderModel>> getAllData(String business) async {
    var data = <ArchiveFolderModel>{};

    var querySQL = "SELECT * FROM $tableName WHERE \"business\"='$business' ORDER BY \"created\" DESC;";
    List<List<dynamic>> results = await executor.query(querySQL);
    for (var row in results) {
      data.add(ArchiveFolderModel.fromSQL(row));
    }
    return data.toList();
  }

  Future<void> insertData(ArchiveFolderModel data) async {
    await executor.transaction((ctx) async {
      await ctx.query(
        "INSERT INTO $tableName (id, departement, folder_name,"
        "signature, created, business)"
        "VALUES (nextval('archives_folders_id_seq'), @1, @2, @3, @4, @5)",
        substitutionValues: {
          '1': data.departement,
          '2': data.folderName,
          '3': data.signature,
          '4': data.created,
          '5': data.business
        });
    });
  }

  Future<void> update(ArchiveFolderModel data) async {
    await executor.query("""UPDATE $tableName
        SET departement = @1, folder_name = @2,
        signature = @3, created = @4, business = @5 WHERE id = @6""", substitutionValues: {
      '1': data.departement,
      '2': data.folderName,
      '3': data.signature,
      '4': data.created,
      '5': data.business,
      '6': data.id
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

  Future<ArchiveFolderModel> getFromId(int id) async {
    var data =
        await executor.query("SELECT * FROM  $tableName WHERE \"id\" = '$id'");
    return ArchiveFolderModel(
      id: data[0][0],
      departement: data[0][1],
      folderName: data[0][2],
      signature: data[0][3],
      created: data[0][4],
        business: data[0][5]
    );
  } 
}
import 'package:postgres/postgres.dart';

import '../../models/rh/agent_count_model.dart';
import '../../models/rh/agent_model.dart';

class AgentsRepository {
  final PostgreSQLConnection executor;
  final String tableName;

  AgentsRepository(this.executor, this.tableName);

  Future<List<AgentModel>> getAllData(String business) async {
    var data = <AgentModel>{};
 
    var querySQL = "SELECT * FROM $tableName WHERE \"business\"='$business' ORDER BY \"created_at\" DESC;";
    List<List<dynamic>> results = await executor.query(querySQL);
    for (var row in results) {
      data.add(AgentModel.fromSQL(row));
    }
    return data.toList();
  }

  Future<List<AgentPieChartModel>> getAgentChartPie(String business) async {
    try {
      var data = <AgentPieChartModel>{}; 
      var querySQL =
          "SELECT sexe, COUNT(sexe) FROM $tableName WHERE \"business\"='$business' GROUP BY \"sexe\";";
      List<List<dynamic>> results = await executor.query(querySQL);
      for (var row in results) {
        data.add(AgentPieChartModel.fromSQL(row));
      }
      return data.toList();
    } catch (e) {
      throw AgentPieChartModel;
    }
  }

  
  Future<AgentCountModel> getCount(String business) async {
    try {
      var data = <AgentCountModel>{};
      var querySQL = "SELECT COUNT(*) FROM $tableName WHERE \"business\"='$business' ;";
      List<List<dynamic>> results = await executor.query(querySQL);
      for (var row in results) {
        data.add(AgentCountModel.fromSQL(row));
      }
      return data.single;
    } catch (e) {
      throw AgentCountModel;
    }
  }

  Future<void> insertData(AgentModel agentModel) async {
    await executor.transaction((ctx) async {
      await ctx.execute(
          "INSERT INTO $tableName (id, nom, postnom, prenom, email, telephone,"
          "adresse, sexe, role, matricule, date_naissance,"
          "lieu_naissance, nationalite, type_contrat, departement, services_affectation,"
          "date_debut_contrat, date_fin_contrat, fonction_occupe, detail_personnel,"
          "statut_agent, created_at, photo, salaire, signature, created, is_delete, business, sync, async)"
          "VALUES (nextval('agents_id_seq'), @1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12,"
          "@13, @14, @15, @16, @17, @18, @19, @20, @21, @22, @23, @24, @25, @26, @27, @28, @29)",
          substitutionValues: {
            '1': agentModel.nom,
            '2': agentModel.postNom,
            '3': agentModel.prenom,
            '4': agentModel.email,
            '5': agentModel.telephone,
            '6': agentModel.adresse,
            '7': agentModel.sexe,
            '8': agentModel.role,
            '9': agentModel.matricule,
            '10': agentModel.dateNaissance,
            '11': agentModel.lieuNaissance,
            '12': agentModel.nationalite,
            '13': agentModel.typeContrat,
            '14': agentModel.departement,
            '15': agentModel.servicesAffectation,
            '16': agentModel.dateDebutContrat,
            '17': agentModel.dateFinContrat,
            '18': agentModel.fonctionOccupe,
            '19': agentModel.detailPersonnel,
            '20': agentModel.statutAgent,
            '21': agentModel.createdAt,
            '22': agentModel.photo,
            '23': agentModel.salaire,
            '24': agentModel.signature,
            '25': agentModel.created,
            '26': agentModel.isDelete,
            '27': agentModel.business,
            '28': agentModel.sync,
            '29': agentModel.async
          });
    });
  }


  Future<void> update(AgentModel agentModel) async {
    await executor.execute("""UPDATE $tableName
        SET nom = @1, postnom = @2, prenom = @3, email = @4, telephone = @5,
        adresse = @6, sexe = @7, role = @8, matricule = @9,
        date_naissance = @10, lieu_naissance = @11, nationalite = @12, type_contrat = @13,
        departement = @14, services_affectation = @15, date_debut_contrat = @16,
        date_fin_contrat = @17, fonction_occupe = @18, detail_personnel = @19,
        statut_agent = @20, created_at = @21, photo = @22,
        salaire = @23, signature = @24, created = @25, is_delete = @26, business = @27, 
        sync = @28, async = @29 WHERE id = @30""",

        substitutionValues: {
          '1': agentModel.nom,
          '2': agentModel.postNom,
          '3': agentModel.prenom,
          '4': agentModel.email,
          '5': agentModel.telephone,
          '6': agentModel.adresse,
          '7': agentModel.sexe,
          '8': agentModel.role,
          '9': agentModel.matricule,
          '10': agentModel.dateNaissance,
          '11': agentModel.lieuNaissance,
          '12': agentModel.nationalite,
          '13': agentModel.typeContrat,
          '14': agentModel.departement,
          '15': agentModel.servicesAffectation,
          '16': agentModel.dateDebutContrat,
          '17': agentModel.dateFinContrat,
          '18': agentModel.fonctionOccupe,
          '19': agentModel.detailPersonnel,
          '20': agentModel.statutAgent,
          '21': agentModel.createdAt,
          '22': agentModel.photo,
          '23': agentModel.salaire,
          '24': agentModel.signature,
          '25': agentModel.created,
          '26': agentModel.isDelete,
          '27': agentModel.business,
          '28': agentModel.sync,
          '29': agentModel.async,
          '30': agentModel.id 
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

  Future<AgentModel> getFromId(int id) async {
    var data =
        await executor.query("SELECT * FROM  $tableName WHERE \"id\" = '$id'");
    return AgentModel(
        id: data[0][0],
        nom: data[0][1],
        postNom: data[0][2],
        prenom: data[0][3],
        email: data[0][4],
        telephone: data[0][5],
        adresse: data[0][6],
        sexe: data[0][7],
        role: data[0][8],
        matricule: data[0][9],
        dateNaissance: data[0][10],
        nationalite: data[0][11],
        lieuNaissance: data[0][12],
        typeContrat: data[0][13],
        departement: data[0][14],
        servicesAffectation: data[0][15],
        dateDebutContrat: data[0][16],
        dateFinContrat: data[0][17],
        fonctionOccupe: data[0][18],
        detailPersonnel: data[0][19],
        statutAgent: data[0][20],
        createdAt: data[0][21],
        photo: data[0][22],
        salaire: data[0][23],
        signature: data[0][24],
        created: data[0][25],
        isDelete: data[0][26],
        business: data[0][27],
      sync: data[0][28],
      async: data[0][29],
      );
  }


  
}

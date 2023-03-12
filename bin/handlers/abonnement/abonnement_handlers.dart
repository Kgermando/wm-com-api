import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
 
import '../../models/abonnement/abonnement_model.dart';
import '../../repository/repository.dart';

class AbonnementHandlers {
  final Repository repos;

  AbonnementHandlers(this.repos);

  Router get router {
    final router = Router();

    router.get('/', (Request request) async {
      List<AbonnementModel> data = await repos.abonnements.getAllData();
      return Response.ok(jsonEncode(data));
    });

    router.get('/<id>', (Request request, String id) async {
      late AbonnementModel data;
      try {
        data = await repos.abonnements.getFromId(int.parse(id));
      } catch (e) {
        print(e);
        return Response(404);
      }
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.post('/insert-new-abonnement', (Request request) async {
      var input = jsonDecode(await request.readAsString());

      AbonnementModel data = AbonnementModel(
        statut: input['statut'],
        dateAbonnement: DateTime.parse(input['dateAbonnement']),
        dateEcheance: DateTime.parse(input['dateEcheance']),
        refCode: input['refCode'],
        moyen: input['moyen'],
        business: input['business'],
        signature: input['signature'],
        created: DateTime.parse(input['created']), 
      );
      try {
        await repos.abonnements.insertData(data);
      } catch (e) {
        print(e);
        return Response(422);
      }
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.put('/update-abonnement/', (Request request) async {
       dynamic input = jsonDecode(await request.readAsString());
      final editH = AbonnementModel.fromJson(input);
      AbonnementModel? data =
          await repos.abonnements.getFromId(editH.id!); 

      if (input['statut'] != null) {
        data.statut = input['statut'];
      }
      if (input['dateAbonnement'] != null) {
        data.dateAbonnement = DateTime.parse(input['dateAbonnement']);
      } 
      if (input['dateEcheance'] != null) {
        data.dateEcheance = DateTime.parse(input['dateEcheance']);
      } 
      if (input['refCode'] != null) {
        data.refCode = input['refCode'];
      }
      if (input['moyen'] != null) {
        data.moyen = input['moyen'];
      }
      if (input['business'] != null) {
        data.business = input['business'];
      }
      if (input['signature'] != null) {
        data.signature = input['signature'];
      }
      if (input['created'] != null) {
        data.created = DateTime.parse(input['created']);
      } 

      repos.abonnements.update(data);
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.delete('/delete-abonnement/<id>', (Request request, String id) async {
      var id = request.params['id'];
      repos.abonnements.deleteData(int.parse(id!));
      return Response.ok('Supprimée');
    });

    router.all(
      '/<ignored|.*>',
      (Request request) =>
          Response.notFound('La Page abonnements n\'est pas trouvé'),
    );

    return router;
  }
}

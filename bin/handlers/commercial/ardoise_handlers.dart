import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../models/commercial/ardoise_model.dart';
import '../../repository/repository.dart';

class ArdoiseHandlers {
  final Repository repos;

  ArdoiseHandlers(this.repos);

  Router get router {
    final router = Router();

    router.get('/<business>', (Request request, String business) async {
      List<ArdoiseModel> data = await repos.ardoises.getAllData(business);
      return Response.ok(jsonEncode(data));
    });

    router.get('/<id>', (Request request, String id) async {
      late ArdoiseModel data;
      try {
        data = await repos.ardoises.getFromId(int.parse(id));
      } catch (e) {
        print(e);
        return Response(404);
      }
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.post('/insert-new-ardoise', (Request request) async {
      var input = jsonDecode(await request.readAsString());
      ArdoiseModel data = ArdoiseModel(
        ardoise: input['ardoise'],
        ardoiseJson: input['ardoiseJson'],
        statut: input['statut'],
        succursale: input['succursale'],
        signature: input['signature'],
        created: DateTime.parse(input['created']),
        business: input['business'],
      ); 
      try {
        await repos.ardoises.insertData(data);
      } catch (e) {
        print(e);
        return Response(422);
      }
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.put('/update-ardoise/', (Request request) async {
      dynamic input = jsonDecode(await request.readAsString());
      final editH = ArdoiseModel.fromJson(input);
      ArdoiseModel? data = await repos.ardoises.getFromId(editH.id!);

      if (input['ardoise'] != null) {
        data.ardoise = input['ardoise'];
      }
      if (input['ardoiseJson'] != null) {
        data.ardoiseJson = input['ardoiseJson'];
      }
      if (input['statut'] != null) {
        data.statut = input['statut'];
      }
      if (input['succursale'] != null) {
        data.succursale = input['succursale'];
      }
      if (input['signature'] != null) {
        data.signature = input['signature'];
      }
      if (input['created'] != null) {
        data.created = DateTime.parse(input['created']);
      }
      if (input['business'] != null) {
        data.business = input['business'];
      }
      repos.ardoises.update(data);
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.delete('/delete-ardoise/<id>', (Request request, String id) async {
      var id = request.params['id'];
      repos.ardoises.deleteData(int.parse(id!));
      return Response.ok('Supprimée');
    });

    router.all(
      '/<ignored|.*>',
      (Request request) =>
          Response.notFound('La Page ardoises n\'est pas trouvé'),
    );

    return router;
  }
}

import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart'; 
import '../../models/restaurant/facture_restaurant_model.dart';
import '../../repository/repository.dart';

class FactureTerrasseHandlers {
  final Repository repos;

  FactureTerrasseHandlers(this.repos);

  Router get router {
    final router = Router();

    router.get('/<business>/', (Request request, String business) async {
      List<FactureRestaurantModel> data = await repos.factureTerrasses.getAllData(business);
      return Response.ok(jsonEncode(data));
    });

    router.get('/<id>', (Request request, String id) async {
      late FactureRestaurantModel data;
      try {
        data = await repos.factureTerrasses.getFromId(int.parse(id));
      } catch (e) {
        print(e);
        return Response(404);
      }
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.post('/insert-new-facture', (Request request) async {
      var input = jsonDecode(await request.readAsString());

      FactureRestaurantModel data = FactureRestaurantModel(
          cart: input['cart'],
          client: input['client'],
          nomClient: input['nomClient'],
          telephone: input['telephone'],
          succursale: input['succursale'],
          signature: input['signature'],
          created: DateTime.parse(input['created']),
        business: input['business'],
        sync: input['sync'],
        async: input['async'],
      );
      try {
        await repos.factureTerrasses.insertData(data);
      } catch (e) {
        print(e);
        return Response(422);
      }
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.put('/update-facture/', (Request request) async {
       dynamic input = jsonDecode(await request.readAsString());
      final editH = FactureRestaurantModel.fromJson(input);
      FactureRestaurantModel? data =
          await repos.factureTerrasses.getFromId(editH.id!); 

      if (input['cart'] != null) {
        data.cart = input['cart'];
      }
      if (input['client'] != null) {
        data.client = input['client'];
      }
      if (input['nomClient'] != null) {
        data.nomClient = input['nomClient'];
      }
      if (input['telephone'] != null) {
        data.telephone = input['telephone'];
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
      if (input['sync'] != null) {
        data.sync = input['sync'];
      }
      if (input['async'] != null) {
        data.async = input['async'];
      }

      repos.factureTerrasses.update(data);
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.delete('/delete-facture/<id>', (Request request, String id) async {
      var id = request.params['id'];
      repos.factureTerrasses.deleteData(int.parse(id!));
      return Response.ok('Supprimée');
    });

    router.all(
      '/<ignored|.*>',
      (Request request) =>
          Response.notFound('La Page facture terrasses n\'est pas trouvé'),
    );

    return router;
  }
}

import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
 
import '../../models/restaurant/courbe_vente_gain_restaurant_model.dart';
import '../../models/restaurant/vente_chart_restaurant_model.dart';
import '../../models/restaurant/vente_restaurant_model.dart';
import '../../repository/repository.dart';

class VenteEffectueeLivraisonHandlers {
  final Repository repos;

  VenteEffectueeLivraisonHandlers(this.repos);

  Router get router {
    final router = Router();

    router.get('/<business>/', (Request request, String business) async {
      List<VenteRestaurantModel> data = await repos.venteEffectueeLivraisons.getAllData(business);
      return Response.ok(jsonEncode(data));
    });

    router.get('/<id>', (Request request, String id) async {
      late VenteRestaurantModel data;
      try {
        data = await repos.venteEffectueeLivraisons.getFromId(int.parse(id));
      } catch (e) {
        print(e);
        return Response(404);
      }
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.get('/vente-chart/<business>', (Request request, String business) async {
      List<VenteChartRestaurantModel> data = await repos.venteEffectueeLivraisons.getAllDataChart(business);
      return Response.ok(jsonEncode(data));
    });

    router.get('/vente-chart-day/<business>', (Request request, String business) async {
      List<CourbeVenteRestaurantModel> data = await repos.venteEffectueeLivraisons.getAllDataChartDay(business);
      return Response.ok(jsonEncode(data));
    });

    router.get('/vente-chart-month/<business>', (Request request, String business) async {
      List<CourbeVenteRestaurantModel> data = await repos.venteEffectueeLivraisons.getAllDataChartMounth(business);
      return Response.ok(jsonEncode(data));
    });

    router.get('/vente-chart-year/<business>', (Request request, String business) async {
      List<CourbeVenteRestaurantModel> data = await repos.venteEffectueeLivraisons.getAllDataChartYear(business);
      return Response.ok(jsonEncode(data));
    });

    router.post('/insert-new-vente', (Request request) async {
      var input = jsonDecode(await request.readAsString());
      VenteRestaurantModel data = VenteRestaurantModel(
        identifiant: input['identifiant'],
        table: input['table'],
        priceTotalCart: input['priceTotalCart'],
        qty: input['qty'],
        price: input['price'],
        unite: input['unite'], 
        succursale: input['succursale'],
        signature: input['signature'],
        created: DateTime.parse(input['created']), 
        business: input['business'],
        sync: input['sync'],
        async: input['async'],
      );
      try {
        await repos.venteEffectueeLivraisons.insertData(data);
      } catch (e) {
        print(e);
        return Response(422);
      }
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.put('/update-vente/', (Request request) async {
      dynamic input = jsonDecode(await request.readAsString());
      final editH = VenteRestaurantModel.fromJson(input);
      VenteRestaurantModel? data =
          await repos.venteEffectueeLivraisons.getFromId(editH.id!); 

      if (input['identifiant'] != null) {
        data.identifiant = input['identifiant'];
      }
      if (input['table'] != null) {
        data.table = input['table'];
      }
      if (input['priceTotalCart'] != null) {
        data.priceTotalCart = input['priceTotalCart'];
      }
      if (input['qty'] != null) {
        data.qty = input['qty'];
      }
      if (input['price'] != null) {
        data.price = input['price'];
      }
      if (input['unite'] != null) {
        data.unite = input['unite'];
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
      repos.venteEffectueeLivraisons.update(data);
      return Response.ok(jsonEncode(data.toJson()));
    });

    router.delete('/delete-vente/<id>', (Request request, String id) async {
      var id = request.params['id'];
      repos.venteEffectueeLivraisons.deleteData(int.parse(id!));
      return Response.ok('Supprimée');
    });

    router.all(
      '/<ignored|.*>',
      (Request request) =>
          Response.notFound('La Page venteEffectueeLivraisons n\'est pas trouvé'),
    );

    return router;
  }
}

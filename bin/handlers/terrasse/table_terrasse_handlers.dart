import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
   
import '../../models/restaurant/table_restaurant_model.dart';
import '../../repository/repository.dart';

class TableTerrasseHandlers {
  final Repository repos;

  TableTerrasseHandlers(this.repos);

  Router get router {
    final router = Router();

    router.get('/<business>/', (Request request, String business) async {
      List<TableRestaurantModel> data = await repos.tableTerrasses.getAllData(business);
      return Response.ok(jsonEncode(data));
    });
 
    router.get('/<id>', (Request request, String id) async {
      late TableRestaurantModel dataItem;
      try {
        dataItem = await repos.tableTerrasses.getFromId(int.parse(id));
      } catch (e) {
        print(e);
        return Response(404);
      }
      return Response.ok(jsonEncode(dataItem.toJson()));
    });

    router.post('/insert-new-table', (Request request) async {
      var input = jsonDecode(await request.readAsString());
      TableRestaurantModel dataItem = TableRestaurantModel(
        table: input['table'],
        part: input['part'], 
        succursale: input['succursale'],
        signature: input['signature'],
        created: DateTime.parse(input['created']), 
        business: input['business'],
        sync: input['sync'],
        async: input['async'],
      );

      try {
        await repos.tableTerrasses.insertData(dataItem);
      } catch (e) {
        print(e);
        return Response(422);
      }
      return Response.ok(jsonEncode(dataItem.toJson()));
    });

    router.put('/update-table/', (Request request) async {
      dynamic input = jsonDecode(await request.readAsString());
      final editH = TableRestaurantModel.fromJson(input);
      TableRestaurantModel? dataItem = await repos.tableTerrasses.getFromId(editH.id!); 
      if (input['table'] != null) {
        dataItem.table = input['table'];
      }
      if (input['part'] != null) {
        dataItem.part = input['part'];
      }
      if (input['succursale'] != null) {
        dataItem.succursale = input['succursale'];
      }
      if (input['signature'] != null) {
        dataItem.signature = input['signature'];
      }
      if (input['created'] != null) {
        dataItem.created = DateTime.parse(input['created']);
      } 
      if (input['business'] != null) {
        dataItem.business = input['business'];
      }
      if (input['sync'] != null) {
        dataItem.sync = input['sync'];
      }
      if (input['async'] != null) {
        dataItem.async = input['async'];
      }

      repos.tableTerrasses.update(dataItem);
      return Response.ok(jsonEncode(dataItem.toJson()));
    });

    router.delete('/delete-table/<id>', (Request request, String id) async {
      var id = request.params['id'];
      repos.tableLivraisons.deleteData(int.parse(id!));
      return Response.ok('Supprimée');
    });

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound('La Page terrasses n\'est pas trouvé'),
    );

    return router;
  }
}

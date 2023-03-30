import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
 
import '../../models/reservation/reservation_model.dart';
import '../../models/rh/agent_count_model.dart';
import '../../repository/repository.dart';

class ReservationHandlers {
  final Repository repos;

  ReservationHandlers(this.repos);

  Router get router {
    final router = Router();

    router.get('/<business>/', (Request request, String business) async {
      List<ReservationModel> data = await repos.reservationRepository.getAllData(business);
      return Response.ok(jsonEncode(data));
    });

    router.get('/chart-pie/<business>/', (Request request, String business) async {
      List<ReservationPieChartModel> data = await repos.reservationRepository.getChartPie(business);
      return Response.ok(jsonEncode(data));
    });
 
    router.get('/<id>', (Request request, String id) async {
      late ReservationModel dataItem;
      try {
        dataItem = await repos.reservationRepository.getFromId(int.parse(id));
      } catch (e) {
        print(e);
        return Response(404);
      }
      return Response.ok(jsonEncode(dataItem.toJson()));
    });

    router.post('/insert-new-reservation', (Request request) async {
      var input = jsonDecode(await request.readAsString());
      ReservationModel dataItem = ReservationModel(
          client: input['client'],
          telephone: input['telephone'],
          email: input['email'],
          adresse: input['adresse'],
          nbrePersonne: input['nbrePersonne'],
          dureeEvent: input['dureeEvent'],
          createdDay: DateTime.parse(input['createdDay']),
          background: input['background'],
          eventName: input['eventName'],
          signature: input['signature'],
          created: DateTime.parse(input['created']),
        montant: input['montant'],
        business: input['business'],
        sync: input['sync'],
        async: input['async'],
      );

      try {
        await repos.reservationRepository.insertData(dataItem);
      } catch (e) {
        print(e);
        return Response(422);
      }
      return Response.ok(jsonEncode(dataItem.toJson()));
    });

    router.put('/update-reservation/', (Request request) async {
      dynamic input = jsonDecode(await request.readAsString());
      final editH = ReservationModel.fromJson(input);
      ReservationModel? dataItem = await repos.reservationRepository.getFromId(editH.id!);

      if (input['client'] != null) {
        dataItem.client = input['client'];
      }
      if (input['telephone'] != null) {
        dataItem.telephone = input['telephone'];
      }
      if (input['email'] != null) {
        dataItem.email = input['email'];
      }
      if (input['adresse'] != null) {
        dataItem.adresse = input['adresse'];
      }
      if (input['nbrePersonne'] != null) {
        dataItem.nbrePersonne = input['nbrePersonne'];
      }
      if (input['dureeEvent'] != null) {
        dataItem.dureeEvent = input['dureeEvent'];
      }
      if (input['createdDay'] != null) {
        dataItem.createdDay = DateTime.parse(input['createdDay']);
      }
      if (input['background'] != null) {
        dataItem.background = input['background'];
      }
      if (input['eventName'] != null) {
        dataItem.eventName = input['eventName'];
      }
      if (input['signature'] != null) {
        dataItem.signature = input['signature'];
      }
      if (input['created'] != null) {
        dataItem.created = DateTime.parse(input['created']);
      }
      if (input['montant'] != null) {
        dataItem.montant = input['montant'];
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

      repos.reservationRepository.update(dataItem);
      return Response.ok(jsonEncode(dataItem.toJson()));
    });

    router.delete('/delete-reservation/<id>', (Request request, String id) async {
      var id = request.params['id'];
      repos.tableLivraisons.deleteData(int.parse(id!));
      return Response.ok('Supprimée');
    });

 

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound('La Page Reservation n\'est pas trouvé'),
    );

    return router;
  }
}

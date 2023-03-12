import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
 
import '../../models/reservation/paiement_reservation_model.dart';
import '../../repository/repository.dart';

class PaiementReservationHandlers {
  final Repository repos;

  PaiementReservationHandlers(this.repos);

  Router get router {
    final router = Router();

    router.get('/<business>', (Request request, String business) async {
      List<PaiementReservationModel> data =
          await repos.paiementReservationRepository.getAllData(business);
      return Response.ok(jsonEncode(data));
    });

    router.get('/<id>', (Request request, String id) async {
      late PaiementReservationModel dataItem;
      try {
        dataItem = await repos.paiementReservationRepository.getFromId(int.parse(id));
      } catch (e) {
        print(e);
        return Response(404);
      }
      return Response.ok(jsonEncode(dataItem.toJson()));
    });

    router.post('/insert-new-reservation-paiement', (Request request) async {
      var input = jsonDecode(await request.readAsString());
      PaiementReservationModel agent = PaiementReservationModel(
          reference: input['reference'],
          client: input['client'],
          motif: input['motif'],
          montant: input['montant'], 
          signature: input['signature'],
          created: DateTime.parse(input['created']),
        business: input['business'],
      );

      try {
        await repos.paiementReservationRepository.insertData(agent);
      } catch (e) {
        print(e);
        return Response(422);
      }
      return Response.ok(jsonEncode(agent.toJson()));
    });

    router.put('/update-reservation-paiement/', (Request request) async {
      dynamic input = jsonDecode(await request.readAsString());
      final editH = PaiementReservationModel.fromJson(input);
      PaiementReservationModel? dataItem =
          await repos.paiementReservationRepository.getFromId(editH.id!);

      if (input['reference'] != null) {
        dataItem.reference = input['reference'];
      }
      if (input['client'] != null) {
        dataItem.client = input['client'];
      }
      if (input['motif'] != null) {
        dataItem.motif = input['motif'];
      }
      if (input['montant'] != null) {
        dataItem.montant = input['montant'];
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

      repos.paiementReservationRepository.update(dataItem);
      return Response.ok(jsonEncode(dataItem.toJson()));
    });

    router.delete('/delete-reservation-paiement/<id>',
        (Request request, String id) async {
      var id = request.params['id'];
      repos.agents.deleteData(int.parse(id!));
      return Response.ok('Supprimée');
    });

    router.all(
      '/<ignored|.*>',
      (Request request) =>
          Response.notFound('La Page Reservation paiement n\'est pas trouvé'),
    );

    return router;
  }
}

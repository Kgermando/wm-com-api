import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../models/notify/notify_model.dart';
import '../../../repository/repository.dart';

class AgendaNotifyHandlers {
  final Repository repos;

  AgendaNotifyHandlers(this.repos);

  Router get router {
    final router = Router();

    router.get('/get-count/<business>/<matricule>',
        (Request request, String business, String matricule) async {
      NotifyModel data = await repos.agendaCount.getCount(business, matricule);
      return Response.ok(jsonEncode(data));
    }); 

    router.all(
      '/<ignored|.*>',
      (Request request) =>
          Response.notFound('La Page Agenda count n\'est pas trouvé'),
    );
    return router;
  }
}


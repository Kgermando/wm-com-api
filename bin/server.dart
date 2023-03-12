import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'db/config_db.dart'; 
 
import 'handlers/abonnement/abonnement_handlers.dart';
import 'handlers/archives/archive_folder_handlers.dart';
import 'handlers/archives/archive_handlers.dart';
import 'handlers/auth/auth_handlers.dart';
import 'handlers/auth/user_handlers.dart';
import 'handlers/commercial/achats_handlers.dart';
import 'handlers/commercial/ardoise_handlers.dart'; 
import 'handlers/commercial/bon_livraison_handlers.dart';
import 'handlers/commercial/cart_handlers.dart';
import 'handlers/commercial/creance_facture_handlers.dart';
import 'handlers/commercial/facture_handlers.dart';
import 'handlers/commercial/gains_handlers.dart';
import 'handlers/commercial/history_livraison_handlers.dart';
import 'handlers/commercial/history_ravitaillement_handlers.dart';
import 'handlers/commercial/number_fact_handlers.dart';
import 'handlers/commercial/produit_model_handlers.dart';
import 'handlers/commercial/restitution_handlers.dart';
import 'handlers/commercial/stocks_global_handlers.dart';
import 'handlers/commercial/succursale_handlers.dart';
import 'handlers/commercial/ventes_handlers.dart';
import 'handlers/finances/caisse_names_handlers.dart';
import 'handlers/finances/caisses_handlers.dart';
import 'handlers/mails/mails_handlers.dart';
import 'handlers/marketing/agenda_handlers.dart';
import 'handlers/marketing/annuaire_handlers.dart';
import 'handlers/notify/commercial/cart_notify_handlers.dart';
import 'handlers/notify/mails/mails_notify_handlers.dart';
import 'handlers/notify/marketing/agenda_notify_handlers.dart';
import 'handlers/reservation/paiement_reservation_handlers.dart';
import 'handlers/reservation/reservation_handlers.dart';
import 'handlers/rh/agents_handlers.dart';
import 'handlers/settings/monnaie_handlers.dart';
import 'handlers/update/upate_handlers.dart';
import 'middleware/middleware.dart';
import 'repository/repository.dart';

// Configure routes.
class Service {
  final Repository repos;
  final String serverSecretKey;

  Service(this.repos, this.serverSecretKey);

  Handler get handlers {
    final router = Router();
  
  // ABONNEMENTS
    router.mount(
        '/api/abonnements/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            .addHandler(AbonnementHandlers(repos).router));

    // NOTIFY
    router.mount(
        '/api/counts/agendas/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            .addHandler(AgendaNotifyHandlers(repos).router));
    router.mount(
        '/api/counts/carts/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            .addHandler(CartNotifyHandlers(repos).router)); 
    router.mount(
        '/api/counts/mails/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            .addHandler(MailsNotifyHandlers(repos).router));

    // AUTH
    router.mount(
        '/api/auth/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            .addHandler(AuthHandlers(repos, serverSecretKey).router));
    router.mount(
        '/api/user/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(UserHandlers(repos).router));
 

    // RH
    router.mount(
        '/api/rh/agents/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(AgentsHandlers(repos).router));


    // COMMERCIAL
     router.mount(
        '/api/stocks-global/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(StockGlobalHandlers(repos).router));
    router.mount(
        '/api/succursales/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(SuccursaleHandlers(repos).router));
    router.mount(
        '/api/bon-livraisons/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(BonLivraisonHandlers(repos).router));
     router.mount(
        '/api/restitutions/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(RestitutionHandlers(repos).router));
    router.mount(
        '/api/history-livraisons/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(HistoryLivraisonHandlers(repos).router));
    router.mount(
        '/api/produit-models/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(ProduitModelHandlers(repos).router)); 
    router.mount(
        '/api/achats/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(AchatsHandlers(repos).router));
    router.mount(
        '/api/carts/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(CartHandlers(repos).router));
    router.mount(
        '/api/factures/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(FactureHandlers(repos).router));
    router.mount(
        '/api/facture-creances/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(CreanceFactureHandlers(repos).router));
    router.mount(
        '/api/ventes/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(VenteHandlers(repos).router));
    router.mount(
        '/api/gains/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(GainsHandlers(repos).router)); 
    router.mount(
        '/api/history-ravitaillements/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(HistoryRavitaillementHandlers(repos).router)); 
    router.mount(
        '/api/number-facts/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(NumberFactHandlers(repos).router));
    router.mount(
        '/api/ardoises/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(ArdoiseHandlers(repos).router));

    // MARKETING
    router.mount(
        '/api/agendas/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(AgendaHandlers(repos).router));
    router.mount(
        '/api/annuaires/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(AnnuaireHandlers(repos).router)); 

    // RESERVATION
    router.mount(
        '/api/reservations/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(ReservationHandlers(repos).router));
    router.mount(
        '/api/reservations-paiements/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(PaiementReservationHandlers(repos).router));

    // FINANCE
     router.mount(
        '/api/finances/transactions/caisses-name/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(CaisseNameHandlers(repos).router)); 
    router.mount(
        '/api/finances/transactions/caisses/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(CaissesHandlers(repos).router));

    // ARCHIVE
    router.mount(
        '/api/archives/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(ArchiveHandlers(repos).router));
    router.mount(
        '/api/archives-folders/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(ArchiveFolderHandlers(repos).router));

    // MAILLING
    router.mount(
        '/api/mails/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(MailsHandlers(repos).router));

    // UPDATE
    router.mount(
        '/api/update-versions/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(UpdateHandlers(repos).router));
 

    // Settings
    router.mount(
        '/api/settings/monnaies/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(MonnaieHandlers(repos).router));

    router.all(
      '/<ignored|.*>',
      (Request request) => Response.notFound(null),
    );
    return router;
  }
}

void main(List<String> args) async {
  final ip = "app";
  final port = 80;

  PostgreSQLConnection connection = await ConnexionDatabase().connection();
  print("Database it's work...");

  await connection.open();
  Repository repos = Repository(connection);
  Service service = Service(repos, "work_management_Key");

  final server = await shelf_io.serve(service.handlers, ip, port);

  print('Server listening on port ${server.port}');
}

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
import 'handlers/livraison/creance_livraison_handlers.dart';
import 'handlers/livraison/facture_livraison_handlers.dart';
import 'handlers/livraison/livraison_handlers.dart';
import 'handlers/livraison/prod_model_livraison_handlers.dart';
import 'handlers/livraison/table_livraison_handlers.dart';
import 'handlers/livraison/vente_effectuee_livraison_handlers.dart';
import 'handlers/mails/mails_handlers.dart';
import 'handlers/marketing/agenda_handlers.dart';
import 'handlers/marketing/annuaire_handlers.dart';
import 'handlers/notify/commercial/cart_notify_handlers.dart';
import 'handlers/notify/mails/mails_notify_handlers.dart';
import 'handlers/notify/marketing/agenda_notify_handlers.dart';
import 'handlers/reservation/paiement_reservation_handlers.dart';
import 'handlers/reservation/reservation_handlers.dart';
import 'handlers/restaurant/creance_rest_handlers.dart';
import 'handlers/restaurant/facture_rest_handlers.dart';
import 'handlers/restaurant/prod_model_rest_handlers.dart';
import 'handlers/restaurant/restaurant_handlers.dart';
import 'handlers/restaurant/table_restaurant_handlers.dart';
import 'handlers/restaurant/vente_effectuee_rest_handlers.dart';
import 'handlers/rh/agents_handlers.dart';
import 'handlers/settings/monnaie_handlers.dart';
import 'handlers/terrasse/creance_terrasse_handlers.dart';
import 'handlers/terrasse/facture_terrasse_handlers.dart';
import 'handlers/terrasse/prod_model_terrasse_handlers.dart';
import 'handlers/terrasse/table_terrasse_handlers.dart';
import 'handlers/terrasse/terrasse_handlers.dart';
import 'handlers/terrasse/vente_effectuee_terrasse_handlers.dart';
import 'handlers/update/upate_handlers.dart';
import 'handlers/vip/creance_vip_handlers.dart';
import 'handlers/vip/facture_vip_handlers.dart';
import 'handlers/vip/prod_model_vip_handlers.dart';
import 'handlers/vip/table_vip_handlers.dart';
import 'handlers/vip/vente_effectuee_vip_handlers.dart';
import 'handlers/vip/vip_handlers.dart';
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

    // Restaurant
    router.mount(
        '/api/prod-mode-rests/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(ProdModelRestHandlers(repos).router));
    router.mount(
        '/api/restaurants/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(RestaurantHandlers(repos).router));
    router.mount(
        '/api/creance-rests/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(CreanceRestHandlers(repos).router));
    router.mount(
        '/api/facture-rests/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(FactureRestHandlers(repos).router));
    router.mount(
        '/api/table-rests/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(TableRestaurantHandlers(repos).router));
    router.mount(
        '/api/vente-effectuee-rests/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(VenteEffectueeRestHandlers(repos).router));

    // VIP
    router.mount(
        '/api/prod-mode-vips/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(ProdModelVipHandlers(repos).router));
    router.mount(
        '/api/vips/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(VipHandlers(repos).router));
    router.mount(
        '/api/creance-vips/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(CreanceVipHandlers(repos).router));
    router.mount(
        '/api/facture-vips/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(FactureVipHandlers(repos).router));
    router.mount(
        '/api/table-vips/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(TableVipHandlers(repos).router));
    router.mount(
        '/api/vente-effectuee-vips/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(VenteEffectueeVipHandlers(repos).router));

    // Terrasse
    router.mount(
        '/api/prod-mode-terrasses/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(ProdModelTerrasseHandlers(repos).router));
    router.mount(
        '/api/terrasses/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(TerrasseHandlers(repos).router));
    router.mount(
        '/api/creance-terrasses/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(CreanceTerrasseHandlers(repos).router));
    router.mount(
        '/api/facture-terrasses/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(FactureTerrasseHandlers(repos).router));
    router.mount(
        '/api/table-terrasses/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(TableTerrasseHandlers(repos).router));
    router.mount(
        '/api/vente-effectuee-terrasses/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(VenteEffectueeTerrasseHandlers(repos).router));
    // Livraison
    router.mount(
        '/api/prod-mode-livraisons/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(ProdModelLivraisonHandlers(repos).router));
    router.mount(
        '/api/livraisons/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(LivraisonHandlers(repos).router));
    router.mount(
        '/api/creance-livraisons/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(CreanceLivraisonHandlers(repos).router));
    router.mount(
        '/api/facture-livraisons/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(FactureLivraisonHandlers(repos).router));
    router.mount(
        '/api/table-livraisons/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(TableLivraisonHandlers(repos).router));
    router.mount(
        '/api/vente-effectuee-livraisons/',
        Pipeline()
            .addMiddleware(setJsonHeader())
            .addMiddleware(handleErrors())
            // .addMiddleware(handleAuth(serverSecretKey))
            .addHandler(VenteEffectueeLivraisonHandlers(repos).router));

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

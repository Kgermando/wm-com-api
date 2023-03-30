import 'package:postgres/postgres.dart';

import 'abonnement/abonnement_repository.dart';
import 'archives/archive_folder_repository.dart';
import 'archives/archive_repository.dart';
import 'commercial/achats_repository.dart'; 
import 'commercial/bon_livraison_repository.dart';
import 'commercial/cart_repository.dart';
import 'commercial/creance_cart_repository.dart';
import 'commercial/facture_cart_repository.dart';
import 'commercial/gain_repository.dart';
import 'commercial/history_livraison_repository.dart';
import 'commercial/history_ravitraillement_repository.dart';
import 'commercial/number_facture_repository.dart';
import 'commercial/produit_model_repository.dart';
import 'commercial/restitution_repository.dart';
import 'commercial/stocks_global_repository.dart';
import 'commercial/succursale_repository.dart';
import 'commercial/vente_repository.dart';
import 'finance/caisse_name_repository.dart';
import 'finance/caissses_repository.dart';
import 'livraison/creance_livraison_repository.dart';
import 'livraison/facture_livraison_repository.dart';
import 'livraison/livraison_repository.dart';
import 'livraison/prod_model_livraison_repository.dart';
import 'livraison/table_livraison_repository.dart';
import 'livraison/vente_effectuee_livraison_repository.dart';
import 'mails/mail_repository.dart';
import 'marketing/agenda_repository.dart';
import 'marketing/annuaire_repository.dart';
import 'notify/commercial/cart_notify_repository.dart';
import 'notify/mails/mails_notify_repository.dart';
import 'notify/marketing/agenda_notify_repository.dart';
import 'reservation/paiement_reservation_repository.dart';
import 'reservation/reservation_repository.dart';
import 'restaurant/creance_rest_repository.dart';
import 'restaurant/facture_rest_repository.dart';
import 'restaurant/prod_model_rest_repository.dart';
import 'restaurant/restaurant_repository.dart';
import 'restaurant/table_rest_repository.dart';
import 'restaurant/vente_effectuee_rest_repository.dart';
import 'rh/agents_repository.dart';

import 'settings/monnaie_repository.dart';
import 'terrasse/creance_terrasse_repository.dart';
import 'terrasse/facture_terrasse_repository.dart';
import 'terrasse/prod_model_terrasse_repository.dart';
import 'terrasse/table_terrasse_repository.dart';
import 'terrasse/terrasse_repository.dart';
import 'terrasse/vente_effectuee_terrasse_repository.dart';
import 'update/update_version_repository.dart';
import 'user/refresh_token_repository.dart';
import 'user/user_repository.dart';
import 'vip/creance_vip_repository.dart';
import 'vip/facture_vip_repository.dart';
import 'vip/prod_model_vip_repository.dart';
import 'vip/table_vip_repository.dart';
import 'vip/vente_effectuee_vip_repository.dart';
import 'vip/vip_repository.dart';

class Repository {
  final PostgreSQLConnection executor;
  late RefreshTokensRepository refreshTokens;
  late UserRepository users;

  // Settings
  late MonnaieRepository monnaies;

  // ABONNEMENT
  late AbonnementRepository abonnements;

  // RH
  late AgentsRepository agents;

  // COMMERCIAL
  late ProduitModelRepository produitModel;
  late AchatsRepository achats;
  late CartRepository carts;
  late FactureRepository factures;
  late CreanceFactureRepository creancesFacture;
  late NumberFactureRepository numberFacture;
  late VenteRepository ventes;
  late GainRepository gains;
  late HistoryRavitaillementRepository historyRavitaillements; 
  late StockGlobalRepository stocksGlobal;
  late SuccursaleRepository succursales;
  late BonLivraisonRepository bonLivraison;
  late RestitutionRepository restitutions;
  late HistoryLivraisonRepository historyLivraisons;

  // RESTAURANT
  late ProdModelRestRepository prodRestModels;
  late CreanceRestRepository creanceRests;
  late FactureRestRepository factureRests;
  late RestaurantRepository restaurants;
  late TableRestRepository tableRests;
  late VenteEffectueeRestRepository venteEffectueeRests;

  // VIP
  late ProdModelVipRepository prodVipModels;
  late CreanceVipRepository creanceVips;
  late FactureVipRepository factureVips;
  late VipRepository vips;
  late TableVipRepository tableVips;
  late VenteEffectueeVipRepository venteEffectueeVips;

  // TERRASSE
  late ProdModelTerrasseRepository prodTerrasseModels;
  late CreanceTerrasseRepository creanceTerrasses;
  late FactureTerrasseRepository factureTerrasses;
  late TerrasseRepository terrasses;
  late TableTerrasseRepository tableTerrasses;
  late VenteEffectueeTerrasseRepository venteEffectueeTerrasses;
 
  // LIVRAISON
  late ProdModelLivraisonRepository prodLivraisonModels;
  late CreanceLivraisonRepository creanceLivraisons;
  late FactureLivraisonRepository factureLivraisons;
  late LivraisonRepository livraisons;
  late TableLivraisonRepository tableLivraisons;
  late VenteEffectueeLivraisonRepository venteEffectueeLivraisons;

  // Marketing
  late AgendaRepository agendas;
  late AnnuaireReposiotry annuaires;

  // Archive
  late ArchiveRepository archives;
  late ArchiveFolderRepository archivesFolders;

  // Mails
  late MailRepository mails;
  // Update version
  late UpdateVersionRepository updateVersion;

  // Notify Count
  late AgendaNotifyRepository agendaCount;
  late CartNotifyRepository cartCount;
  late MailsNotifyRepository mailsNotifyCount;

  // Reservation
  late ReservationRepository reservationRepository;
  late PaiementReservationRepository paiementReservationRepository;

  // Finance
  late CaisseNameRepository caisseNames;
  late CaissesRepository caisses;

  Repository(this.executor) {
    // NOTIFICATION
    agendaCount = AgendaNotifyRepository(executor, 'agendas');
    cartCount = CartNotifyRepository(executor, 'carts');
    mailsNotifyCount = MailsNotifyRepository(executor, 'mails');

    // Settings
    monnaies = MonnaieRepository(executor, 'monnaies');

    // AUTH
    refreshTokens = RefreshTokensRepository(executor, 'refresh_tokens');
    users = UserRepository(executor, 'users');

    // ABONNEMENT
    abonnements = AbonnementRepository(executor, 'abonnements');

    // RH
    agents = AgentsRepository(executor, 'agents');

    // COMMERCIAL
    produitModel = ProduitModelRepository(executor, 'produits_model');
    achats = AchatsRepository(executor, 'achats');
    carts = CartRepository(executor, 'carts');
    factures = FactureRepository(executor, 'factures');
    creancesFacture = CreanceFactureRepository(executor, 'creance_factures');
    numberFacture = NumberFactureRepository(executor, 'number_factures');
    ventes = VenteRepository(executor, 'ventes');
    gains = GainRepository(executor, 'gains');
    historyRavitaillements =
        HistoryRavitaillementRepository(executor, 'history_ravitaillements'); 

    stocksGlobal = StockGlobalRepository(executor, 'stocks_global');
    succursales = SuccursaleRepository(executor, 'succursales');
    bonLivraison = BonLivraisonRepository(executor, 'bon_livraisons');
    restitutions = RestitutionRepository(executor, 'restitutions');
    historyLivraisons =
        HistoryLivraisonRepository(executor, 'history_livraisons');

    // RESTAURANT
    prodRestModels = ProdModelRestRepository(executor, 'prod_model_rests');
    creanceRests = CreanceRestRepository(executor, 'creance_rests');
    factureRests = FactureRestRepository(executor, 'facture_rests');
    restaurants = RestaurantRepository(executor, 'restaurants');
    tableRests = TableRestRepository(executor, 'table_rests');
    venteEffectueeRests = VenteEffectueeRestRepository(executor, 'vente_effectuee_rests');

    // VIP
    prodVipModels = ProdModelVipRepository(executor, 'prod_model_vips');
    creanceVips = CreanceVipRepository(executor, 'creance_vips');
    factureVips = FactureVipRepository(executor, 'facture_vips');
    vips = VipRepository(executor, 'vips');
    tableVips = TableVipRepository(executor, 'table_vips');
    venteEffectueeVips = VenteEffectueeVipRepository(executor, 'vente_effectuee_vips');

    // TERRASSE
    prodTerrasseModels = ProdModelTerrasseRepository(executor, 'prod_model_terrasses');
    creanceTerrasses = CreanceTerrasseRepository(executor, 'creance_terrasses');
    factureTerrasses = FactureTerrasseRepository(executor, 'facture_terrasses');
    terrasses = TerrasseRepository(executor, 'terrasses');
    tableTerrasses = TableTerrasseRepository(executor, 'table_terrasses');
    venteEffectueeTerrasses = VenteEffectueeTerrasseRepository(executor, 'vente_effectuee_terrasses');

    // LIVRAISON
    prodLivraisonModels = ProdModelLivraisonRepository(executor, 'prod_model_livraisons');
    creanceLivraisons = CreanceLivraisonRepository(executor, 'creance_livraisons');
    factureLivraisons = FactureLivraisonRepository(executor, 'facture_livraisons');
    livraisons = LivraisonRepository(executor, 'livraisons');
    tableLivraisons = TableLivraisonRepository(executor, 'table_livraisons');
    venteEffectueeLivraisons = VenteEffectueeLivraisonRepository(executor, 'vente_effectuee_livraisons');

    // MARKETING
    agendas = AgendaRepository(executor, 'agendas');
    annuaires = AnnuaireReposiotry(executor, 'annuaires');

    // ARCHIVE
    archives = ArchiveRepository(executor, 'archives');
    archivesFolders = ArchiveFolderRepository(executor, 'archives_folders');

    // Mails
    mails = MailRepository(executor, 'mails');

    updateVersion = UpdateVersionRepository(executor, 'update_versions');

    // Reservations
    reservationRepository = ReservationRepository(executor, 'reservations');
    paiementReservationRepository =
        PaiementReservationRepository(executor, 'paiement_reservations');

    // FINANCES
    caisseNames = CaisseNameRepository(executor, 'caisse_names');
    caisses = CaissesRepository(executor, 'caisses');
  }
}

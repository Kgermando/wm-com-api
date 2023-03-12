import 'package:postgres/postgres.dart';

import 'abonnement/abonnement_repository.dart';
import 'archives/archive_folder_repository.dart';
import 'archives/archive_repository.dart';
import 'commercial/achats_repository.dart';
import 'commercial/ardoise_repository.dart';
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
import 'mails/mail_repository.dart';
import 'marketing/agenda_repository.dart';
import 'marketing/annuaire_repository.dart';
import 'notify/commercial/cart_notify_repository.dart';
import 'notify/mails/mails_notify_repository.dart';
import 'notify/marketing/agenda_notify_repository.dart';
import 'reservation/paiement_reservation_repository.dart';
import 'reservation/reservation_repository.dart';
import 'rh/agents_repository.dart';

import 'settings/monnaie_repository.dart';
import 'update/update_version_repository.dart';
import 'user/refresh_token_repository.dart';
import 'user/user_repository.dart';

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
  late ArdoiseRepository ardoises;
  late StockGlobalRepository stocksGlobal;
  late SuccursaleRepository succursales;
  late BonLivraisonRepository bonLivraison;
  late RestitutionRepository restitutions;
  late HistoryLivraisonRepository historyLivraisons; 


  // MArketing
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
    ardoises = ArdoiseRepository(executor, 'ardoises');
 
    stocksGlobal = StockGlobalRepository(executor, 'stocks_global');
    succursales = SuccursaleRepository(executor, 'succursales');
    bonLivraison = BonLivraisonRepository(executor, 'bon_livraisons'); 
    restitutions = RestitutionRepository(executor, 'restitutions');  
    historyLivraisons =
        HistoryLivraisonRepository(executor, 'history_livraisons');

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

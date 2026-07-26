/*
===========================================
ZSOLT AI PRO 2
League Translator
Version: v1.0.0
===========================================
*/

class LeagueTranslator {
  LeagueTranslator._();

  static const Map<String, String> _translations = {
    // UEFA
    'UEFA Champions League': 'UEFA Bajnokok Ligája',
    'UEFA Europa League': 'UEFA Európa-liga',
    'UEFA Conference League': 'UEFA Konferencia-liga',
    'UEFA Super Cup': 'UEFA Szuperkupa',
    'UEFA Nations League': 'UEFA Nemzetek Ligája',
    'UEFA Youth League': 'UEFA Ifjúsági Liga',

    // FIFA
    'FIFA World Cup': 'Labdarúgó-világbajnokság',
    'FIFA Club World Cup': 'FIFA Klubvilágbajnokság',
    'World Cup': 'Világbajnokság',
    'Club World Cup': 'Klubvilágbajnokság',

    // Európa-bajnokság
    'UEFA European Championship': 'Európa-bajnokság',
    'European Championship': 'Európa-bajnokság',
    'EURO': 'Európa-bajnokság',

    // Anglia
    'Premier League': 'Premier League',
    'Championship': 'Championship',
    'League One': 'League One',
    'League Two': 'League Two',
    'National League': 'Nemzeti Liga',
    'FA Cup': 'FA-kupa',
    'EFL Cup': 'Ligakupa',
    'Community Shield': 'Community Shield',

    // Spanyolország
    'La Liga': 'La Liga',
    'LaLiga': 'La Liga',
    'Segunda Division': 'Segunda División',
    'Segunda División': 'Segunda División',
    'Copa del Rey': 'Király-kupa',
    'Super Cup': 'Szuperkupa',

    // Olaszország
    'Serie A': 'Serie A',
    'Serie B': 'Serie B',
    'Serie C': 'Serie C',
    'Coppa Italia': 'Olasz Kupa',
    'Supercoppa Italiana': 'Olasz Szuperkupa',

    // Németország
    'Bundesliga': 'Bundesliga',
    '2. Bundesliga': '2. Bundesliga',
    '3. Liga': '3. Liga',
    'DFB Pokal': 'Német Kupa',
    'DFB-Pokal': 'Német Kupa',

    // Franciaország
    'Ligue 1': 'Ligue 1',
    'Ligue 2': 'Ligue 2',
    'Coupe de France': 'Francia Kupa',
    'Trophee des Champions': 'Francia Szuperkupa',

    // Hollandia
    'Eredivisie': 'Eredivisie',
    'Eerste Divisie': 'Eerste Divisie',
    'KNVB Cup': 'Holland Kupa',

    // Portugália
    'Primeira Liga': 'Primeira Liga',
    'Liga Portugal': 'Primeira Liga',
    'Taca de Portugal': 'Portugál Kupa',

    // Belgium
    'Jupiler Pro League': 'Belga Pro League',

    // Törökország
    'Super Lig': 'Süper Lig',
    'Süper Lig': 'Süper Lig',
    'Turkish Cup': 'Török Kupa',

    // Magyarország
    'NB I': 'NB I',
    'NB II': 'NB II',
    'Magyar Kupa': 'Magyar Kupa',

    // USA
    'Major League Soccer': 'MLS',
    'MLS': 'MLS',
    'MLS Next Pro': 'MLS Next Pro',
    'USL Championship': 'USL Championship',
    'US Open Cup': 'US Open Cup',

    // Brazília
    'Serie A Brazil': 'Brazil Serie A',
    'Serie B Brazil': 'Brazil Serie B',
    'Copa do Brasil': 'Brazil Kupa',

    // Argentína
    'Liga Profesional': 'Argentin Primera División',

    // Japán
    'J1 League': 'J1 Liga',
    'J2 League': 'J2 Liga',

    // Dél-Korea
    'K League 1': 'K League 1',
    'K League 2': 'K League 2',

    // Ausztrália
    'A-League': 'A-League',

    // Barátságos
    'Club Friendlies': 'Barátságos klubmérkőzések',
    'Friendly Match': 'Barátságos mérkőzés',
    'Friendly International': 'Válogatott barátságos mérkőzés',
    'International Friendlies': 'Nemzetközi barátságos mérkőzések',

    // Utánpótlás
    'U17': 'U17',
    'U18': 'U18',
    'U19': 'U19',
    'U20': 'U20',
    'U21': 'U21',
    'U23': 'U23',

    // Női
    "Women's Super League": 'Női Szuperliga',
    "Women's Champions League": 'Női Bajnokok Ligája',

    // Általános
    'Cup': 'Kupa',
    'League Cup': 'Ligakupa',
    'Super Cup': 'Szuperkupa',
    'Qualification': 'Selejtező',
    'Qualifiers': 'Selejtezők',
    'Playoffs': 'Rájátszás',
    'Reserve League': 'Tartalék Liga',
    'Reserve Cup': 'Tartalék Kupa',
    'Youth League': 'Ifjúsági Liga',
  };

  static String translate(String? league) {
    if (league == null || league.trim().isEmpty) {
      return '';
    }

    final key = league.trim();

    if (_translations.containsKey(key)) {
      return _translations[key]!;
    }

    return key;
  }

  static bool hasTranslation(String? league) {
    if (league == null) return false;
    return _translations.containsKey(league.trim());
  }
}

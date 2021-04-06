/// Enumération des différentes catégories de service proposés.
enum Categorie {
  economie,
  emploi,
  environnement,
  immobilier,
  loisirs,
  mode,
  multimedia,
  politique,
  sport,
  vacances,
  vehicules,
}

/// Méthode pour utiliser directement une valeur de l'énumération au format String.
String enumToString(Object o) => o.toString().split('.').last;

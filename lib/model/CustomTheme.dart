/// Classe pour configurer le thème couleur de l'application.
class CustomTheme {
  String themeName;
  int primaryColor;
  int primaryColorDark;
  int secondaryColor;
  int secondaryColorDark;
  int background;
  int textColor;

  CustomTheme(
      {this.themeName,
      this.primaryColor,
      this.primaryColorDark,
      this.secondaryColor,
      this.secondaryColorDark,
      this.background,
      this.textColor});

  factory CustomTheme.fromMap(Map<String, dynamic> data) => new CustomTheme(
        themeName: data['theme_name'],
        primaryColor: data['primary_color'],
        primaryColorDark: data['primary_color_dark'],
        secondaryColor: data['secondary_color'],
        secondaryColorDark: data['secondary_color_dark'],
        background: data['background'],
        textColor: data['text_color'],
      );

  Map<String, dynamic> toMap() => {
        "theme_name": themeName,
        "primary_color": primaryColor,
        "primary_color_dark": primaryColorDark,
        "secondary_color": secondaryColor,
        "secondary_color_dark": secondaryColorDark,
        "background": background,
        "text_color": textColor,
      };
}

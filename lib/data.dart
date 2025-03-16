class NewsItem {
  final String title;
  final String description;
  final String content;
  final List<String> references;
  final String type = 'news';
  NewsItem({required this.title, required this.description, required this.content, required this.references});
}

class AlertItem extends NewsItem {
  @override
  final String type = 'alert';
  AlertItem({required super.title, required super.description, required super.content, required super.references});
}

class TrendingSearchItem {
  final String label;
  TrendingSearchItem({required this.label});
}

class CityItem {
  final String name;
  final String zipCode;
  CityItem({required this.name, required this.zipCode});
}

class Data {
  static final List<NewsItem> news = [];

  static final List<CityItem> cities = [
    CityItem(name: 'Barcelona', zipCode: '08001'),
    CityItem(name: 'Madrid', zipCode: '28001'),
    CityItem(name: 'Valencia', zipCode: '46001'),
  ];

  static List<TrendingSearchItem> fullTrendingSearches = [
    TrendingSearchItem(label: "Salud"),
    TrendingSearchItem(label: "Dieta keto"),
    TrendingSearchItem(label: "Ejercicio diario"),
    TrendingSearchItem(label: "Dolor de cabeza"),
    TrendingSearchItem(label: "Fiebre alta"),
    TrendingSearchItem(label: "Cáncer de mama"),
    TrendingSearchItem(label: "Tensión arterial"),
    TrendingSearchItem(label: "Reflujo gastroesofágico"),
    TrendingSearchItem(label: "Antioxidantes naturales"),
    TrendingSearchItem(label: "Vitaminas esenciales"),
    TrendingSearchItem(label: "Deficiencia de hierro"),
    TrendingSearchItem(label: "Ejercicios para la salud"),
    TrendingSearchItem(label: "Control de peso"),
    TrendingSearchItem(label: "Mente sana"),
    TrendingSearchItem(label: "Bienestar"),
    TrendingSearchItem(label: "Prevención de enfermedades"),
    TrendingSearchItem(label: "Cuidado personal"),
    TrendingSearchItem(label: "Estrés laboral"),
    TrendingSearchItem(label: "Salud mental"),
    TrendingSearchItem(label: "Alimentación saludable"),
    TrendingSearchItem(label: "Dieta mediterránea"),
    TrendingSearchItem(label: "Nutrición infantil"),
    TrendingSearchItem(label: "Obesidad infantil"),
    TrendingSearchItem(label: "Colesterol alto"),
    TrendingSearchItem(label: "Diabetes tipo 2"),
    TrendingSearchItem(label: "Hipertensión"),
    TrendingSearchItem(label: "Ejercicios de estiramiento"),
    TrendingSearchItem(label: "Rutina de yoga"),
    TrendingSearchItem(label: "Medicina preventiva"),
    TrendingSearchItem(label: "Tratamiento natural"),
    TrendingSearchItem(label: "Cuidado dental"),
    TrendingSearchItem(label: "Salud cardiovascular"),
    TrendingSearchItem(label: "Recuperación postoperatoria"),
    TrendingSearchItem(label: "Dolor lumbar"),
    TrendingSearchItem(label: "Artritis reumatoide"),
    TrendingSearchItem(label: "Síndrome metabólico"),
    TrendingSearchItem(label: "Tratamiento alternativo"),
    TrendingSearchItem(label: "Heridas abiertas"),
    TrendingSearchItem(label: "Cirugía estética"),
    TrendingSearchItem(label: "Colágeno natural"),
    TrendingSearchItem(label: "Desintoxicación"),
    TrendingSearchItem(label: "Salud digestiva"),
    TrendingSearchItem(label: "Cáncer de pulmón"),
    TrendingSearchItem(label: "Infección urinaria"),
    TrendingSearchItem(label: "Vacunas infantiles"),
    TrendingSearchItem(label: "Antibióticos naturales"),
    TrendingSearchItem(label: "Hidratación adecuada"),
    TrendingSearchItem(label: "Sistema inmunológico"),
    TrendingSearchItem(label: "Bienestar emocional"),
    TrendingSearchItem(label: "Calma interior")
  ];

  static List<TrendingSearchItem> _trendingSearches = [];
  static List<TrendingSearchItem> get trendingSearches {
    if (_trendingSearches.isEmpty) {
      _trendingSearches = fullTrendingSearches..shuffle();
      _trendingSearches = _trendingSearches.sublist(0, 3);
    }
    return _trendingSearches;
  }
}

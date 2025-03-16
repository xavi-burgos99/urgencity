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
  static final List<NewsItem> news = [
    AlertItem(
      title: 'Lorem ipsum dolor sit amet',
      description: 'Consectetur adipiscing elit. Nullam auctor, nunc nec ultricies.',
      content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies.',
      references: ['https://example.com/1', 'https://example.com/2']
    ),
    AlertItem(
      title: 'Lorem ipsum dolor sit amet',
      description: 'Consectetur adipiscing elit. Nullam auctor, nunc nec ultricies.',
      content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies.',
      references: ['https://example.com/1', 'https://example.com/2']
    ),
    NewsItem(
      title: 'Lorem ipsum dolor sit amet',
      description: 'Consectetur adipiscing elit. Nullam auctor, nunc nec ultricies.',
      content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies.',
      references: ['https://example.com/1', 'https://example.com/2']
    ),
    NewsItem(
      title: 'Lorem ipsum dolor sit amet',
      description: 'Consectetur adipiscing elit. Nullam auctor, nunc nec ultricies.',
      content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies.',
      references: ['https://example.com/1', 'https://example.com/2']
    ),
    NewsItem(
      title: 'Lorem ipsum dolor sit amet',
      description: 'Consectetur adipiscing elit. Nullam auctor, nunc nec ultricies.',
      content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies. Nullam auctor, nunc nec ultricies. Donec nec nunc nec ultricies.',
      references: ['https://example.com/1', 'https://example.com/2']
    ),
  ];

  static final List<TrendingSearchItem> trendingSearches = [
    TrendingSearchItem(label: 'Lorem ipsum'),
    TrendingSearchItem(label: 'Dolor sit amet'),
    TrendingSearchItem(label: 'Consectetur adipiscing'),
  ];

  static final List<CityItem> cities = [
    CityItem(name: 'Barcelona', zipCode: '08001'),
    CityItem(name: 'Madrid', zipCode: '28001'),
    CityItem(name: 'Valencia', zipCode: '46001'),
  ];
}
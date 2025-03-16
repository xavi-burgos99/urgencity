import 'dart:convert';
import 'package:http/http.dart' as http;
import 'data.dart';
import 'keys.dart';

Future<List<NewsItem>> fetchNewsItems(String trendingLabel, {bool forceAlert = false}) async {
  const int numQueries = 1;
  List<NewsItem> allItems = [];
  for (int i = 0; i < numQueries; i++) {
    final items = await _fetchNewsItemsOnce(trendingLabel, forceAlert: forceAlert);
    allItems.addAll(items);
  }
  if (allItems.length > 3) {
    allItems = allItems.sublist(0, 3);
  }
  return allItems;
}

Future<List<NewsItem>> _fetchNewsItemsOnce(String trendingLabel, {bool forceAlert = false}) async {
  const String url = 'https://api.perplexity.ai/chat/completions';
  String systemContent = 'Eres un asistente experto en generar noticias precisas y bien estructuradas. Para cada solicitud, debes generar una noticia con el siguiente formato JSON exacto: {"title": "Título de la noticia", "description": "Descripción breve de una línea", "content": "Contenido detallado y estructurado para un artículo", "references": ["url1", "url2"], "type": "news o alert"}. El campo "type" debe ser "alert" si la noticia contiene información urgente o crítica que requiere atención inmediata, de lo contrario debe ser "news". Usa datos actuales y verifica la información. Es muy importante que solo proporciones el JSON solicitado y no incluyas ningún otro texto preámbulo o adicional.';
  if (forceAlert) {
    systemContent =
    'Eres un asistente experto en generar alertas precisas y bien estructuradas. Para cada solicitud, debes generar una alerta con el siguiente formato JSON exacto: {"title": "Título de la alerta", "description": "Descripción breve de una línea", "content": "Contenido detallado y estructurado para una alerta", "references": ["url1", "url2"], "type": "alert"}. Usa datos actuales y verifica la información. Es muy importante que solo proporciones el JSON solicitado y no incluyas ningún otro texto preámbulo o adicional.';
  }
  final List<Map<String, String>> messages = [
    {
      'role': 'system',
      'content': systemContent,
    },
    {
      'role': 'user',
      'content':
      'Genera una noticia sobre: "$trendingLabel". Utiliza el formato JSON solicitado. Asegúrate que el contenido esté bien estructurado para un artículo de noticias.'
    },
  ];

  final Map<String, dynamic> requestBody = {
    'model': 'sonar-pro',
    'messages': messages,
    'stream': false,
  };

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $PERPLEXITY_API_KEY',
    },
    body: jsonEncode(requestBody),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);

    // Extrae el contenido del mensaje del asistente
    String assistantMessage = data['choices'][0]['message']['content'];

    assistantMessage = assistantMessage
      .replaceAll("\r", "") // Eliminar retornos de carro
      .replaceAllMapped(RegExp(r'[\x00-\x1F]'), (match) => ''); // Eliminar caracteres de control

    // Usar una expresión regular para extraer el primer bloque JSON encontrado
    final RegExp regex = RegExp(r'\{[\S\s]*?\}');
    final match = regex.firstMatch(assistantMessage);
    if (match != null) {
      assistantMessage = match.group(0)!;
    } else {
      print('No se encontró un JSON válido en la respuesta');
      return [];
    }

    // Intenta parsear el JSON de la respuesta
    try {
      final Map<String, dynamic> newsData = jsonDecode(assistantMessage);

      if (!newsData.containsKey('title') || !newsData.containsKey('description') ||
          !newsData.containsKey('content') || !newsData.containsKey('type')) {
        print('JSON recibido no tiene los campos requeridos');
        return [];
      }

      final String title = newsData['title']?.toString() ?? 'Sin título';
      final String description = newsData['description']?.toString() ?? '';
      final String content = newsData['content']?.toString() ?? '';
      final String type = newsData['type']?.toString().toLowerCase() ?? 'news';
      final List<String> references = (newsData['references'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [];

      if (type == 'alert') {
        return [AlertItem(
          title: title,
          description: description,
          content: content,
          references: references,
        )];
      } else {
        return [NewsItem(
          title: title,
          description: description,
          content: content,
          references: references,
        )];
      }
    } catch (e) {
      print('Error al parsear JSON: $e');
      print('Respuesta recibida: $assistantMessage');

      return [NewsItem(
        title: 'Error en la generación de noticias',
        description: 'No se pudo procesar correctamente la información sobre $trendingLabel.',
        content: 'Se produjo un error al recuperar la noticia.',
        references: [],
      )];
    }
  } else {
    throw Exception('Error al obtener las noticias: ${response.statusCode}');
  }
}

generateNewsItems(TrendingSearchItem trendingSearch, {bool forceAlert = false}) async {
  final List<NewsItem> newsItems = await fetchNewsItems(trendingSearch.label, forceAlert: forceAlert);
  Data.news.insertAll(0, newsItems);
  Data.news.sort((a, b) => a.type.compareTo(b.type));
}

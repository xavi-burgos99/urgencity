import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data.dart'; // Para importar la clase NewsItem

String getHostIcon(String url) {
  final Uri uri = Uri.parse(url);
  String host = uri.host;
  if (host.contains('example.com')) {
    host = 'perplexity.com';
  }
  return "https://www.google.com/s2/favicons?domain=${host}&sz=64";
}

class NewsScreen extends StatelessWidget {
  final NewsItem article;
  const NewsScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    // Convertir las referencias en formato de fuentes
    final List<Map<String, String>> sources = [];
    for (int i = 0; i < article.references.length; i++) {
      String url = article.references[i];
      String name = 'Fuente ${i + 1}';

      // Intentar extraer un nombre más descriptivo del dominio
      try {
        final Uri uri = Uri.parse(url);
        String host = uri.host.replaceAll('www.', '');
        name = host.split('.').first.toUpperCase();
      } catch (e) {
        // Si hay error, mantener el nombre genérico
      }

      sources.add({'name': name, 'url': url});
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticia'),
        backgroundColor: article.type == 'alert' ? Colors.red : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner de alerta si corresponde
                if (article.type == 'alert')
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Esta información requiere atención inmediata',
                            style: TextStyle(color: Colors.red[900]),
                          ),
                        ),
                      ],
                    ),
                  ),

                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.description,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  article.content,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Fuentes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (sources.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: sources.length,
                    itemBuilder: (context, index) {
                      final source = sources[index];
                      return ElevatedButton(
                        onPressed: () async {
                          final Uri url = Uri.parse(source['url']!);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('No se pudo abrir ${source['name']}')),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.all(4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.network(
                                    getHostIcon(source['url']!),
                                    width: 32,
                                    height: 32,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.public, size: 32),
                                  ),
                                  Text(
                                    source['name']!,
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const Positioned(
                              right: 4,
                              top: 4,
                              child: Icon(
                                Icons.arrow_outward,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                if (sources.isEmpty)
                  const Center(
                    child: Text(
                      'No hay fuentes disponibles',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

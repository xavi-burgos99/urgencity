import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

String getHostIcon(String url) {
  final Uri uri = Uri.parse(url);
  String host = uri.host;
  if (host.contains('example.com')) {
    host = 'perplexity.com';
  }
  return "https://www.google.com/s2/favicons?domain=${host}&sz=64";
}
class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> sources = [
      {'name': 'Fuente 1', 'url': 'https://example.com/fuente1'},
      {'name': 'Fuente 2', 'url': 'https://example.com/fuente2'},
      {'name': 'Fuente 3', 'url': 'https://example.com/fuente3'},
      {'name': 'Fuente 4', 'url': 'https://example.com/fuente4'},
    ];
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Título de la Noticia',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Este es un resumen más extenso de la noticia. Aquí puedes escribir varios párrafos detallando los aspectos más importantes de la noticia. '
                  'Puedes incluir información sobre el contexto, los hechos principales, las implicaciones y las reacciones a los eventos descritos. '
                  'Un buen resumen debe proporcionar al lector una comprensión clara de la noticia sin necesidad de buscar información adicional. '
                  'Asegúrate de cubrir los puntos clave y mantener un tono objetivo y informativo a lo largo del texto.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 12),
                const SizedBox(height: 8),
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
                          await launchUrl(url);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No se pudo abrir ${source['name']}')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.all(4), // Reducido para cuadros más compactos
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4), // Esquinas ligeramente redondeadas
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
                                  width: 32, // Icono más pequeño
                                  height: 32, // Icono más pequeño
                                ),
                                Text(
                                  source['name']!,
                                  style: const TextStyle(fontSize: 12), // Texto más pequeño
                                ),
                              ],
                            ),
                          ),
                          const Positioned(
                            right: 4,
                            top: 4,
                            child: Icon(
                              Icons.arrow_outward,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

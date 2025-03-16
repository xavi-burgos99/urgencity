import 'data.dart';
import 'utils.dart';
import 'package:flutter/material.dart';
import 'news_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                String? selectedCity = Data.cities.first.zipCode;
                return DropdownButton<String>(
                  value: selectedCity,
                  items: Data.cities.map((city) {
                    return DropdownMenuItem<String>(
                      value: city.zipCode,
                      child: Text(city.name),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedCity = newValue;
                      });
                    }
                  },
                  underline: const SizedBox(),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(10),
                  dropdownColor: Colors.teal[50],
                );
              },
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tendencias',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...Data.trendingSearches.map((search) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  leading: const Icon(Icons.trending_up),
                  title: Text(search.label),
                  trailing: isSearching ? null : IconButton(
                    icon: const Icon(Icons.auto_awesome),
                    onPressed: () async {
                      setState(() { isSearching = true; });
                      await generateNewsItems(search, forceAlert: false);
                      setState(() { isSearching = false; });
                    },
                    color: Colors.teal,
                  ),
                  dense: true,
                  visualDensity: const VisualDensity(vertical: -2),
                )),
                const SizedBox(height: 20),
                const Text(
                  'Actualidad',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (isSearching)
                  ...[
                    const SizedBox(height: 50),
                    const Center(child: CircularProgressIndicator()),
                  ],
                if (!isSearching)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (Data.news.isEmpty)
                        Column(
                          children: [
                            const SizedBox(height: 50),
                            const Text('No hay noticias recientes'),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () async {
                                setState(() { isSearching = true; });
                                bool isForcedAlert = true;
                                for (final search in Data.trendingSearches) {
                                  await generateNewsItems(search, forceAlert: isForcedAlert);
                                  isForcedAlert = false;
                                }
                                setState(() { isSearching = false; });
                              },
                              child: Text('Buscar noticias'),
                            ),
                          ],
                        ),
                      if (Data.news.isNotEmpty)
                        ...Data.news.map((article) => Card(
                          child: ListTile(
                            title: Text(article.title),
                            subtitle: article.type == 'alert' ? null : Text(article.description),
                            tileColor: article.type == 'alert' ? Colors.red[50] : null,
                            leading: article.type == 'alert' ? const Icon(Icons.warning, color: Colors.red) : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsScreen(article: article),
                                ),
                              );
                            },
                          ),
                        )),
                    ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
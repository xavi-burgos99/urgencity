import 'data.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40, // Reduce la altura de la AppBar
        elevation: 0, // Elimina la sombra para un diseño más limpio
        backgroundColor: Colors.transparent, // Hace que el fondo sea transparente si se desea
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                String? selectedCity = Data.cities.first.zipCode; // Primer elemento como default
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
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
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
                  visualDensity: const VisualDensity(vertical: -4),
                )),
                const SizedBox(height: 20),
                const Text(
                  'Actualidad',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...Data.news.map((article) => Card(
                  child: ListTile(
                    title: Text(article.title),
                    subtitle: article.type == 'alert' ? null : Text(article.description),
                    tileColor: article.type == 'alert' ? Colors.red[50] : null,
                    leading: article.type == 'alert' ? const Icon(Icons.warning, color: Colors.red) : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

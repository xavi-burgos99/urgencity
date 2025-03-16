import 'package:flutter/material.dart';
import 'dart:ui'; // Necesario para el efecto de desenfoque


class HospitalData {
  final String hospitalName;
  final String address;
  final String phone;
  final int peopleInUrgencies;
  final int peopleInPediatricUrgencies;
  final int minWaitTimeUrgencies;
  final int maxWaitTimeUrgencies;
  final int minWaitTimePediatricUrgencies;
  final int maxWaitTimePediatricUrgencies;

  HospitalData({
    required this.hospitalName,
    required this.address,
    required this.phone,
    required this.peopleInUrgencies,
    required this.peopleInPediatricUrgencies,
    required this.minWaitTimeUrgencies,
    required this.maxWaitTimeUrgencies,
    required this.minWaitTimePediatricUrgencies,
    required this.maxWaitTimePediatricUrgencies,
  });
}

class HospitalInfo {
  static final HospitalData hospitalGeneral = HospitalData(
    hospitalName: 'Hospital Universitari General de Catalunya',
    address: 'Carrer de Pedro i Pons, 1, 08195 Sant Cugat del Vallès, Barcelona',
    phone: '+34 935 656 000',
    peopleInUrgencies: 50,
    peopleInPediatricUrgencies: 10,
    minWaitTimeUrgencies: 45,
    maxWaitTimeUrgencies: 130,
    minWaitTimePediatricUrgencies: 20,
    maxWaitTimePediatricUrgencies: 75,
  );

  // Añadimos más hospitales para demostrar la búsqueda
  static final List<HospitalData> allHospitals = [
    hospitalGeneral,
    HospitalData(
      hospitalName: 'Hospital Clínic de Barcelona',
      address: 'Carrer de Villarroel, 170, 08036 Barcelona',
      phone: '+34 932 27 54 00',
      peopleInUrgencies: 70,
      peopleInPediatricUrgencies: 15,
      minWaitTimeUrgencies: 60,
      maxWaitTimeUrgencies: 150,
      minWaitTimePediatricUrgencies: 30,
      maxWaitTimePediatricUrgencies: 90,
    ),
    HospitalData(
      hospitalName: 'Hospital de Sant Pau',
      address: 'Carrer de Sant Quintí, 89, 08026 Barcelona',
      phone: '+34 932 91 90 00',
      peopleInUrgencies: 45,
      peopleInPediatricUrgencies: 8,
      minWaitTimeUrgencies: 40,
      maxWaitTimeUrgencies: 110,
      minWaitTimePediatricUrgencies: 25,
      maxWaitTimePediatricUrgencies: 60,
    ),
  ];
}

// Enumeración para los tipos de urgencias
enum UrgencyType { general, pediatric }

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Estado para el tipo de urgencia seleccionado
  UrgencyType _selectedUrgencyType = UrgencyType.general;
  // Controlador para el campo de búsqueda
  final TextEditingController _searchController = TextEditingController();
  // Variables para la funcionalidad del buscador
  String _searchText = "";
  List<HospitalData> _filteredHospitals = [];
  bool _isSearching = false;

  final FocusNode _searchFocusNode = FocusNode();
  
  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose(); // No olvides liberar los recursos
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _filteredHospitals = HospitalInfo.allHospitals; // Inicialmente muestra todos
    
    // Escucha cambios en el buscador
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
        _filterHospitals();
      });
    });
  }


  

  // Método para filtrar hospitales según el texto de búsqueda
  void _filterHospitals() {
    if (_searchText.isEmpty) {
      _filteredHospitals = HospitalInfo.allHospitals;
      _isSearching = false;
    } else {
      _filteredHospitals = HospitalInfo.allHospitals.where((hospital) {
        return hospital.hospitalName.toLowerCase().contains(_searchText.toLowerCase()) ||
               hospital.address.toLowerCase().contains(_searchText.toLowerCase());
      }).toList();
      _isSearching = true;
    }

    // Asegurar que el foco se mantiene en el campo de búsqueda
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(
            child: Text('Map Screen', style: TextStyle(fontSize: 24)),
          ),
          Image.asset(
            'assets/map_background.png', // Agrega esta imagen a tu carpeta assets
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          
          // 2. Efecto de desenfoque cuando está buscando
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: _isSearching ? 10 : 0, sigmaY: _isSearching ? 10 : 0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white.withOpacity(0.2), // Oscurece ligeramente
            ),
          ),
          // Barra de búsqueda en la parte superior
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Mismo estilo que SegmentedButton
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(

                    hintText: 'Buscar hospital o dirección...',
                    hintStyle: TextStyle(color: Colors.black),
                    prefixIcon: const Icon(Icons.search, color: Colors.teal),
                    suffixIcon: _searchText.isNotEmpty 
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.teal),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
          ),
          
          // SegmentedButton ahora colocado debajo de la barra de búsqueda
          Positioned(
            top: 110,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SegmentedButton<UrgencyType>(
                    segments: const [
                      ButtonSegment<UrgencyType>(
                        value: UrgencyType.general,
                        label: Text('Generales'),
                        icon: Icon(Icons.local_hospital),
                      ),
                      ButtonSegment<UrgencyType>(
                        value: UrgencyType.pediatric,
                        label: Text('Pediátricas'),
                        icon: Icon(Icons.child_friendly),
                      ),
                    ],
                    selected: {_selectedUrgencyType},
                    onSelectionChanged: (Set<UrgencyType> newSelection) {
                      setState(() {
                        _selectedUrgencyType = newSelection.first;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.teal;
                          }
                          return Colors.white;
                        },
                      ),
                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.white;
                          }
                          return Colors.black87;
                        },
                      ),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        const Size(double.infinity, 48),
                      ),
                      side: MaterialStateProperty.all(
                        BorderSide(color: Colors.transparent, width: 0),
                      ),
                    ),
                    showSelectedIcon: false,
                  ),
                ),
              ),
            ),
          ),
          
          // Resultados de búsqueda (cuando está buscando y no hay resultados)
          if (_isSearching && _filteredHospitals.isEmpty)
            Positioned(
              top: 170,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  'No se encontraron hospitales con "$_searchText"',
                  style: TextStyle(color: Colors.grey.shade700),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          
          // Lista de hospitales encontrados
          if (_isSearching && _filteredHospitals.isNotEmpty)
            Positioned(
              top: 170,
              left: 0,
              right: 0,
              bottom: 80, // Espacio para el botón inferior
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: _filteredHospitals.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final hospital = _filteredHospitals[index];
                    return ListTile(
                      title: Text(hospital.hospitalName),
                      subtitle: Text(hospital.address),
                      leading: const Icon(Icons.local_hospital, color: Colors.teal),
                      onTap: () {
                        _showSlideUpPanel(context, hospital: hospital);
                      },
                    );
                  },
                ),
              ),
            ),
          
          // Botón para ver hospital
          /*Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              onPressed: _filteredHospitals.isNotEmpty
                ? () => _showSlideUpPanel(
                    context,
                    hospital: _isSearching ? _filteredHospitals.first : HospitalInfo.hospitalGeneral,
                  )
                : null, // Desactivar si no hay resultados
              child: const Text('Ver Hospital'),
            ),
          ),
        */],
      ),
    );
  }

  void _showSlideUpPanel(BuildContext context, {required HospitalData hospital}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        alignment: Alignment.bottomCenter,
        heightFactor: 0.8,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text(
                hospital.hospitalName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.teal),
                title: Text(hospital.address),
              ),
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.teal),
                title: Text(hospital.phone),
              ),
              const Divider(),
              
              // Mostrar información según el tipo de urgencia seleccionado
              if (_selectedUrgencyType == UrgencyType.general)
                ListTile(
                  leading: const Icon(Icons.local_hospital_rounded, color: Colors.teal),
                  title: Text('Personas en Urgencias: ${hospital.peopleInUrgencies}'),
                  subtitle: Text('Espera: ${formatWaitTime(hospital.minWaitTimeUrgencies)} - ${formatWaitTime(hospital.maxWaitTimeUrgencies)}'),
                )
              else
                ListTile(
                  leading: const Icon(Icons.child_friendly_rounded, color: Colors.teal),
                  title: Text('Personas en Urgencias Pediátricas: ${hospital.peopleInPediatricUrgencies}'),
                  subtitle: Text('Espera: ${formatWaitTime(hospital.minWaitTimePediatricUrgencies)} - ${formatWaitTime(hospital.maxWaitTimePediatricUrgencies)}'),
                ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String formatWaitTime(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else {
      int hours = minutes ~/ 60;
      int remainingMinutes = minutes % 60;
      return remainingMinutes == 0 ? '${hours}h' : '${hours}h ${remainingMinutes}m';
    }
  }
}

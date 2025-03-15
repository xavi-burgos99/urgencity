import 'package:flutter/material.dart';

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
    minWaitTimeUrgencies: 45, // En minutos
    maxWaitTimeUrgencies: 130, // En minutos (más de 2h)
    minWaitTimePediatricUrgencies: 20,
    maxWaitTimePediatricUrgencies: 75,
  );
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(
            child: Text('Map Screen', style: TextStyle(fontSize: 24)),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => _showSlideUpPanel(
                context,
                hospital: HospitalInfo.hospitalGeneral,
              ),
              child: const Text('Ver Hospital'),
            ),
          ),
        ],
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
        heightFactor: 0.8, // Ocupa el 80% de la pantalla
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Indicador de deslizamiento
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

              // Información del hospital
              ListTile(
                leading: const Icon(Icons.location_on, color: Colors.teal),
                title: Text(hospital.address),
              ),
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.teal),
                title: Text(hospital.phone),
              ),
              const Divider(),

              // Urgencias generales
              ListTile(
                leading: const Icon(Icons.local_hospital_rounded, color: Colors.teal),
                title: Text('Personas en Urgencias: ${hospital.peopleInUrgencies}'),
                subtitle: Text('Espera: ${formatWaitTime(hospital.minWaitTimeUrgencies)} - ${formatWaitTime(hospital.maxWaitTimeUrgencies)}'),
              ),

              // Urgencias pediátricas
              ListTile(
                leading: const Icon(Icons.child_friendly_rounded , color: Colors.teal),
                title: Text('Personas en Urgencias Pediátricas: ${hospital.peopleInPediatricUrgencies}'),
                subtitle: Text('Espera: ${formatWaitTime(hospital.minWaitTimePediatricUrgencies)} - ${formatWaitTime(hospital.maxWaitTimePediatricUrgencies)}'),
              ),

              const SizedBox(height: 20),

             
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Convierte minutos en formato "X min" o "Xh Ym" si es más de 60 min.
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
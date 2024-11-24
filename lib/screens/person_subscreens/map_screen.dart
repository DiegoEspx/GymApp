import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class GymLocationScreen extends StatelessWidget {
  const GymLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Coordenadas del gimnasio
    final LatLng gymCoordinates = LatLng(1.2287528942955555, -77.28338900443104);

    // Función para abrir Google Maps con la ubicación del gimnasio
   

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyGymApp Ubicación',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Encuentra nuestro gimnasio aquí',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: gymCoordinates, // Cambiado para versiones recientes
                  initialZoom: 15.0, // Cambiado para versiones recientes
                ),
                children: [
                  // Capa del mapa base
                  TileLayer(
                    urlTemplate:
                        'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                    subdomains: ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.proyectproducts',
                  ),
                  // Agregar un marcador para el gimnasio
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: gymCoordinates,
                        width: 80.0,
                        height: 80.0,
                        child: const Icon(
                          Icons.location_on,
                          size: 40.0,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:proyecto_barrion/services/sector_service.dart';
import 'package:proyecto_barrion/models/sector_model.dart';
import 'package:proyecto_barrion/services/consult_service.dart'; // Importamos el servicio
import 'package:proyecto_barrion/models/consul_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedSector;
  late Future<List<Sector>> _sectorsFuture;
  List<Outage> _outages = []; // Lista para almacenar los cortes de luz/agua obtenidos
  bool _isLoading = false; // Estado para mostrar indicador de carga

  final SectorService _sectorService = SectorService();

  @override
  void initState() {
    super.initState();
    _sectorsFuture = _sectorService.getAllSectors();
  }

  // Método para consultar los cortes de un sector seleccionado
  void _fetchOutages() async {
    if (_selectedSector == null || _selectedSector!.isEmpty) {
      print("⚠️ No se ha seleccionado ningún sector.");
      return;
    }

    print("📌 Sector seleccionado: $_selectedSector");

    setState(() {
      _isLoading = true;
    });

    try {
      List<Outage>? outages = await ConsultService.getOutages(_selectedSector!);

      setState(() {
        _outages = outages ?? []; // Si outages es null, asignamos lista vacía
      });
    } catch (e) {
      print("Error al obtener cortes de luz: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
        backgroundColor: Colors.blueAccent,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),  // Añadimos espaciado en el cuerpo
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Selecciona un sector:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),  // Espaciado entre el texto y el dropdown

            FutureBuilder<List<Sector>>(
              future: _sectorsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar sectores: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay sectores disponibles.'));
                } else {
                  List<Sector> sectors = snapshot.data!;
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedSector,
                      hint: const Text("Selecciona un sector"),
                      items: sectors.map((sector) {
                        return DropdownMenuItem<String>(
                          value: sector.name,
                          child: Text(sector.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSector = value;
                          print("✅ Sector seleccionado: $_selectedSector");
                        });
                      },
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 30,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),  // Espaciado entre el dropdown y el botón

            ElevatedButton(
              onPressed: _fetchOutages,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Corregido: Usamos backgroundColor en lugar de primary
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Consultar",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),  // Espaciado entre el botón y la lista

            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _outages.isEmpty
                ? const Center(child: Text("No hay cortes registrados para este sector."))
                : Expanded(
              child: ListView.builder(
                itemCount: _outages.length,
                itemBuilder: (context, index) {
                  final outage = _outages[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        "Corte de ${outage.service}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text("Horario: ${outage.createdAt}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
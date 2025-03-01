import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_barrion/components/dreawer.dart';
import 'package:proyecto_barrion/services/notification_service.dart';
import 'package:proyecto_barrion/services/sector_service.dart';
import 'package:proyecto_barrion/models/sector_model.dart';
import 'package:proyecto_barrion/services/consult_service.dart';
import 'package:proyecto_barrion/models/consul_model.dart';
import 'package:proyecto_barrion/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedSector;
  late Future<List<Sector>> _sectorsFuture;
  List<Outage> _outages = [];
  bool _isLoading = false;

  final SectorService _sectorService = SectorService();

  @override
  void initState() {
    super.initState();
    _sectorsFuture = _sectorService.getAllSectors();
  }

  void _fetchOutages() async {
    if (_selectedSector == null || _selectedSector!.isEmpty) {
      print("⚠️ No se ha seleccionado ningún sector.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      List<Outage>? outages = await ConsultService.getOutages(_selectedSector!);
      setState(() {
        _outages = outages ?? [];
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
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        String userRole = authProvider.isAuthenticated
            ? (authProvider.isAdmin ? 'ADMINISTRADOR' : 'USUARIO')
            : 'PUBLICO';

        if (!authProvider.isAuthenticated) {
          NotificationService.initializeNotifications(context);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Bienvenido'),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              },
            ),
          ),
          drawer: CustomDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 20),
                const Text(
                  "Selecciona un sector:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _fetchOutages,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Consultar",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
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
      },
    );
  }
}
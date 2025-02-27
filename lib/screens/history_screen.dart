import 'package:flutter/material.dart';
import 'package:proyecto_barrion/services/notification_history_service.dart';  // Ajusta la importación según tu estructura de proyecto
import 'package:proyecto_barrion/models/notification_model.dart.dart';  // Asegúrate de importar tu modelo

class HistorialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Historial")),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: NotificationHistoryService.fetchNotificationHistory(),  // Llamada al servicio
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mientras se está cargando
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // En caso de error
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.hasData && snapshot.data != null) {
            // Si los datos están disponibles
            final data = snapshot.data!;
            if (data['code'] == 'OK') {
              final List<dynamic> notificationsJson = data['data']['notificaciones'];
              final notifications = notificationsJson
                  .map((json) => NotificationModel.fromJson(json))
                  .toList();

              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return ListTile(
                    title: Text(notification.service),
                    subtitle: Text(notification.message),
                    trailing: Text(notification.createdAt),
                  );
                },
              );
            } else {
              // Si el 'code' no es OK
              return Center(child: Text(data['message']));
            }
          }

          // Si no hay datos o la respuesta fue inesperada
          return Center(child: Text("No se pudieron cargar las notificaciones."));
        },
      ),
    );
  }
}
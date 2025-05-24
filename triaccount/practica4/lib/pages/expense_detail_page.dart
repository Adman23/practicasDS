import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseDetailPage extends StatelessWidget {
  final Map<String, dynamic> expense;

  ExpenseDetailPage({required this.expense});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat("d 'de' MMMM 'de' y", 'es_ES').format(expense["date"]);

    final List<Map<String, dynamic>> participants = [
      {"name": "Andres", "amount": 1.83},
      {"name": "Antonio", "amount": 1.83},
      {"name": "Izaro", "amount": 1.84},
    ];

    return Scaffold(
      appBar: AppBar(title: Text("")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Título centrado
            Text(
              expense["title"],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),

            // Fecha centrada
            Text(
              formattedDate,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 30),

            // Card con quien pagó y cantidad en rojo
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Pagado por:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                title: Text(
                  expense["buyer"],
                  style: const TextStyle(fontSize: 20),
                ),
                trailing: Text(
                  "${expense["amount"].toStringAsFixed(2)} €",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Participantes:",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 12),

            // Lista de participantes
            Expanded(
              child: ListView.builder(
                itemCount: participants.length,
                itemBuilder: (context, index) {
                  final p = participants[index];
                  return Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      title: Text(
                        p["name"],
                        style: const TextStyle(fontSize: 20),
                      ),
                      trailing: Text(
                        "${p["amount"].toStringAsFixed(2)} €",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
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

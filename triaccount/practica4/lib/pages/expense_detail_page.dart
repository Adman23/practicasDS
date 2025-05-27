import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/expense.dart';

class ExpenseDetailPage extends StatelessWidget {
  final Expense expense;

  ExpenseDetailPage({required this.expense});

  @override
  Widget build(BuildContext context) {
    // Formatea la fecha en español
    final formattedDate = DateFormat("d 'de' MMMM 'de' y", 'es_ES').format(expense.date);

    return Scaffold(
      appBar: AppBar(title: Text("")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Título del gasto
            Text(
              expense.title, // Nombre del gasto
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),

            // Fecha del gasto
            Text(
              formattedDate,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 30),

            // Etiqueta Comprador
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Pagado por:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),

            // Tarjeta que muestra el comprador y el coste del gasto
            Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                title: Text(
                  expense.buyer.username!, // Nombre del comprador
                  style: const TextStyle(fontSize: 20),
                ),
                trailing: Text(
                  "${expense.cost.toStringAsFixed(2)} €", // Monto pagado
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Etiqueta Participantes
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Participantes:",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 12),

            // Lista de participantes que deben parte del gasto
            Expanded(
              child: ListView.builder(
                itemCount: expense.participants.length, // Cantidad de participantes
                itemBuilder: (context, index) {
                  final p = expense.participants.keys.elementAt(index); // Nombre del participante
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
                        p, // Nombre del participante
                        style: const TextStyle(fontSize: 20),
                      ),
                      trailing: Text(
                        "${expense.participants[p]?.toStringAsFixed(2)} €", // Cantidad que debe
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

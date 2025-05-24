import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'expense_detail_page.dart';
import 'add_expense_page.dart';

class GroupPage extends StatefulWidget {
  final String groupName;

  GroupPage({required this.groupName});

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> dummyExpenses = [
    {"title": "Aceite", "buyer": "Imma", "amount": 5.5, "date": DateTime(2025, 2, 17)},
    {"title": "Arroz", "buyer": "Antonio", "amount": 2.1, "date": DateTime(2025, 2, 17)},
    {"title": "Fideos", "buyer": "Izaro", "amount": 3.0, "date": DateTime(2025, 2, 16)},
    {"title": "Tomate", "buyer": "Fernando", "amount": 1.5, "date": DateTime(2025, 2, 16)},
    {"title": "Bolígrafos", "buyer": "Andres", "amount": 4.2, "date": DateTime(2025, 5, 24)},
  ];

  final List<Map<String, dynamic>> dummyBalances = [
    {"name": "Imma", "amount": 17.0},
    {"name": "Andres", "amount": -5.0},
    {"name": "Antonio", "amount": -6.0},
    {"name": "Izaro", "amount": -6.0},
  ];

  double get totalAmount => dummyExpenses.fold(0.0, (sum, item) => sum + item["amount"]);

  Map<String, List<Map<String, dynamic>>> get expensesGroupedByDate {
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var expense in dummyExpenses) {
      DateTime date = expense["date"];
      String formattedDate = DateFormat("d 'de' MMMM 'de' y", 'es_ES').format(date);
      grouped.putIfAbsent(formattedDate, () => []).add(expense);
    }

    return Map.fromEntries(
      grouped.entries.toList()
        ..sort((a, b) {
          DateTime dateA = dummyExpenses.firstWhere((e) =>
          DateFormat("d 'de' MMMM 'de' y", 'es_ES').format(e["date"]) == a.key)["date"];
          DateTime dateB = dummyExpenses.firstWhere((e) =>
          DateFormat("d 'de' MMMM 'de' y", 'es_ES').format(e["date"]) == b.key)["date"];
          return dateB.compareTo(dateA);
        }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Gastos'),
              Tab(text: 'Saldos'),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.teal[800],
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text(
                  "Gastos Totales: ${totalAmount.toStringAsFixed(2)} €",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // TAB 1 - GASTOS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView(
                      children: expensesGroupedByDate.entries.map((entry) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...entry.value.map((expense) {
                              return Card(
                                color: Colors.grey[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                elevation: 3,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  title: Text(
                                    expense["title"],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text("Pagado por: ${expense["buyer"]}"),
                                  trailing: Text(
                                    "${expense["amount"].toStringAsFixed(2)} €",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ExpenseDetailPage(expense: expense),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  // TAB 2 - SALDOS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                    child: ListView.builder(
                      itemCount: dummyBalances.length,
                      itemBuilder: (context, index) {
                        final person = dummyBalances[index];
                        final double amount = person["amount"];
                        final bool isPositive = amount >= 0;

                        return Card(
                          color: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            title: Text(
                              person["name"],
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            trailing: Text(
                              "${isPositive ? '+' : '-'}${amount.abs().toStringAsFixed(2)} €",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isPositive ? Colors.green : Colors.red,
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
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            List<String> groupUsers =
            dummyBalances.map((e) => e["name"].toString()).toList();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddExpensePage(
                  groupName: widget.groupName,
                  groupUsers: groupUsers,
                ),
              ),
            );
          },
          backgroundColor: Colors.grey[900],
          child: const Icon(Icons.add, size: 32),
          shape: const CircleBorder(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

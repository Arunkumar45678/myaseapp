import 'package:flutter/material.dart';
import '../widgets/dashboard_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: List.generate(8, (i) {
            return DashboardCard(
              icon: Icons.widgets,
              title: "Card ${i + 1}",
              subtitle: "Sample data",
              onTap: () {},
            );
          }),
        ),
      ),
    );
  }
}

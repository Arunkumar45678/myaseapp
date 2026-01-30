import 'package:flutter/material.dart';
import '../widgets/dashboard_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: List.generate(8, (i) {
        return DashboardCard(
          icon: Icons.widgets,
          title: "Card ${i + 1}",
          subtitle: "Sample",
          onTap: () {},
        );
      }),
    );
  }
}

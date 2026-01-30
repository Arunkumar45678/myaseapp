import 'package:flutter/material.dart';
import '../widgets/dashboard_card.dart';
import 'dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ASE"),
      ),

      drawer: Drawer(
        child: ListView(
          children: const [
            DrawerHeader(
              child: Text("ASE Menu"),
            ),
            ListTile(title: Text("Home")),
            ListTile(title: Text("Profile")),
            ListTile(title: Text("Settings")),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [

            DashboardCard(
              icon: Icons.info,
              title: "About Us",
              subtitle: "Association info",
              onTap: () => openDashboard(),
            ),

            DashboardCard(
              icon: Icons.group,
              title: "Teams",
              subtitle: "Units",
              onTap: () => openDashboard(),
            ),

            DashboardCard(
              icon: Icons.newspaper,
              title: "News",
              subtitle: "Updates",
              onTap: () => openDashboard(),
            ),

            DashboardCard(
              icon: Icons.event,
              title: "Events",
              subtitle: "Programs",
              onTap: () => openDashboard(),
            ),

            DashboardCard(
              icon: Icons.poll,
              title: "Poll",
              subtitle: "Vote",
              onTap: () => openDashboard(),
            ),

            DashboardCard(
              icon: Icons.emoji_events,
              title: "Awards",
              subtitle: "Recognitions",
              onTap: () => openDashboard(),
            ),

            DashboardCard(
              icon: Icons.person,
              title: "Profile",
              subtitle: "Account",
              onTap: () => openDashboard(),
            ),

            DashboardCard(
              icon: Icons.settings,
              title: "Settings",
              subtitle: "Preferences",
              onTap: () => openDashboard(),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        selectedItemColor: const Color(0xFF146FC9),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  void openDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }
}

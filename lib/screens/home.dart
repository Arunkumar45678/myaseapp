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
        title: const Text(
          "ASE",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C1C1C),
          ),
        ),
        backgroundColor: const Color(0xFFE3F2FD), // Light blue
        elevation: 2,
        iconTheme: const IconThemeData(color: Color(0xFF4CAF50)), // Light green drawer icon
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
            color: const Color(0xFF4CAF50),
          ),
        ],
      ),

      drawer: Drawer(
        backgroundColor: const Color(0xFFE3F2FD), // Light blue
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            Container(
              height: 180,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50), // Light green header
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "ASE Menu",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Menu Items
            _buildDrawerItem(
              icon: Icons.home,
              title: "Home",
              onTap: () {},
              isSelected: true,
            ),
            _buildDrawerItem(
              icon: Icons.person,
              title: "Profile",
              onTap: () {},
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              title: "Settings",
              onTap: () {},
            ),
            _buildDrawerItem(
              icon: Icons.help,
              title: "Help & Support",
              onTap: () {},
            ),
            _buildDrawerItem(
              icon: Icons.logout,
              title: "Logout",
              onTap: () {},
            ),
          ],
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F9FF),
              Color(0xFFE3F2FD),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
            children: [
              DashboardCard(
                icon: Icons.info,
                title: "About Us",
                subtitle: "Association information",
                onTap: () => openDashboard(),
                colorIndex: 0,
              ),

              DashboardCard(
                icon: Icons.group,
                title: "Teams",
                subtitle: "Units and groups",
                onTap: () => openDashboard(),
                colorIndex: 1,
              ),

              DashboardCard(
                icon: Icons.newspaper,
                title: "News",
                subtitle: "Latest updates",
                onTap: () => openDashboard(),
                colorIndex: 2,
              ),

              DashboardCard(
                icon: Icons.event,
                title: "Events",
                subtitle: "Upcoming programs",
                onTap: () => openDashboard(),
                colorIndex: 3,
              ),

              DashboardCard(
                icon: Icons.poll,
                title: "Poll",
                subtitle: "Vote now",
                onTap: () => openDashboard(),
                colorIndex: 0,
              ),

              DashboardCard(
                icon: Icons.emoji_events,
                title: "Awards",
                subtitle: "Recognitions",
                onTap: () => openDashboard(),
                colorIndex: 1,
              ),

              DashboardCard(
                icon: Icons.person,
                title: "Profile",
                subtitle: "Account details",
                onTap: () => openDashboard(),
                colorIndex: 2,
              ),

              DashboardCard(
                icon: Icons.settings,
                title: "Settings",
                subtitle: "Preferences",
                onTap: () => openDashboard(),
                colorIndex: 3,
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD), // Light blue
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
          border: const Border(
            top: BorderSide(
              color: Color(0xFF4CAF50), // Light green accent
              width: 2,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (i) => setState(() => index = i),
          backgroundColor: const Color(0xFFE3F2FD), // Light blue
          selectedItemColor: const Color(0xFF4CAF50), // Light green
          unselectedItemColor: Colors.blueGrey[600],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: "About",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: "Events",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: openDashboard,
        backgroundColor: const Color(0xFF4CAF50), // Light green
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.dashboard),
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : const Color(0xFF4CAF50),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFF4CAF50) : Colors.blueGrey[800],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
      tileColor: isSelected ? Colors.white.withOpacity(0.5) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
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

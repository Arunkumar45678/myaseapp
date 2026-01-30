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
              onTap

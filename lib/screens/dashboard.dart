import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/dashboard_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final supabase = Supabase.instance.client;
  final PageController _pageController = PageController();

  int currentPage = 0;
  Timer? _timer;

  String userName = "";
  String username = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  /* ---------------- AUTO SLIDE ---------------- */
  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        currentPage = (currentPage + 1) % 3;
        _pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /* ---------------- LOAD USER DATA ---------------- */
  Future<void> _loadUserData() async {
    final user = supabase.auth.currentUser;

    if (user == null) return;

    final res = await supabase
        .from('user_profiles')
        .select('name, username')
        .eq('id', user.id)
        .single();

    setState(() {
      userName = res['name'] ?? "";
      username = res['username'] ?? "";
    });
  }

  /* ---------------- UI ---------------- */
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 USER INFO
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName.isEmpty ? "Loading..." : userName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          /// 🔹 CAROUSEL
          SizedBox(
            height: 180,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => currentPage = index);
              },
              children: [
                _carouselImage("assets/images/slide1.jpg"),
                _carouselImage("assets/images/slide2.jpg"),
                _carouselImage("assets/images/slide3.jpg"),
              ],
            ),
          ),

          /// 🔹 DOT INDICATORS
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentPage == index ? 12 : 8,
                height: currentPage == index ? 12 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPage == index
                      ? Colors.blue
                      : Colors.grey.shade400,
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          /// 🔹 DASHBOARD GRID
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _carouselImage(String path) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          path,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

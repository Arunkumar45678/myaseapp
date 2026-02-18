import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/dashboard_card.dart';
import '../services/session_service.dart';

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

  String fullName = "";
  String username = "";

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
    _loadUser();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  /* ---------------- AUTO SLIDE ---------------- */
  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_pageController.hasClients) {
        currentPage = (currentPage + 1) % 3;
        _pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /* ---------------- LOAD USER ---------------- */
  Future<void> _loadUser() async {
    String? uid;

    // 1️⃣ Google login user
    final authUser = supabase.auth.currentUser;
    if (authUser != null) {
      uid = authUser.id;
    }

    // 2️⃣ Manual login stored session
    uid ??= await SessionService.getUid();

    if (uid == null) return;

    try {
      final res = await supabase
          .from('user_profiles')
          .select('full_name, username')
          .eq('id', uid)
          .maybeSingle();

      if (res != null) {
        setState(() {
          fullName = res['full_name'] ?? "";
          username = res['username'] ?? "";
        });
      }
    } catch (e) {
      debugPrint("Dashboard user load error: $e");
    }
  }

  /* ---------------- UI ---------------- */
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 NAME HEADER
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName.isEmpty ? "Loading..." : fullName,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  username,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          /// 🔹 CAROUSEL
          SizedBox(
            height: 180,
            child: PageView(
              controller: _pageController,
              onPageChanged: (i) => setState(() => currentPage = i),
              children: const [
                _CarouselImage("assets/images/slide1.jpg"),
                _CarouselImage("assets/images/slide2.jpg"),
                _CarouselImage("assets/images/slide3.jpg"),
              ],
            ),
          ),

          /// 🔹 DOTS
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentPage == i ? 12 : 8,
                height: currentPage == i ? 12 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      currentPage == i ? Colors.blue : Colors.grey.shade400,
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          /// 🔹 GRID
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
}

/* ---------------- CAROUSEL IMAGE ---------------- */
class _CarouselImage extends StatelessWidget {
  final String path;
  const _CarouselImage(this.path);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(path, fit: BoxFit.cover),
      ),
    );
  }
}

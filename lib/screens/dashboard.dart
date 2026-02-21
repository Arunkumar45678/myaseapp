import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/dashboard_card.dart';

class DashboardScreen extends StatefulWidget {
  final String uid;
  const DashboardScreen({super.key, required this.uid});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final supabase = Supabase.instance.client;
  final PageController _pageController = PageController();

  int currentPage = 0;
  Timer? _timer;

  String name = "";
  String username = "";

  bool loaded = false;
  String debugMsg = "";

  @override
  void initState() {
    super.initState();
    _loadUser();
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
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
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

  /* ---------------- LOAD USER ---------------- */
  Future<void> _loadUser() async {

    debugMsg = "UID RECEIVED = ${widget.uid}\n";

    try {

      final res = await supabase
          .from('user_profiles')
          .select('full_name, username')
          .eq('id', widget.uid)
          .maybeSingle();

      debugMsg += "QUERY RESULT = $res\n";

      if(res != null){
        name = res['full_name'] ?? "";
        username = res['username'] ?? "";
      } else {
        debugMsg += "NO USER FOUND IN DB\n";
      }

    } catch(e){
      debugMsg += "ERROR = $e\n";
    }

    setState(()=>loaded=true);
  }

  /* ---------------- UI ---------------- */
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔴 DEBUG PANEL (REMOVE LATER)
          Container(
            width: double.infinity,
            color: Colors.black,
            padding: const EdgeInsets.all(10),
            child: Text(
              debugMsg.isEmpty ? "DEBUG WAITING..." : debugMsg,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),

          /// USER NAME DISPLAY
          Padding(
            padding: const EdgeInsets.all(16),
            child: loaded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.isEmpty ? "Name missing" : name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(username),
                    ],
                  )
                : const CircularProgressIndicator(),
          ),

          /// CAROUSEL
          SizedBox(
            height: 180,
            child: PageView(
              controller: _pageController,
              onPageChanged: (i)=>setState(()=>currentPage=i),
              children: [
                _img("assets/images/slide1.jpg"),
                _img("assets/images/slide2.jpg"),
                _img("assets/images/slide3.jpg"),
              ],
            ),
          ),

          /// DOTS
          const SizedBox(height:10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3,(i)=>Container(
              margin: const EdgeInsets.symmetric(horizontal:4),
              width: currentPage==i?12:8,
              height: currentPage==i?12:8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentPage==i?Colors.blue:Colors.grey,
              ),
            )),
          ),

          const SizedBox(height:20),

          /// DASHBOARD GRID
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:16),
            child: GridView.count(
              shrinkWrap:true,
              physics:const NeverScrollableScrollPhysics(),
              crossAxisCount:2,
              crossAxisSpacing:16,
              mainAxisSpacing:16,
              children: List.generate(8,(i)=>DashboardCard(
                icon: Icons.widgets,
                title: "Card ${i+1}",
                subtitle: "Sample",
                onTap: (){},
              )),
            ),
          ),

          const SizedBox(height:20),
        ],
      ),
    );
  }

  Widget _img(String p){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(p,fit:BoxFit.cover),
      ),
    );
  }
}

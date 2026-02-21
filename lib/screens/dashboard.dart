import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/dashboard_card.dart';

class DashboardScreen extends StatefulWidget {
  final String uid;
  const DashboardScreen({super.key, required this.uid});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final PageController _pageController = PageController();
  int currentPage = 0;
  Timer? _timer;

  @override
  void initState(){
    super.initState();
    _timer = Timer.periodic(const Duration(seconds:3),(timer){
      if(_pageController.hasClients){
        currentPage=(currentPage+1)%3;
        _pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds:500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose(){
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        children:[

          const SizedBox(height:16),

          /// CAROUSEL
          SizedBox(
            height:180,
            child:PageView(
              controller:_pageController,
              onPageChanged:(i)=>setState(()=>currentPage=i),
              children:[
                _img("assets/images/slide1.jpg"),
                _img("assets/images/slide2.jpg"),
                _img("assets/images/slide3.jpg"),
              ],
            ),
          ),

          /// DOTS
          const SizedBox(height:10),
          Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children:List.generate(3,(i)=>Container(
              margin:const EdgeInsets.symmetric(horizontal:4),
              width:currentPage==i?12:8,
              height:currentPage==i?12:8,
              decoration:BoxDecoration(
                shape:BoxShape.circle,
                color:currentPage==i?Colors.blue:Colors.grey.shade400,
              ),
            )),
          ),

          const SizedBox(height:20),

          /// GRID
          Padding(
            padding:const EdgeInsets.symmetric(horizontal:16),
            child:GridView.count(
              shrinkWrap:true,
              physics:const NeverScrollableScrollPhysics(),
              crossAxisCount:2,
              crossAxisSpacing:16,
              mainAxisSpacing:16,
              children:List.generate(8,(i)=>DashboardCard(
                icon:Icons.widgets,
                title:"Card ${i+1}",
                subtitle:"Sample",
                onTap:(){},
              )),
            ),
          ),

          const SizedBox(height:20),
        ],
      ),
    );
  }

  Widget _img(String p)=>Padding(
    padding:const EdgeInsets.symmetric(horizontal:16),
    child:ClipRRect(
      borderRadius:BorderRadius.circular(16),
      child:Image.asset(p,fit:BoxFit.cover),
    ),
  );
}

import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/dashboard_card.dart';

class DashboardScreen extends StatefulWidget{
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState()=>_DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>{

  final PageController _controller=PageController();
  int page=0;
  Timer? timer;

  @override
  void initState(){
    super.initState();
    timer=Timer.periodic(const Duration(seconds:3),(t){
      if(_controller.hasClients){
        page=(page+1)%3;
        _controller.animateToPage(page,
            duration:const Duration(milliseconds:500),
            curve:Curves.easeInOut);
      }
    });
  }

  @override
  void dispose(){
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child:Column(
        children:[

          const SizedBox(height:16),

          SizedBox(
            height:180,
            child:PageView(
              controller:_controller,
              onPageChanged:(i)=>setState(()=>page=i),
              children:[
                _img("assets/images/slide1.jpg"),
                _img("assets/images/slide2.jpg"),
                _img("assets/images/slide3.jpg"),
              ],
            ),
          ),

          const SizedBox(height:10),

          Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children:List.generate(3,(i){
              return Container(
                margin:const EdgeInsets.symmetric(horizontal:4),
                width:page==i?12:8,
                height:page==i?12:8,
                decoration:BoxDecoration(
                    shape:BoxShape.circle,
                    color:page==i?Colors.blue:Colors.grey),
              );
            }),
          ),

          const SizedBox(height:20),

          Padding(
            padding:const EdgeInsets.symmetric(horizontal:16),
            child:GridView.count(
              shrinkWrap:true,
              physics:const NeverScrollableScrollPhysics(),
              crossAxisCount:2,
              crossAxisSpacing:16,
              mainAxisSpacing:16,
              children:List.generate(8,(i){
                return DashboardCard(
                  icon:Icons.widgets,
                  title:"Card ${i+1}",
                  subtitle:"Sample",
                  onTap(){},
                );
              }),
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

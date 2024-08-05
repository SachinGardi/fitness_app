
import 'dart:convert';

import 'package:fitness_app/prasentation/resources/mediaquery.dart';
import 'package:fitness_app/prasentation/video_Info_dart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../prasentation/resources/colors_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  bool _isLoading = true;

  List homeInfo = [];
  init()async{
    await DefaultAssetBundle.of(context).loadString('assets/json/homeinfo.json').then((value) {
    
        homeInfo = jsonDecode(value);
        Future.delayed(const Duration(seconds: 3),(){
          setState(() {
            _isLoading = false;
          });

        });

    });
    print(homeInfo.length);
  }


  @override
  void initState() {
    init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title:  const Padding(
            padding: EdgeInsets.only(left: 3, right: 3),
            child: Row(
              children: [
                Text(
                  'Training',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: ColorManager.black,
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 20,
                  color: ColorManager.black,
                ),
              ],
            ),
          ),
        ),
        body: _isLoading?Center(
          child: Container(
            height: 80,
            width: 80,
            decoration:  BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.shadowColor,
                  blurRadius: 5,
                  offset: Offset(0, 2)
                )
              ]
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: ColorManager.deepPurpleAccent,
              ),
            ),
          ),
        ):SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Column(
                  children: [
                     Row(
                      children: [
                        const Text(
                          'Your program',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        const Text(
                          'Details',
                          style: TextStyle(fontSize: 16, color: ColorManager.blue),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(

                          borderRadius: BorderRadius.circular(10),
                          onTap: () => Get.to(()=> const VideoInfo()),
                          child: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 10,
                            child: Icon(
                              Icons.arrow_forward,
                              size: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: context.mediaQueryHeight * 0.24,
                      width: context.mediaQueryWidth,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(55)),
                          gradient: LinearGradient(
                            colors: [
                              ColorManager.blue,
                              ColorManager.deepPurpleAccent.withOpacity(0.9)
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: ColorManager.blue.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(5, 10))
                          ]),
                      child:  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Next Workout',
                              style:
                              TextStyle(fontSize: 12, color: ColorManager.white),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Legs Tonight \nand Glutes Workout',
                              style:
                              TextStyle(fontSize: 20, color: ColorManager.white),
                            ),
                            const Spacer(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.alarm,
                                      size: 15,
                                      color: ColorManager.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '60 min',
                                      style: TextStyle(
                                          color: ColorManager.white, fontSize: 9),
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(55),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: ColorManager.shadowColor,
                                            offset: Offset(4, 8),
                                            blurRadius: 15
                                        )
                                      ]
                                  ),
                                  child: const Icon(
                                    Icons.play_circle_fill,
                                    size: 55,
                                    color: ColorManager.white,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 180,
                      width: context.mediaQueryWidth,
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            width: context.mediaQueryWidth,
                            height: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: const DecorationImage(image: NetworkImage('https://marketplace.canva.com/EAFl-yMEfZM/1/0/1600w/canva-dark-blue-and-orange-modern-workout-fitness-email-header-k6wsQ2a4hjU.jpg',),fit: BoxFit.fill),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorManager.deepPurpleAccent.withOpacity(0.3),
                                    blurRadius: 40,
                                    offset:const Offset(8, 10),
                                  ),   BoxShadow(
                                    color: ColorManager.deepPurpleAccent.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset:const Offset(-1, -5),
                                  )
                                ]
                            ),
                          ),

                        ],
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Area of focus',style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: ColorManager.black
                      ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    GridView.builder(
                      padding: const EdgeInsets.only(bottom: 10),
                      itemCount:homeInfo.length ,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemBuilder: (context, index) {
                        var item = homeInfo[index];
                        return Container(
                          decoration:  BoxDecoration(
                              color: ColorManager.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius:2,
                                    spreadRadius: 5
                                )
                              ],
                              borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                             Container(
                               height: context.mediaQueryHeight * 0.11,
                               decoration:  BoxDecoration(
                                 color: ColorManager.white,
                                 boxShadow: const [
                                   BoxShadow(
                                     color: ColorManager.grey,
                                     blurRadius: 5,
                                     offset: Offset(0, 2)
                                   )
                                 ],
                                 shape: BoxShape.circle,
                                 image: DecorationImage(image: AssetImage(item['img']))
                               ),
                             ),
                              const SizedBox(height: 10,),
                              Text(item['title'],style: TextStyle(
                                fontSize: context.mediaQueryWidth * 0.045,
                                fontWeight: FontWeight.w700
                              ),)
                            ],
                          ),

                        );
                      },
                    )
                  ],
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}

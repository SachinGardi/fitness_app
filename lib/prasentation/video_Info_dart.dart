import 'dart:convert';
import 'dart:math';
import 'package:dotted_line/dotted_line.dart';
import 'package:fitness_app/prasentation/resources/colors_manager.dart';
import 'package:fitness_app/prasentation/resources/mediaquery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoInfo extends StatefulWidget {
  const VideoInfo({super.key});

  @override
  State<VideoInfo> createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {


  var  onUpdateControllerTime;
  Duration? _duration;
  Duration? _position;
  var _progress = 0.0;

 List videoUrl = [];
  init()async{
    await DefaultAssetBundle.of(context).loadString('assets/json/video.json').then((value){
      setState(() {
        videoUrl = jsonDecode(value);
      });

    });
    print(videoUrl.length);

  }

  void _onControllerUpdate()async{
    if(_disposed){
      return;
    }
    onUpdateControllerTime = 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    if(onUpdateControllerTime > now){
      return;
    }
    onUpdateControllerTime = now + 500;
      final controller = _controller;
      if(controller == null){
        debugPrint('controller is null');
        return;
      }
      if(!controller.value.isInitialized){
      debugPrint('controller not initialized');
      return;
      }

      if(_duration == null){
        _duration = _controller!.value.duration;
      }
      var duration = _duration;
      if(duration == null) return;

      var position = await _controller!.position;
      _position = position;
      final playing = controller.value.isPlaying;
      if(playing){
        _duration = _controller!.value.duration;
        if(_disposed) return;
        setState(() {
          _progress = _position!.inMilliseconds.ceilToDouble()/ duration.inMilliseconds.ceilToDouble();
        });
      }
      _isPlaying = playing;
  }

  Widget _listview(){
    return ListView.builder(
      itemCount: videoUrl.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
              _onTapVideo(index);
              if(!_playArea){
                setState(() {
                  _playArea = true;
                });
              }

          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image:  DecorationImage(image: NetworkImage(videoUrl[index]['thumbnail']),fit: BoxFit.cover)
                    ),
                    child: const Icon(Icons.play_circle,color: Colors.white,),
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(videoUrl[index]['title'],style: TextStyle(
                          fontSize: context.mediaQueryWidth * 0.045,
                          fontWeight: FontWeight.w700
                      ),),
                      const SizedBox(height: 10,),
                      Text(videoUrl[index]['time'],style: TextStyle(
                          fontSize: context.mediaQueryWidth * 0.035,
                          color: ColorManager.grey
                      ),),
                    ],
                  )

                ],
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  Container(
                    height: context.mediaQueryHeight * 0.025,
                    width: context.mediaQueryWidth * 0.2,
                    decoration: BoxDecoration(
                        color: ColorManager.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text('15s rest',style: TextStyle(
                          fontSize: context.mediaQueryWidth * 0.03,
                          color: ColorManager.deepPurpleAccent
                      ),),
                    ),
                  ),
                  const Expanded(
                    child: DottedLine(
                      dashColor: ColorManager.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20,),
            ],
          ),
        );
      },);
  }
  bool _playArea = false;
  bool _isPlaying = false;
  bool _disposed = false;
  int _isPlayingIndex = -1;
   VideoPlayerController? _controller;
  Widget _playView(BuildContext context){
    final controller = _controller;
    if(controller != null && controller.value.isInitialized){
      return AspectRatio(
        aspectRatio: 16/9,
          child: VideoPlayer(controller),
      );
    }else{
        return const AspectRatio(
          aspectRatio: 16/9,
            child: Center(child: Text('Preparring ...',style: TextStyle(
              fontSize: 20,
              color: ColorManager.white
            ),)));
    }
  }


  String convertTo(int value){
    return value > 10 ? '$value':'0$value';
  }

  Widget _controlView(BuildContext context){
    final noMute = (_controller!.value.volume>0);
    final duration = _duration?.inSeconds??0;
    final head = _position?.inSeconds??0;
    final remained = max(0,duration - head);
    final minimum = convertTo(remained ~/60);
    final sec = convertTo(remained % 60);

    return Column(
      children: [
        SliderTheme(
            data: SliderTheme.of(context).copyWith(
                activeTrackColor: ColorManager.sliderActiveTrackerColor,
                inactiveTrackColor: ColorManager.inActiveTrackerColor,
                trackShape: const RoundedRectSliderTrackShape(),
                trackHeight: 2.0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                thumbColor: ColorManager.sliderThumbColor,
                overlayColor: ColorManager.sliderOverlayColor,
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
                tickMarkShape: const RoundSliderTickMarkShape(),
                activeTickMarkColor: ColorManager.activeTickMarkColor,
                inactiveTickMarkColor: ColorManager.inactiveTickMarkColor,
                valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: ColorManager.valueIndicatorColor,
                valueIndicatorTextStyle: const TextStyle(
                    color: ColorManager.white
                )

            ),
            child: Slider(
              value: max(0,min(_progress * 100, 100)),
              min: 0,
              max: 100,
              divisions: 100,
              label: _position?.toString().split(".")[0],
              onChanged: (value) {
                setState(() {
                  _progress = value * 0.01;
                });
              },

              onChangeStart: (value) {
                _controller!.pause();
              },
              onChangeEnd: (value) {
                final duration = _controller!.value.duration;
                if(duration != null){
                  var newValue = max(0, min(value, 99)) * 0.01;
                  var millis =(duration.inMilliseconds * newValue).toInt();
                  _controller?.seekTo(Duration(milliseconds: millis));
                  _controller?.play();
                }
              },
            )
        ),
        Container(
          width: context.mediaQueryWidth,
          margin: const EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  if(noMute){
                    _controller!.setVolume(0);
                  }
                  else{
                    _controller!.setVolume(1);
                  }
                  setState(() { });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 4.0,
                          color: ColorManager.shadowColor
                        )
                      ],
                    ),
                    child: Icon(noMute?Icons.volume_up:Icons.volume_off,size:20,color: ColorManager.white,),
                  ),
                ),
              ),
              IconButton(onPressed: (){
                final index = _isPlayingIndex - 1;
                if(index >= 0){
                  _onTapVideo(index);
                }
                else{
                  Get.snackbar('Video', 'No more video to play!');
                }
              }, icon: const Icon(Icons.fast_rewind,size: 25,color: ColorManager.white,)),
              const SizedBox(width: 10,),
              IconButton(onPressed: (){
                setState(() {
                  _isPlaying? _controller!.pause():_controller!.play();
                });
              }, icon:Icon(_isPlaying?Icons.pause:Icons.play_arrow,size: 25,color: ColorManager.white,)),
              const SizedBox(width: 10,),
              IconButton(onPressed: (){
                final index = _isPlayingIndex + 1;
                if(index< videoUrl.length){
                    _onTapVideo(index);
                }
                else{
                  Get.snackbar('Video', 'No more video to play!');
                }
              }, icon: const Icon(Icons.fast_forward,size: 25,color: ColorManager.white,)),
              Text('$minimum:$sec',style: TextStyle(
                color: ColorManager.white,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(0.0,1.0),
                    blurRadius: 4.0,
                    color:ColorManager.shadowColor
                  )
                ]
              ),)
            ],
          ),
        ),
      ],
    );
  }

  _onTapVideo(int index){
    final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl[index]['vUrl']));
    final oldController = _controller;

    if(oldController != null){
      oldController.removeListener(_onControllerUpdate);
      oldController.pause();
    }
    _controller = controller;
      setState(() {});
    controller.initialize().then((_){
      oldController?.dispose();
      _isPlayingIndex = index;
      controller.addListener(_onControllerUpdate);
        controller.play();
        setState(() {});
    });
  }


  @override
  void dispose() {
    _disposed = true;
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  void initState() {
    init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        decoration:  _playArea == false?BoxDecoration(
          gradient: LinearGradient(colors: [
            ColorManager.blue.withOpacity(0.9),
            ColorManager.deepPurpleAccent
          ],
          begin: const FractionalOffset(0.0, 0.4),
            end: Alignment.topRight
          )
        ):BoxDecoration(
          color: ColorManager.deepPurpleAccent.withOpacity(0.5)
        ),
        child: Column(
          children: [
            _playArea==false?Container(
              padding: const EdgeInsets.only(left: 25,right: 25,top: 60),
              height: context.mediaQueryHeight * 0.38,
              width: context.mediaQueryWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap:()=> Get.back(),
                          child: const Icon(Icons.arrow_back_ios,size: 20,color: ColorManager.white,)),
                      const Icon(Icons.info_outline,size: 20,color: ColorManager.white,),
                    ],
                  ),
                  const SizedBox(height: 30,),
                  const Text(
                    'Legs Tonight \nand Glutes Workout',
                    style:
                    TextStyle(fontSize: 20, color: ColorManager.white),
                  ),
                  const SizedBox(height: 30,),
                  Row(
                    children: [
                      Container(
                        height: context.mediaQueryHeight * 0.04,
                        width: context.mediaQueryWidth * 0.23,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.timer,size: 18,color: ColorManager.white,),
                            SizedBox(width: 8,),
                            Text('68 min',style: TextStyle(
                              color: ColorManager.white,
                              fontSize: 12
                            ),)
                          ],
                        ),
                      ),
                      const SizedBox(width: 30,),
                      Expanded(
                        child: Container(
                          height: context.mediaQueryHeight * 0.04,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.handyman_outlined,size: 18,color: ColorManager.white,),
                                SizedBox(width: 10,),
                                Text('Resistent band, kettebell',style: TextStyle(
                                  fontSize: 12,
                                  color: ColorManager.white
                                ),)
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ):Column(
              children: [
                Container(
                  height: 80,
                  padding: EdgeInsets.only(top: 20,left: 20,right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.arrow_back_ios,size: 20, color: ColorManager.white,),
                      ),
                      Icon(Icons.info_outline,size: 20,color: ColorManager.white,)
                    ],
                  ),
                ),
                _playView(context),
                _controlView(context)
              ],
            ),
            Expanded(child: Container(
              decoration: const BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(80))
              ),
              child:  Container(
                padding: const EdgeInsets.only(top: 25,left: 20,right: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Circuit 1 : Leg\'s Toning',style: TextStyle(
                          color: ColorManager.black,
                          fontSize: context.mediaQueryWidth * 0.05
                        ),),
                        const Spacer(),
                        const Icon(Icons.sync,size: 25,color: ColorManager.deepPurpleAccent,),
                        const SizedBox(width: 5,),
                        const Text('3 sets',style: TextStyle(
                          color: ColorManager.grey
                        ),),
                        const SizedBox(width: 10,),
                      ],
                    ),
                    Expanded(child: _listview())
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

}

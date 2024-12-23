import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone2/data/firebase_services/firestore.dart';
import 'package:video_player/video_player.dart';

class ReelEditeScreen extends StatefulWidget {
  File videoFile;
  ReelEditeScreen(this.videoFile, {super.key});

  @override
  State<ReelEditeScreen> createState() => _ReelEditeScreenState();
}

class _ReelEditeScreenState extends State<ReelEditeScreen> {
  final caption = TextEditingController();
  late VideoPlayerController controller;
  bool Loading = false;
  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {
          controller.setLooping(true);
          controller.setVolume(1.0);
          print('VIDEO IS GOING PLAY------------');
          controller.play();
          print('VIDEO SHOULD BE PLAYED------------');
        });
      });
  }
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    caption.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'New Reels',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child:Loading ? const Center(child: CircularProgressIndicator(color: Colors.black,)) : Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Container(
                    width: 270.w,
                    height: 420.h,
                    child: controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: VideoPlayer(controller),
                          )
                        : const CircularProgressIndicator(),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                SizedBox(
                  height: 60.h,
                  width: 280.w,
                  child: TextField(
                    controller: caption,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      hintText: 'Write a caption ...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 45.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        'Save draft',
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          Loading = true;
                        });
                        try {
                          final cloudinary =
                              CloudinaryPublic('dbnrlfylq', 'sotg4hri');
                          CloudinaryResponse response = await cloudinary.uploadFile(
                            CloudinaryFile.fromFile(widget.videoFile.path),
                          );
                          if (kDebugMode) {
                            print('Video reel uploaded: ${response.secureUrl}');
                          }
                          String Reels_Url = response.secureUrl;
                          await Firebase_Firestore().CreateReel(
                            video: Reels_Url,
                            caption: caption.text,
                          );
                          Navigator.of(context).pop();
                        } catch (e) {
                          if (kDebugMode) {
                            print('Error occure while posting reel video');
                          }
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 45.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          'Share',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

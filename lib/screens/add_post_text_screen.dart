import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone2/data/firebase_services/firestore.dart';
class AddPostTextScreen extends StatefulWidget {
  File _file;
  AddPostTextScreen(this._file,{super.key});

  @override
  State<AddPostTextScreen> createState() => _AddPostTextScreenState();
}

class _AddPostTextScreenState extends State<AddPostTextScreen> {
  final TextEditingController caption = TextEditingController();
  final TextEditingController location = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('New post',style: TextStyle(color: Colors.black),),
        actions: [
          Center(child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: InkWell(
                onTap: ()async{
                  setState(() {
                    isLoading = true;
                  });
                  final cloudinary = CloudinaryPublic('dbnrlfylq', 'sotg4hri');
                  CloudinaryResponse response = await cloudinary.uploadFile(
                    CloudinaryFile.fromFile(widget._file.path),
                  );
                  String post_url = response.secureUrl;
                  await Firebase_Firestore().CreateUser(
                    postImage: post_url,
                      caption: caption.text,
                      location: location.text,);
                  Navigator.of(context).pop();
                },
                child: Text('Share',style: TextStyle(color: Colors.blue,fontSize: 15.sp),)),
          )),
        ],
      ),
      body: SafeArea(child:
      isLoading ? const Center(child: CircularProgressIndicator(color: Colors.black,),) :
      Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
              child: Row(
                children: [
                  Container(
                    width: 65.w,
                    height: 65.h,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      image: DecorationImage(image: FileImage(widget._file),fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(width: 10.w,),
                  SizedBox(width: 280.w,height: 60.h,
                  child: TextField(
                    controller: caption,
                    decoration: const InputDecoration(
                      hintText: 'Write a caption ...',
                      border: InputBorder.none,
                    ),
                  ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: SizedBox(width: 280.w,height: 30.h,
                child: TextField(
                  controller: location,
                  decoration: const InputDecoration(
                    hintText: 'Add location',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

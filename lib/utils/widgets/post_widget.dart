import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 375.w,
          height: 54.h,
          color: Colors.white,
          child: ListTile(
            leading: ClipOval(
              child: SizedBox(
                height: 35.h,
                width: 35.w,
                child: Image.asset('images/person.png'),
              ),
            ),
            title: Text(
              'Username',
              style: TextStyle(fontSize: 13.2.sp, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Location',
              style: TextStyle(
                fontSize: 11.2.sp,
              ),
            ),
            trailing: const Icon(Icons.more_horiz),
          ),
        ),
        SizedBox(
          width: 375.w,
          height: 375.h,
          child: Image.asset(
            'images/post.jpg',
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: 14.h,
        ),
        Container(
          width: 375.w,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: 14.w,
              ),
              Icon(
                Icons.favorite_outline,
                size: 25.w,
              ),
              SizedBox(
                width: 17.w,
              ),
              Image.asset(
                'images/comment.webp',
                height: 28.h,
              ),
              SizedBox(
                width: 17.w,
              ),
              Image.asset(
                'images/send.jpg',
                height: 28.h,
              ),
              const Spacer(),
              Image.asset(
                'images/save.png',
                height: 28.h,
              ),
              SizedBox(
                width: 13.w,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 19.w, top: 13.5.h, bottom: 5.h),
          child: Text(
            '0',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            children: [
              Text(
                'username' + '  ',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
              ),
              Text(
                'caption' + '',
                style: TextStyle(fontSize: 13.sp),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.w, top: 20.h, bottom: 8.h),
          child: Text(
            'dateformat',
            style: TextStyle(fontSize: 11.sp, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

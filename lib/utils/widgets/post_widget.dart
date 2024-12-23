import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone2/data/firebase_services/firestore.dart';
import 'package:insta_clone2/utils/widgets/cached_image.dart';
import 'package:insta_clone2/utils/widgets/comment.dart';
import 'package:insta_clone2/utils/widgets/like_animation.dart';

class PostWidget extends StatefulWidget {
  final Map<String, dynamic> snapshot;
  PostWidget(this.snapshot, {super.key});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  bool isAnimating = false;
  String user = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    user = _auth.currentUser!.uid;
  }

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
                child: CachedImage(widget.snapshot['profileImage']),
              ),
            ), //Image.asset('images/person.png')
            title: Text(
              widget.snapshot['username'],
              style: TextStyle(fontSize: 13.2.sp, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              widget.snapshot['location'],
              style: TextStyle(
                fontSize: 11.2.sp,
              ),
            ),
            trailing: user == widget.snapshot['uid']
                ? GestureDetector(
                    onTap: () async {
                      final RenderBox overlay = Overlay.of(context)!
                          .context
                          .findRenderObject() as RenderBox;

                      final RelativeRect position = RelativeRect.fromLTRB(
                        (overlay.size.width - 180) / 2,
                        (overlay.size.height - 70) / 2,
                        (overlay.size.width - 200) / 2,
                        (overlay.size.height - 50) /
                            2,
                      );

                      final result = await showMenu(
                        context: context,
                        position: position,
                        items: [
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: GestureDetector(
                              onTap: () {
                                FirebaseFirestore.instance.collection('posts').doc(widget.snapshot['postId']).delete();
                                FirebaseFirestore.instance.collection(widget.snapshot['postId']);
                                setState(() {});
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding:  EdgeInsets.symmetric(vertical: 10.h),
                                alignment: Alignment.center,
                                child: Text(
                                  'Delete',
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                      if (result != null) {
                        if (kDebugMode) {
                          print('Menu action: $result');
                        }
                      }
                    },
                    child: const Icon(Icons.more_horiz),
                  )
                : const SizedBox(),
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            Firebase_Firestore().like(
              like: widget.snapshot['like'],
              type: 'posts',
              uid: user,
              postId: widget.snapshot['postId'],
            );
            setState(() {
              isAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 375.w,
                height: 375.h,
                child: CachedImage(
                  widget.snapshot['postImage'],
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isAnimating ? 1 : 0,
                child: LikeAnimation(
                  child: Icon(
                    widget.snapshot['like'].contains(user)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 100.w,
                    color: !widget.snapshot['like'].contains(user)
                        ? Colors.grey
                        : Colors.redAccent,
                  ),
                  isAnimating: isAnimating,
                  iconlike: false,
                  End: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        isAnimating = false;
                      });
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 375.w,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: 14.w,
              ),
              LikeAnimation(
                child: IconButton(
                  onPressed: () {
                    Firebase_Firestore().like(
                      like: widget.snapshot['like'],
                      type: 'posts',
                      uid: user,
                      postId: widget.snapshot['postId'],
                    );
                  },
                  icon: Icon(
                    widget.snapshot['like'].contains(user)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.snapshot['like'].contains(user)
                        ? Colors.redAccent
                        : Colors.black,
                    size: 24.w,
                  ),
                ),
                isAnimating: widget.snapshot['like'].contains(user),
                iconlike: true,
              ),
              SizedBox(
                width: 17.w,
              ),
              GestureDetector(
                onTap: () {
                  showBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: DraggableScrollableSheet(
                          maxChildSize: 0.6,
                          initialChildSize: 0.6,
                          minChildSize: 0.2,
                          builder: (context, scrollController) {
                            return Comment('posts', widget.snapshot['postId']);
                          },
                        ),
                      );
                    },
                  );
                },
                child: Image.asset(
                  'images/comment.webp',
                  height: 28.h,
                ),
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
          padding: EdgeInsets.only(left: 30.w, top: 1.h, bottom: 5.h),
          child: Text(
            widget.snapshot['like'].length.toString(),
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            children: [
              Text(
                widget.snapshot['username'] + '  ',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.sp),
              ),
              Text(
                widget.snapshot['caption'] + '',
                style: TextStyle(fontSize: 13.sp),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.w, top: 8.h, bottom: 8.h),
          child: Text(
            formatDate(
                widget.snapshot['time'].toDate(), [yyyy, '-', mm, '-', dd]),
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone2/screens/add_post_screen.dart';
import 'package:insta_clone2/screens/add_reel_screen.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

int _currentIndex = 0;

class _AddScreenState extends State<AddScreen> {
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  onPageChange(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
              controller: pageController,
              onPageChanged: onPageChange,
              children: const [
                AddPostScreen(),
                AddReelScreen(),
              ],
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              bottom: 10.h,
              right: _currentIndex == 0 ? 100.w : 150.w,
              child: Container(
                height: 30.h,
                width: 150.w,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: (){
                        navigationTapped(0);
                      },
                      child: Text(
                        'Post',
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color:
                                _currentIndex == 0 ? Colors.white : Colors.grey),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        navigationTapped(1);
                      },
                      child: Text(
                        'Reel',
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color:
                                _currentIndex == 1 ? Colors.white : Colors.grey),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

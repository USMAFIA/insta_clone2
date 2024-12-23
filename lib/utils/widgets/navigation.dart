import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone2/screens/explore.dart';
import 'package:insta_clone2/screens/home.dart';
import 'package:insta_clone2/screens/profile_screen.dart';
import 'package:insta_clone2/screens/reels_screen.dart';

import '../../screens/add_screen.dart';

class Navigations extends StatefulWidget {
  const Navigations({super.key});

  @override
  State<Navigations> createState() => _NavigationsState();
}

int _currentIndex = 0;

class _NavigationsState extends State<Navigations> {
  late PageController pageController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _currentIndex = 0;
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: navigationTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[500],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home,size: 25,), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search,size: 25,), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle,size: 25,),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.movie_filter,size: 25,), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person,size: 25,), label: ''),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChange,
        children: [
          const Home(),
          const ExploreScreen(),
          const AddScreen(),
          const ReelsScreen(),
          ProfileScreen(
            Uid: _auth.currentUser!.uid,
          ),
        ],
      ),
    );
  }
}

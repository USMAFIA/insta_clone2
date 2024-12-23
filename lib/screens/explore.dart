import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_clone2/screens/post_screen.dart';
import 'package:insta_clone2/screens/profile_screen.dart';
import 'package:insta_clone2/utils/widgets/cached_image.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController searchController = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool showUserSearchResults = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildSearchBox(),
            if (!showUserSearchResults) _buildPostsGrid(),
            if (showUserSearchResults) _buildUsersList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search User',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            setState(() {
              showUserSearchResults = value.trim().isNotEmpty;
            });
          },
        ),
      ),
    );
  }

  Widget _buildPostsGrid() {
    return StreamBuilder(
      stream: _firebaseFirestore
          .collection('posts')
          .where('postImage', isNull: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Text('No posts available'),
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return SliverGrid(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final snap = docs[index];
              final postImage = snap['postImage'] ??
                  'https://via.placeholder.com/150'; // Fallback image

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PostScreen(snap.data()),
                    ),
                  );
                },
                child: CachedImage(postImage),
              );
            },
            childCount: docs.length,
          ),
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: 3,
            mainAxisSpacing: 3,
            crossAxisSpacing: 3,
            pattern: const <QuiltedGridTile>[
              QuiltedGridTile(2, 1),
              QuiltedGridTile(2, 2),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUsersList() {
    return StreamBuilder(
      stream: _firebaseFirestore
          .collection('users')
          .where('username',
          isGreaterThanOrEqualTo: searchController.text.toLowerCase())
          .where('username',
          isLessThanOrEqualTo: '${searchController.text.toLowerCase()}\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Text('No users found'),
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final snap = docs[index];
              final profileImage = snap['profile'] ??
                  'https://via.placeholder.com/150'; // Fallback image
              final username = snap['username'] ?? 'No user';

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(Uid: snap.id),
                    ),
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 23.r,
                    backgroundImage: NetworkImage(profileImage),
                  ),
                  title: Text(username),
                ),
              );
            },
            childCount: docs.length,
          ),
        );
      },
    );
  }
}

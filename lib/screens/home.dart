import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/widgets/post_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List posts = [];
  @override
  Widget build(BuildContext context) {
    print('Widget Rebuild =====================>');
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: SizedBox(
              height: 28.h,
              width: 105.w,
              child: Image.asset('images/instagram.jpg')),
          leading: Image.asset('images/camera.jpg'),
          actions: [
            const Icon(
              Icons.favorite_border_sharp,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Image.asset('images/send.jpg'),
            ),
          ],
          elevation: 0,
          backgroundColor: const Color(0xffFAFAFA),
        ),
        body: CustomScrollView(
          slivers: [
            StreamBuilder(
              stream: _firebaseFirestore
                  .collection('posts')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                posts = snapshot.data?.docs ?? [];
                print('Snapshot Length ======> ${snapshot.data?.docs.length}');
                print('Posts Length ======> ${posts.length}');
                if (snapshot.data?.docs.isEmpty ?? false) {
                  return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return Container(
                        height: MediaQuery.of(context).size.height / 1.2,
                        alignment: Alignment.center,
                        child: const Center(
                          child: Text('No Posts Available'),
                        ));
                  }, childCount: 1));
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    print(
                        'the value of snapshot from home =============== ${snapshot.data}');
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data!.docs.isNotEmpty) {
                      posts = snapshot.data?.docs ?? [];
                      print('Posts Length =========>> ${posts.length}');
                      print(
                          'Snapshot Length =========>> ${snapshot.data?.docs.length}');
                      return PostWidget(
                        posts[index].data(),
                      );
                    }
                    return const Center(
                      child: Text('Some error occurred'),
                    );
                  },
                      childCount: snapshot.data == null
                          ? 0
                          : snapshot.data!.docs.length),
                );
              },
            ),
          ],
        )

        // body: posts.isNotEmpty
        //     ? CustomScrollView(
        //         slivers: [
        //           StreamBuilder(
        //             stream: _firebaseFirestore
        //                 .collection('posts')
        //                 .orderBy('time', descending: true)
        //                 .snapshots(),
        //             builder: (context, snapshot) {
        //               print('Snapshot Length ======> ${snapshot.data?.docs.length}');
        //               return SliverList(
        //                 delegate: SliverChildBuilderDelegate((context, index) {
        //                   print(
        //                       'the value of snapshot from home =============== ${snapshot.data}');
        //                   if (!snapshot.hasData) {
        //                     return const Center(
        //                       child: CircularProgressIndicator(),
        //                     );
        //                   }
        //                   if (snapshot.data!.docs.isNotEmpty) {
        //                     posts = snapshot.data?.docs ?? [];
        //                     print('Posts Length =========>> ${posts.length}');
        //                     print('Snapshot Length =========>> ${snapshot.data?.docs.length}');
        //                     return PostWidget(
        //                       posts[index].data(),
        //                     );
        //                   }
        //                   return const Center(
        //                     child: Text('Some error occurred'),
        //                   );
        //                 },
        //                     childCount: snapshot.data == null
        //                         ? 0
        //                         : snapshot.data!.docs.length),
        //               );
        //             },
        //           ),
        //         ],
        //       )
        //     : const Center(
        //         child: Text('No posts Available'),
        //       ),
        );
  }
}

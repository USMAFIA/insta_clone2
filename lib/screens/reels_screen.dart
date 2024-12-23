import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone2/utils/widgets/reel_item.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: [
          StreamBuilder(
              stream: _firestore
                  .collection('reels')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context,snapshot){
                return PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
                    controller: PageController(initialPage: 0,viewportFraction: 1),
                    itemBuilder: (context,index){
                      if(!snapshot.hasData){
                        return const CircularProgressIndicator();
                      }
                      return ReelsItem(snapshot.data!.docs[index].data());
                    },
                );
              }),
        ],
      )),
    );
  }
}

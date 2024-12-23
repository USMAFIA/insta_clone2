import 'package:flutter/material.dart';
import 'package:insta_clone2/utils/widgets/post_widget.dart';

class PostScreen extends StatelessWidget {
  final snapshot;
  const PostScreen(this.snapshot,{super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: PostWidget(snapshot)),
    );
  }
}

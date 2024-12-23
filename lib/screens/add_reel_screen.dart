import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone2/screens/reel_edite_screen.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io' as io;

class AddReelScreen extends StatefulWidget {
  const AddReelScreen({super.key});

  @override
  State<AddReelScreen> createState() => _AddReelScreenState();
}

class _AddReelScreenState extends State<AddReelScreen> {
  final List<Widget> _mediaList = [];
  final List<io.File> path = [];
  io.File? _file;
  int currentPage = 0;
  int? lastPage;

  Future<void> _fetchNewMedia() async {
    if (kDebugMode) {
      print('in _fetchNewMedia-----------');
    }
    lastPage = currentPage;

    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (kDebugMode) {
      print('getting permission-----------');
    }
    if (ps.isAuth) {
      if (kDebugMode) {
        print('in if statement checking for isAuth???????????');
      }

      final List<AssetPathEntity> album =
          await PhotoManager.getAssetPathList(type: RequestType.video);
      if (kDebugMode) {
        print('album is empty? ========>${album.isEmpty}');
      }
      if (album.isNotEmpty) {
        final List<AssetEntity> media =
            await album[0].getAssetListPaged(page: currentPage, size: 60);

        for (var asset in media) {
          if (asset.type == AssetType.video) {
            final file = await asset.file;
            if (file != null) {
              path.add(io.File(file.path));
              _file ??= path[0];
            } else {
              if (kDebugMode) {
                print('-----------file is null-----------');
              }
            }
          } else {
            if (kDebugMode) {
              print('-----------file has a different AssetType-----------');
            }
          }
        }

        List<Widget> temp = [];
        for (var asset in media) {
          temp.add(FutureBuilder(
            future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (asset.type == AssetType.video)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Container(
                            alignment: Alignment.center,
                            width: 42.w,
                            height: 15.h,
                            child: Row(
                              children: [
                                Text(
                                  asset.videoDuration.inMinutes.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                Text(
                                  ':' +
                                      asset.videoDuration.inSeconds.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }
              return Container(
                height: 20.w,
                width: 20.w,
                color: Colors.red,
              );
            },
          ));
        }

        setState(() {
          _mediaList.addAll(temp);
          currentPage++;
        });
      }
    } else {
      if (kDebugMode) {
        print('please grant the permission-----------');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('in initstate-------------');
    }
    _fetchNewMedia();
  }

  int indexx = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'New Reels',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: _mediaList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 250,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 5.h),
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  setState(() {
                    indexx = index;
                    _file = path[index];
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ReelEditeScreen(_file!),
                    ));
                  });
                },
                child: _mediaList[index]);
          },
        ),
      ),
    );
  }
}

import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone2/screens/add_post_text_screen.dart';
import 'package:photo_manager/photo_manager.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
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
      await PhotoManager.getAssetPathList(type: RequestType.image);
      if (kDebugMode) {
        print('album is empty? ========>${album.isEmpty}');
      }
      if (album.isNotEmpty) {
        final List<AssetEntity> media =
        await album[0].getAssetListPaged(page: currentPage, size: 60);

        for (var asset in media) {
          if (asset.type == AssetType.image) {
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
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Add post',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: InkWell(
              onTap: (){
                _file != null ? Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddPostTextScreen(_file!))) :
                print('--------the file is empty--------');
              },
              child: Center(
                child: Text(
                  'Next',
                  style: TextStyle(fontSize: 15.sp, color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 375.h,
                child: _mediaList.isNotEmpty
                    ? GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                  ),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return _mediaList[indexx];
                  },
                )
                    : Center(
                  child: Text(
                    'No media available',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 40.h,
                color: Colors.white,
                child: Row(
                  children: [
                    SizedBox(width: 10.w),
                    Text(
                      'Recent',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                itemCount: _mediaList.isEmpty ? 1 : _mediaList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 2,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (kDebugMode) {
                        print('${indexx} <====1====> ${index}');
                      }
                      setState(() {
                        indexx = index;
                        _file = path[index];
                      });
                    },
                    child:_mediaList.isNotEmpty ? _mediaList[index] : const Center(child: Text(
                      '',
                    ),),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:factory_shop/features/feed/provider/feed_provider.dart';
import 'package:factory_shop/features/upload/model/image_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final _captionController = TextEditingController();
  List<XFile> _images = [];
  int _currentImageIndex = 0;
  ImageFilter _selectedFilter = ImageFilter.presets[0];
  CroppedFile? _croppedFile;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(
      imageQuality: 80,
    );

    if (images.isNotEmpty) {
      setState(() {
        _images = images;
        _currentImageIndex = 0;
        _croppedFile = null;
      });
    }
  }

  Future<void> _cropImage() async {
    if (_images.isEmpty) return;

    final file = _croppedFile?.path ?? _images[_currentImageIndex].path;
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      // aspectRatioPresets: [
      //   CropAspectRatioPreset.square,
      //   CropAspectRatioPreset.ratio3x2,
      //   CropAspectRatioPreset.original,
      //   CropAspectRatioPreset.ratio4x3,
      //   CropAspectRatioPreset.ratio16x9
      // ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '이미지 자르기',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: '이미지 자르기',
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _croppedFile = croppedFile;
      });
    }
  }

  Future<void> _uploadPost() async {
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지를 선택해주세요')),
      );
      return;
    }

    // TODO: 실제 이미지 업로드 로직 구현
    final imageUrl = _croppedFile?.path ?? _images[_currentImageIndex].path;

    await ref.read(feedStateProvider.notifier).createPost(
          imageUrl: imageUrl,
          caption: _captionController.text,
        );

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 게시물'),
        actions: [
          TextButton(
            onPressed: _uploadPost,
            child: const Text('공유'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_images.isNotEmpty) ...[
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix([
                        _selectedFilter.brightness,
                        0,
                        0,
                        0,
                        0,
                        0,
                        _selectedFilter.brightness,
                        0,
                        0,
                        0,
                        0,
                        0,
                        _selectedFilter.brightness,
                        0,
                        0,
                        0,
                        0,
                        0,
                        1,
                        0,
                      ]),
                      child: Image.file(
                        File(_croppedFile?.path ??
                            _images[_currentImageIndex].path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (_images.length > 1)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_currentImageIndex + 1}/${_images.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ImageFilter.presets.length,
                  itemBuilder: (context, index) {
                    final filter = ImageFilter.presets[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _selectedFilter == filter
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: ColorFiltered(
                                colorFilter: ColorFilter.matrix([
                                  filter.brightness,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  filter.brightness,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  filter.brightness,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  1,
                                  0,
                                ]),
                                child: Image.file(
                                  File(_croppedFile?.path ??
                                      _images[_currentImageIndex].path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(filter.name),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.add_photo_alternate,
                        size: 50,
                      ),
                      onPressed: _pickImages,
                    ),
                  ),
                ),
              ),
            if (_images.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.crop),
                      onPressed: _cropImage,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_photo_alternate),
                      onPressed: _pickImages,
                    ),
                    if (_images.length > 1) ...[
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: _currentImageIndex > 0
                            ? () {
                                setState(() {
                                  _currentImageIndex--;
                                });
                              }
                            : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: _currentImageIndex < _images.length - 1
                            ? () {
                                setState(() {
                                  _currentImageIndex++;
                                });
                              }
                            : null,
                      ),
                    ],
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _captionController,
                    decoration: const InputDecoration(
                      hintText: '문구 입력...',
                      border: InputBorder.none,
                    ),
                    maxLines: 3,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: const Text('위치 추가'),
                    onTap: () {
                      // TODO: 위치 추가 기능 구현
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('사람 태그하기'),
                    onTap: () {
                      // TODO: 사람 태그 기능 구현
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

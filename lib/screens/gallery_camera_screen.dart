import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryCameraScreen extends StatefulWidget {
  const GalleryCameraScreen({super.key});

  @override
  State<GalleryCameraScreen> createState() => _GalleryCameraScreenState();
}

class _GalleryCameraScreenState extends State<GalleryCameraScreen> {
  final List<File> userImages = [];

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        userImages.add(File(picked.path));
      });
    }
  }

  Future<void> _captureFromCamera() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        userImages.add(File(picked.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery & Camera'),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: _pickFromGallery,
            tooltip: 'Pick from Gallery',
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _captureFromCamera,
            tooltip: 'Capture from Camera',
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: userImages.length,
        itemBuilder: (context, index) => ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(userImages[index], fit: BoxFit.cover),
        ),
      ),
    );
  }
} 
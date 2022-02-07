import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateNoteViewModel {
  final ImagePicker _imagePicker = ImagePicker();

  Future<String> onImagePickCallback(File file) async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    return image!.path;
  }

  Future<String> onVideoPickCallBack(File file) async {
    final XFile? video =
        await _imagePicker.pickVideo(source: ImageSource.gallery);
    return video!.path;
  }
}

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:developer' as developer;

class SelectImageState {
  final File? image;
  SelectImageState({this.image});
}

class SelectImageCubit extends Cubit<SelectImageState> {
  final ImagePicker _imagePicker = ImagePicker();
  static const int maxFileSize = 1024 * 1024; // 1MB max

  SelectImageCubit() : super(SelectImageState(image: null));

  /// Nén ảnh để giảm kích thước
  Future<File?> _compressImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      developer.log('Original image size: ${bytes.length / 1024 / 1024} MB');

      // Decode image
      img.Image? image = img.decodeImage(bytes);
      if (image == null) return null;

      // Resize if too large
      if (image.width > 1024 || image.height > 1024) {
        image = img.copyResize(image, width: 1024, height: 1024);
      }

      // Encode and compress
      List<int> compressedBytes = img.encodeJpg(image, quality: 75);
      developer
          .log('Compressed image size: ${compressedBytes.length / 1024} KB');

      // Save to temporary file
      final tempDir = Directory.systemTemp;
      final compressedFile = File(
          '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await compressedFile.writeAsBytes(compressedBytes);

      // Check if still too large
      if (compressedBytes.length > maxFileSize) {
        developer.log('Image still too large after compression');
        return null;
      }

      return compressedFile;
    } catch (e) {
      developer.log('Image compression error: $e');
      return null;
    }
  }

  Future<void> pickImage({ImageSource source = ImageSource.gallery}) async {
    final pickedFile = await _imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      final allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
      final extension = pickedFile.path.split('.').last.toLowerCase();
      if (allowedExtensions.contains(extension)) {
        final originalFile = File(pickedFile.path);

        // Nén ảnh trước khi lưu
        final compressedFile = await _compressImage(originalFile);

        if (compressedFile != null) {
          emit(SelectImageState(image: compressedFile));
        } else {
          developer.log('Failed to compress image or file too large');
          emit(SelectImageState(image: null));
        }
      } else {
        emit(SelectImageState(image: null));
      }
    }
  }

  void setImage(File? image) {
    emit(SelectImageState(image: image));
  }
}

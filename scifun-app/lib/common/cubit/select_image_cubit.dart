import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SelectImageState {
  final File? image;
  SelectImageState({this.image});
}

class SelectImageCubit extends Cubit<SelectImageState> {
  final ImagePicker _imagePicker = ImagePicker();

  SelectImageCubit() : super(SelectImageState(image: null));

  Future<void> pickImage({ImageSource source = ImageSource.gallery}) async {
    final pickedFile = await _imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      final allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
      final extension = pickedFile.path.split('.').last.toLowerCase();
      if (allowedExtensions.contains(extension)) {
        emit(SelectImageState(image: File(pickedFile.path)));
      } else {
        emit(SelectImageState(image: null));
      }
    }
  }

  void setImage(File? image) {
    emit(SelectImageState(image: image));
  }
}

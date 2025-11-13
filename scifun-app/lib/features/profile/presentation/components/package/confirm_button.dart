import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/profile/presentation/bloc/package_bloc.dart';

class ConfirmButton extends StatelessWidget {
  final bool isEnabled;
  final int id;
  final File? image;

  const ConfirmButton({
    super.key,
    required this.isEnabled,
    required this.id,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return BasicButton(
      width: double.infinity,
      text: "Xác nhận đã thanh toán",
      onPressed: () {
        print(image);
        if (image == null) {
          EasyLoading.showToast(
            'Vui lòng chọn ảnh trước khi xác nhận',
            toastPosition: EasyLoadingToastPosition.bottom,
          );

          return;
        }

        // Gửi sự kiện nếu có ảnh
        context.read<PackageBloc>().add(
              PackageBuyRequested(id: id, image: image!),
            );
      },
      backgroundColor: image == null
          ? AppColor.hurricane500.withValues(alpha: 0.12)
          : AppColor.primary500,
      textColor: image == null
          ? AppColor.hurricane800.withValues(alpha: 0.3)
          : Colors.white,
    );
  }
}

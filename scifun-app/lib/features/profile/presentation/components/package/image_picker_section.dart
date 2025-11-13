import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thilop10_3004/common/cubit/select_image_cubit.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';

class ImagePickerSection extends StatelessWidget {
  const ImagePickerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectImageCubit, SelectImageState>(
      builder: (context, state) {
        final image = state.image;

        return SizedBox(
          width: ScreenUtil().screenWidth * 0.35,
          height: ScreenUtil().screenWidth * 0.6,
          child: image != null
              ? Image.file(
                  image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                )
              : GestureDetector(
                  onTap: () => context.read<SelectImageCubit>().pickImage(),
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      radius: Radius.circular(16.r),
                      color: AppColor.primary500,
                      strokeWidth: 1.w,
                    ),
                    child: Center(
                      child: Text(
                        "Tải ảnh",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 17.sp,
                                ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

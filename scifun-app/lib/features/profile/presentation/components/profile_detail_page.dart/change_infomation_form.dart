import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/cubit/select_cubit.dart';
import 'package:sci_fun/common/cubit/select_image_cubit.dart';
// removed unused import
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/common/widget/basic_input_field.dart';
import 'package:sci_fun/common/widget/custom_network_asset_image.dart';
import 'package:sci_fun/common/widget/customize_dropdown.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
// removed unused import
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';

import 'package:intl/intl.dart';

class ChangeInfomationForm extends StatefulWidget {
  const ChangeInfomationForm({super.key});

  @override
  State<ChangeInfomationForm> createState() => _ChangeInfomationFormState();
}

class _ChangeInfomationFormState extends State<ChangeInfomationForm> {
  late final UserCubit _userCubit;
  late final SharePrefsService _sharePrefsService;
  late final String token;
  // Avoid using a shared GlobalKey for the Form to prevent duplicate
  // GlobalKey problems when widgets are reparented. Use `Form.of(context)`
  // to access validation instead.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _fullnameCon = TextEditingController();
  final _birthdayCon = TextEditingController();

  DateTime? selectedBirthday;
  bool _isFirstLoad = true;
  int? _genderFieldValue;
  @override
  void initState() {
    super.initState();
    _userCubit = context.read<UserCubit>();
    // SharePrefsService is provided via service locator, not a widget provider.
    _sharePrefsService = sl<SharePrefsService>();
    token = _sharePrefsService.getUserData()!;
  }

  @override
  void dispose() {
    _fullnameCon.dispose();
    _birthdayCon.dispose();

    super.dispose();
  }

  void _onChange() {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      final selectedImage = context.read<SelectImageCubit>().state.image;
      final userState = context.read<UserCubit>().state;
      if (userState is UserLoaded) {
        final userId = userState.user.data?.id ?? '';
        _userCubit.updateUser(
          token: token,
          userId: userId,
          fullname: _fullnameCon.text.trim(),
          dob: selectedBirthday ?? DateTime(2000, 1, 1),
          sex: _genderFieldValue ?? 1,
          avatar: selectedImage,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        print("UserCubit state: $state");
        if (state is UserError) {
          EasyLoading.dismiss();
          EasyLoading.showToast(state.message);
        } else if (state is UserLoading) {
          EasyLoading.show(
            status: 'Đang tải',
            maskType: EasyLoadingMaskType.black,
          );
        } else if (state is UserUpdated) {
          EasyLoading.dismiss();
          EasyLoading.showToast("Cập nhật thông tin thành công",
              toastPosition: EasyLoadingToastPosition.bottom);
        } else if (state is UserLoaded) {
          EasyLoading.dismiss();
        }
      },
      builder: (context, state) {
        if (state is UserLoaded) {
          final user = state.user.data;
          if (_isFirstLoad) {
            _fullnameCon.text = user?.fullname ?? 'Khách';
            // _emailCon.text = user?.email ?? '';
            selectedBirthday = user?.dob ?? DateTime(2000);
            _birthdayCon.text = user?.dob != null
                ? DateFormat('dd/MM/yyyy').format(user!.dob!)
                : '';
            _genderFieldValue = user?.sex;
            // Note: API doesn't support email, phone, province/ward
            // _emailCon.text = user?.email ?? '';
            // _phoneCon.text = user?.phone ?? '';
            // _selectedProvinceId = user?.province?.id;
            // _selectedWardId = user?.ward?.id;
            _isFirstLoad = false;
          }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20.h),
                _avatarField(),
                SizedBox(height: 40.h),
                _fullnameField(),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(child: _birthdayField()),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: BlocProvider(
                        create: (context) =>
                            SelectCubit<int>(_genderFieldValue ?? 1),
                        child: BlocBuilder<SelectCubit<int>, int>(
                          builder: (context, state) {
                            return CustomizeDropdown<int?>(
                              items: {1: "Nam", 2: "Nữ"},
                              onChanged: (int? v) {
                                context.read<SelectCubit<int>>().select(v ?? 1);
                                _genderFieldValue = v;
                              },
                              hintText: "Chọn giới tính",
                              value: state,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                SizedBox(height: 40.h),
                _changeButton(),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _avatarField() {
    return BlocBuilder<SelectImageCubit, SelectImageState>(
      builder: (context, state) {
        final image = state.image;
        final userState = context.read<UserCubit>().state;
        String avatarUrl =
            'https://cdn-icons-png.flaticon.com/512/8345/8345328.png';
        if (userState is UserLoaded) {
          avatarUrl = userState.user.data?.avatar ?? avatarUrl;
        }

        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: image != null
                  ? Image.file(
                      image,
                      width: 96.w,
                      height: 96.w,
                      fit: BoxFit.cover,
                    )
                  : CustomNetworkAssetImage(
                      imagePath: avatarUrl,
                      width: 96.w,
                      height: 96.w,
                    ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () async {
                  await context.read<SelectImageCubit>().pickImage();
                },
                child: Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: AppColor.primary400,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 16.w,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _fullnameField() => BasicInputField(
        controller: _fullnameCon,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Họ tên không được để trống';
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        suffixIcon: const Icon(Icons.edit),
      );

  Widget _birthdayField() => BasicInputField(
        controller: _birthdayCon,
        readOnly: true,
        onTap: () async {
          DateTime initial = selectedBirthday ?? DateTime(2000);
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: initial,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: AppColor.primary400, // Màu header
                    onPrimary: Colors.white, // Màu chữ trên header
                    onSurface: Colors.black, // Màu chữ ngày
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor:
                          AppColor.primary400, // Màu nút "OK", "Hủy"
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );

          if (picked != null) {
            selectedBirthday = picked;
            _birthdayCon.text = DateFormat('dd/MM/yyyy').format(picked);
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ngày sinh không được để trống';
          }
          return null;
        },
        suffixIcon: const Icon(Icons.calendar_month),
      );

  Widget _changeButton() => BasicButton(
        text: "Cập nhật",
        onPressed: _onChange,
        width: double.infinity,
        fontSize: 18.sp,
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
        backgroundColor: AppColor.primary600,
      );
}

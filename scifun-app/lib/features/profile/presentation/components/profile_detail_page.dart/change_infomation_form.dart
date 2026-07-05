import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sci_fun/common/cubit/select_cubit.dart';
import 'package:sci_fun/common/cubit/select_image_cubit.dart';
import 'package:sci_fun/common/helper/level_helper.dart';
import 'package:sci_fun/common/widget/app_loading_indicator.dart';
import 'package:sci_fun/common/widget/basic_button.dart';
import 'package:sci_fun/common/widget/basic_input_field.dart';
import 'package:sci_fun/common/widget/custom_network_asset_image.dart';
import 'package:sci_fun/common/widget/customize_dropdown.dart';
import 'package:sci_fun/core/services/share_prefs_service.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';
import 'package:sci_fun/features/profile/presentation/helper/guest_feature_guard.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _fullnameCon = TextEditingController();
  final _birthdayCon = TextEditingController();

  DateTime? selectedBirthday;
  bool _isFirstLoad = true;
  int? _genderFieldValue;
  String? _levelFieldValue;
  @override
  void initState() {
    super.initState();
    _userCubit = context.read<UserCubit>();
    _sharePrefsService = sl<SharePrefsService>();
    token = _sharePrefsService.getAuthToken()!;
  }

  @override
  void dispose() {
    _fullnameCon.dispose();
    _birthdayCon.dispose();

    super.dispose();
  }

  void _onChange() {
    if (_formKey.currentState!.validate()) {
      _submitChange();
    }
  }

  Future<void> _submitChange() async {
    FocusScope.of(context).unfocus();

    final canAccess = await guardGuestRestrictedFeature(context);
    if (!canAccess || !mounted) {
      return;
    }

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
        level: LevelHelper.normalize(_levelFieldValue) ?? LevelHelper.beginner,
        avatar: selectedImage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserError) {
          EasyLoading.dismiss();
          EasyLoading.showToast(state.message);
        } else if (state is UserLoading) {
          EasyLoading.show(
            status: 'Đang tải',
            maskType: EasyLoadingMaskType.black,
          );
        } else if (state is UserUpdated) {
          // Chỉ báo thành công khi là UserUpdated (cập nhật thực), không phải UserLoaded thường.
          EasyLoading.dismiss();
          EasyLoading.showToast("Cập nhật thông tin thành công",
              toastPosition: EasyLoadingToastPosition.bottom);
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
            _levelFieldValue =
                LevelHelper.normalize(user?.level) ?? LevelHelper.beginner;
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),
                Center(child: _avatarField()),
                SizedBox(height: 12.h),
                Center(
                  child: Text(
                    'Ảnh đại diện',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColor.hurricane700,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                SizedBox(height: 22.h),
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: AppColor.skyblue100.withValues(alpha: 0.9),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.skyblue500.withValues(alpha: 0.08),
                        blurRadius: 20.r,
                        offset: Offset(0, 8.h),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Thông tin cơ bản'),
                      SizedBox(height: 14.h),
                      _fieldLabel('Họ và tên'),
                      _fullnameField(),
                      SizedBox(height: 14.h),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel('Ngày sinh'),
                                _birthdayField(),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel('Giới tính'),
                                BlocProvider(
                                  create: (context) =>
                                      SelectCubit<int>(_genderFieldValue ?? 1),
                                  child: BlocBuilder<SelectCubit<int>, int>(
                                    builder: (context, state) {
                                      return CustomizeDropdown<int?>(
                                        items: {1: "Nam", 2: "Nữ"},
                                        onChanged: (int? v) {
                                          context
                                              .read<SelectCubit<int>>()
                                              .select(v ?? 1);
                                          _genderFieldValue = v;
                                        },
                                        hintText: "Chọn giới tính",
                                        value: state,
                                        backgroundColorButton:
                                            const Color(0xFFF9FCFF),
                                        paddingButton: EdgeInsets.symmetric(
                                          horizontal: 14.w,
                                          vertical: 13.h,
                                        ),
                                        borderRadiusButton:
                                            BorderRadius.circular(14.r),
                                        borderButton: Border.all(
                                          color: AppColor.skyblue100
                                              .withValues(alpha: 0.95),
                                          width: 1.2,
                                        ),
                                        suffixIconInActive:
                                            Symbols.keyboard_arrow_down_rounded,
                                        suffixIconActive:
                                            Symbols.keyboard_arrow_up_rounded,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      _fieldLabel('Trình độ'),
                      _levelField(),
                    ],
                  ),
                ),
                SizedBox(height: 22.h),
                _changeButton(),
              ],
            ),
          );
        }
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h),
            child: const AppLoadingIndicator(
              message: 'Đang tải thông tin cá nhân...',
            ),
          ),
        );
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
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 116.w,
              height: 116.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColor.skyblue200.withValues(alpha: 0.8),
                    AppColor.skyblue400.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.all(4.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: image != null
                    ? Image.file(
                        image,
                        width: 108.w,
                        height: 108.w,
                        fit: BoxFit.cover,
                      )
                    : CustomNetworkAssetImage(
                        imagePath: avatarUrl,
                        width: 108.w,
                        height: 108.w,
                      ),
              ),
            ),
            Positioned(
              bottom: 2.h,
              right: -2.w,
              child: GestureDetector(
                onTap: () async {
                  await context.read<SelectImageCubit>().pickImage();
                },
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: AppColor.skyblue400,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.skyblue600.withValues(alpha: 0.35),
                        blurRadius: 10.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: Icon(
                    Symbols.edit_rounded,
                    color: Colors.white,
                    size: 17.w,
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
        hintText: 'Nhập họ tên của bạn',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Họ tên không được để trống';
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        style: TextStyle(
          color: AppColor.hurricane950,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: AppColor.hurricane400,
          fontSize: 18.sp,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        borderRadius: BorderRadius.circular(14.r),
        fillColor: const Color(0xFFF9FCFF),
        enabledBorder: _fieldBorder(color: AppColor.skyblue100, width: 1.2),
        focusedBorder: _fieldBorder(color: AppColor.skyblue500, width: 1.4),
        errorBorder: _fieldBorder(color: Colors.red.shade300, width: 1.2),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: Icon(
            Symbols.edit_rounded,
            color: AppColor.skyblue500,
            size: 20.sp,
          ),
        ),
      );

  Widget _birthdayField() => BasicInputField(
        controller: _birthdayCon,
        hintText: 'Chọn ngày sinh',
        readOnly: true,
        style: TextStyle(
          color: AppColor.hurricane950,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: AppColor.hurricane400,
          fontSize: 18.sp,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        borderRadius: BorderRadius.circular(14.r),
        fillColor: const Color(0xFFF9FCFF),
        enabledBorder: _fieldBorder(color: AppColor.skyblue100, width: 1.2),
        focusedBorder: _fieldBorder(color: AppColor.skyblue500, width: 1.4),
        errorBorder: _fieldBorder(color: Colors.red.shade300, width: 1.2),
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
                    primary: AppColor.skyblue400, // Màu header
                    onPrimary: Colors.white, // Màu chữ trên header
                    onSurface: Colors.black, // Màu chữ ngày
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor:
                          AppColor.skyblue400, // Màu nút "OK", "Hủy"
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
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: Icon(
            Symbols.calendar_month_rounded,
            color: AppColor.skyblue500,
            size: 20.sp,
          ),
        ),
      );
  Widget _levelField() => BlocProvider(
        create: (context) => SelectCubit<String>(
            LevelHelper.normalize(_levelFieldValue) ?? LevelHelper.beginner),
        child: BlocBuilder<SelectCubit<String>, String>(
          builder: (context, state) {
            return CustomizeDropdown<String>(
              items: _levelOptions,
              onChanged: (String? value) {
                final normalized =
                    LevelHelper.normalize(value) ?? LevelHelper.beginner;
                context.read<SelectCubit<String>>().select(normalized);
                _levelFieldValue = normalized;
              },
              hintText: 'Chọn cấp độ',
              value: LevelHelper.normalize(state) ?? LevelHelper.beginner,
              backgroundColorButton: const Color(0xFFF9FCFF),
              paddingButton: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 13.h,
              ),
              borderRadiusButton: BorderRadius.circular(14.r),
              borderButton: Border.all(
                color: AppColor.skyblue100.withValues(alpha: 0.95),
                width: 1.2,
              ),
              suffixIconInActive: Symbols.keyboard_arrow_down_rounded,
              suffixIconActive: Symbols.keyboard_arrow_up_rounded,
            );
          },
        ),
      );

  Map<String, String> get _levelOptions => const {
        LevelHelper.beginner: 'Mới bắt đầu',
        LevelHelper.intermediate: 'Trung cấp',
        LevelHelper.advanced: 'Nâng cao',
      };
  Widget _changeButton() => BasicButton(
        text: "Cập nhật",
        onPressed: _onChange,
        width: double.infinity,
        fontSize: 18.sp,
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
        borderRadius: BorderRadius.circular(16.r),
        backgroundColor: AppColor.skyblue400,
        buttonColor: AppColor.skyblue600,
      );

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: AppColor.hurricane950,
            fontWeight: FontWeight.w700,
            fontSize: 19.sp,
          ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 7.h),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColor.hurricane700,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  OutlineInputBorder _fieldBorder({
    required Color color,
    required double width,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.r),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

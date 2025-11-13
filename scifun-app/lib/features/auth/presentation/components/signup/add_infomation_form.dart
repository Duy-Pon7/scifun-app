import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thilop10_3004/common/widget/basic_button.dart';
import 'package:thilop10_3004/common/widget/basic_input_field.dart';
import 'package:thilop10_3004/common/widget/customize_dropdown.dart';
import 'package:thilop10_3004/core/utils/assets/app_image.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';
import 'package:thilop10_3004/features/address/presentation/cubit/address_cubit.dart';
import 'package:thilop10_3004/features/auth/presentation/bloc/auth_bloc.dart';

import 'package:intl/intl.dart';
import 'package:thilop10_3004/features/auth/presentation/page/signin/signin_page.dart';

class AddInfomationForm extends StatefulWidget {
  final String phone;
  final String password;
  final String confirmPassword;
  final String email;
  const AddInfomationForm(
      {super.key,
      required this.phone,
      required this.password,
      required this.email,
      required this.confirmPassword});

  @override
  State<AddInfomationForm> createState() => _AddInfomationFormState();
}

class _AddInfomationFormState extends State<AddInfomationForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullnameCon = TextEditingController();
  final _birthdayCon = TextEditingController();

  int? _selectedProvinceId;
  int? _selectedWardId;
  bool _provinceError = false;
  bool _wardError = false;

  DateTime? selectedBirthday;
  @override
  void initState() {
    super.initState();
    final addressCubit = context.read<AddressCubit>();
    addressCubit.fetchAddresss();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final authState = context.read<AuthBloc>().state;
    //   if (authState is AuthUserSuccess) {
    //     final user = authState.user;
    //     _selectedProvinceId = user?.province?.id;
    //     _selectedWardId = user?.ward?.id;
    //     print(_selectedProvinceId);
    //     print(_selectedWardId);
    //     if (_selectedProvinceId != null) {
    //       addressCubit.fetchWards(_selectedProvinceId!);
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    _fullnameCon.dispose();
    _birthdayCon.dispose();
    super.dispose();
  }

  void _onSubmit() {
    setState(() {
      _provinceError = _selectedProvinceId == null;
      _wardError = _selectedWardId == null;
    });

    if (_formKey.currentState!.validate() && !_provinceError && !_wardError) {
      FocusScope.of(context).unfocus();
      context.read<AuthBloc>().add(AuthSignup(
            fullname: _fullnameCon.text.trim(),
            birthday: selectedBirthday ?? DateTime(2000, 1, 1),
            // gender: _genderFieldValue ?? 1,
            provinceId: _selectedProvinceId ?? 0,
            wardId: _selectedWardId ?? 0,
            email: widget.email,
            phone: widget.phone,
            password: widget.password,
            passwordConfimation: widget.confirmPassword,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print("cus $state");
        if (state is AuthFailure) {
          EasyLoading.showToast(state.message,
              toastPosition: EasyLoadingToastPosition.bottom);
        } else if (state is AuthLoading) {
          EasyLoading.show(
            status: 'Đang tải',
            maskType: EasyLoadingMaskType.black,
          );
        } else if (state is AuthUserSuccess) {
          EasyLoading.showToast("Tạo tài khoản thành công",
              toastPosition: EasyLoadingToastPosition.bottom);
          EasyLoading.dismiss();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SigninPage()),
          );
        }
      },
      child: Column(
        children: [
          SizedBox(height: 40.h),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: Image.asset(
                AppImage.change,
                width: 90.w,
                height: 90.h,
              ),
            ),
          ),
          SizedBox(height: 32.h),

          Form(
              key: _formKey,
              child: Column(
                spacing: 12.h,
                children: [
                  _fullnameField(),
                  _birthdayField(),
                  BlocBuilder<AddressCubit, AddressState>(
                    builder: (context, state) {
                      if (state is AddressLoading) {
                        // return const CircularProgressIndicator();
                      } else if (state is AddressLoaded) {
                        final provinces = state.provinces;
                        final items = {
                          for (var p in provinces) p.id: p.name,
                        };

                        return CustomizeDropdown<int?>(
                            items: items.cast<int?, String>(),
                            onChanged: (int? selectedId) {
                              if (selectedId != null) {
                                setState(() {
                                  _selectedProvinceId = selectedId;
                                  _selectedWardId =
                                      null; // reset quận/huyện khi đổi tỉnh
                                });
                                context
                                    .read<AddressCubit>()
                                    .fetchWards(selectedId);
                              }
                            },
                            hintText: "Tỉnh / Thành phố",
                            value: _selectedProvinceId,
                            hasError: _provinceError // ✅ Sửa chỗ này
                            );
                      } else if (state is AddressError) {
                        return Text("Lỗi: ${state.message}");
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  BlocBuilder<AddressCubit, AddressState>(
                    builder: (context, state) {
                      if (_selectedProvinceId == null)
                        return const SizedBox.shrink();

                      final wards = context.read<AddressCubit>().wards;
                      if (wards.isEmpty) {
                        return const SizedBox(
                            height: 50,
                            child: Center(child: CircularProgressIndicator()));
                      }

                      final items = {
                        for (var ward in wards) ward.id: ward.name,
                      };

                      return CustomizeDropdown<int?>(
                          items: items.cast<int?, String>(),
                          onChanged: (int? selectedWardId) {
                            setState(() {
                              _selectedWardId = selectedWardId;
                            });
                          },
                          hintText: "Huyện / Quận",
                          value: _selectedWardId,
                          hasError: _provinceError);
                    },
                  ),
                  SizedBox(height: 20.h),
                  _changeButton(),
                ],
              )),
          // SizedBox(height: 16.h),
          // _emailnameField(),
        ],
      ),
    );
  }

  //   return BlocConsumer<AuthBloc, AuthState>(
  //     listener: (context, state) {
  // print("cus $state");
  // if (state is AuthFailure) {
  //   EasyLoading.showToast("Không thể lấy thông tin người dùng");
  // } else if (state is AuthLoading) {
  //   EasyLoading.show(
  //     status: 'Đang tải',
  //     maskType: EasyLoadingMaskType.black,
  //   );
  // } else if (state is AuthUserSuccess) {
  //   print("abc");
  //   EasyLoading.dismiss();
  //   Navigator.pushReplacement(
  //     context,
  //     DashboardPage.route(),
  //   );
  // }
  //     },
  //     builder: (context, state) {
  //       if (state is AuthUserSuccess) {
  //         final user = state.user;

  //   return Form(
  //     key: _formKey,
  //     child: Column(
  //       children: [
  //         SizedBox(height: 40.h),
  //         Center(
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(24.r),
  //             child: Image.asset(
  //               AppImage.change,
  //               width: 90.w,
  //               height: 90.h,
  //             ),
  //           ),
  //         ),
  //         SizedBox(height: 32.h),
  //         _fullnameField(),
  //         SizedBox(height: 16.h),
  //         Row(
  //           children: [
  //             Expanded(child: _birthdayField()),
  //             SizedBox(width: 16.w),
  //             Expanded(
  //               child: BlocProvider(
  //                 create: (context) =>
  //                     SelectCubit<int>(_genderFieldValue ?? 1),
  //                 child: BlocBuilder<SelectCubit<int>, int>(
  //                   builder: (context, state) {
  //                     return CustomizeDropdown<int?>(
  //                       items: {1: "Nam", 2: "Nữ"},
  //                       onChanged: (int? v) {
  //                         context.read<SelectCubit<int>>().select(v!);
  //                         _genderFieldValue = v;
  //                       },
  //                       hintText: "Chọn giới tính",
  //                       value: state ?? 1,
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 16.h),
  //         _emailnameField(),
  //         SizedBox(height: 16.h),
  //         BlocBuilder<AddressCubit, AddressState>(
  //           builder: (context, state) {
  //             if (state is AddressLoading) {
  //               // return const CircularProgressIndicator();
  //             } else if (state is AddressLoaded) {
  //               final provinces = state.provinces;
  //               final items = {
  //                 for (var p in provinces) p.id: p.name,
  //               };

  //               return CustomizeDropdown<int?>(
  //                   items: items.cast<int?, String>(),
  //                   onChanged: (int? selectedId) {
  //                     if (selectedId != null) {
  //                       setState(() {
  //                         _selectedProvinceId = selectedId;
  //                         _selectedWardId =
  //                             null; // reset quận/huyện khi đổi tỉnh
  //                       });
  //                       context
  //                           .read<AddressCubit>()
  //                           .fetchWards(selectedId);
  //                     }
  //                   },
  //                   hintText: "Chọn tỉnh/thành",
  //                   value: _selectedProvinceId,
  //                   hasError: _provinceError // ✅ Sửa chỗ này
  //                   );
  //             } else if (state is AddressError) {
  //               return Text("Lỗi: ${state.message}");
  //             }
  //             return const SizedBox.shrink();
  //           },
  //         ),
  //         SizedBox(height: 16.h),
  //         BlocBuilder<AddressCubit, AddressState>(
  //           builder: (context, state) {
  //             if (_selectedProvinceId == null)
  //               return const SizedBox.shrink();

  //             final wards = context.read<AddressCubit>().wards;
  //             if (wards.isEmpty) {
  //               return const SizedBox(
  //                   height: 50,
  //                   child: Center(child: CircularProgressIndicator()));
  //             }

  //             final items = {
  //               for (var ward in wards) ward.id: ward.name,
  //             };

  //             return CustomizeDropdown<int?>(
  //                 items: items.cast<int?, String>(),
  //                 onChanged: (int? selectedWardId) {
  //                   setState(() {
  //                     _selectedWardId = selectedWardId;
  //                   });
  //                 },
  //                 hintText: "Chọn quận/huyện",
  //                 value: _selectedWardId,
  //                 hasError: _provinceError);
  //           },
  //         ),
  //         SizedBox(height: 40.h),
  //         _changeButton(),
  //       ],
  //     ),
  //   );
  // }
  //       return const SizedBox.shrink();
  //     },
  //   );
  // }

  // Widget _emailnameField() => BasicInputField(
  //       controller: _emailCon,
  //       validator: (value) {
  //         if (value == null || value.isEmpty) {
  //           return 'Nhập email';
  //         }
  //         return null;
  //       },
  //       hintText: "Email",
  //       textInputAction: TextInputAction.next,
  //       suffixIcon: const Icon(Icons.edit),
  //     );
  Widget _fullnameField() => BasicInputField(
        controller: _fullnameCon,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Họ tên không được để trống';
          }
          return null;
        },
        hintText: "Họ và tên",
        textInputAction: TextInputAction.next,
        suffixIcon: const Icon(Icons.edit),
      );

  Widget _birthdayField() => BasicInputField(
        controller: _birthdayCon,
        readOnly: true,
        hintText: "Ngày sinh",
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
        text: "Xác nhận",
        onPressed: _onSubmit,
        width: double.infinity,
        fontSize: 18.sp,
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
        backgroundColor: AppColor.primary600,
      );
}

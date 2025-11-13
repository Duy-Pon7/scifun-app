// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sci_fun/common/cubit/select_cubit.dart';
// import 'package:sci_fun/common/cubit/select_image_cubit.dart';
// import 'package:sci_fun/common/helper/transition_page.dart';
// import 'package:sci_fun/common/widget/basic_button.dart';
// import 'package:sci_fun/common/widget/basic_input_field.dart';
// import 'package:sci_fun/common/widget/custom_network_asset_image.dart';
// import 'package:sci_fun/common/widget/customize_dropdown.dart';
// import 'package:sci_fun/core/utils/theme/app_color.dart';
// import 'package:sci_fun/features/address/presentation/cubit/address_cubit.dart';
// import 'package:sci_fun/features/auth/presentation/bloc/auth_bloc.dart';

// import 'package:intl/intl.dart';

// import 'package:sci_fun/features/profile/presentation/page/change_phone/change_phone.dart';

// class ChangeInfomationForm extends StatefulWidget {
//   const ChangeInfomationForm({super.key});

//   @override
//   State<ChangeInfomationForm> createState() => _ChangeInfomationFormState();
// }

// class _ChangeInfomationFormState extends State<ChangeInfomationForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _fullnameCon = TextEditingController();
//   final _emailCon = TextEditingController();
//   final _birthdayCon = TextEditingController();

//   final _phoneCon = TextEditingController();
//   int? _selectedProvinceId;
//   int? _selectedWardId;

//   DateTime? selectedBirthday;
//   bool _isFirstLoad = true;
//   int? _genderFieldValue;
//   @override
//   void initState() {
//     super.initState();
//     final addressCubit = context.read<AddressCubit>();
//     addressCubit.fetchAddresss();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final authState = context.read<AuthBloc>().state;
//       if (authState is AuthUserSuccess) {
//         final user = authState.user;
//         _selectedProvinceId = user?.province?.id;
//         _selectedWardId = user?.ward?.id;
//         print(_selectedProvinceId);
//         print(_selectedWardId);
//         if (_selectedProvinceId != null) {
//           addressCubit.fetchWards(_selectedProvinceId!);
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _fullnameCon.dispose();
//     _birthdayCon.dispose();
//     _phoneCon.dispose();
//     _emailCon.dispose();
//     super.dispose();
//   }

//   void _onChange() {
//     if (_formKey.currentState!.validate()) {
//       FocusScope.of(context).unfocus();
//       final selectedImage = context.read<SelectImageCubit>().state.image;
//       context.read<AuthBloc>().add(ChangeUser(
//             fullname: _fullnameCon.text.trim(),
//             birthday: selectedBirthday ?? DateTime(2000, 1, 1),
//             gender: _genderFieldValue ?? 1,
//             image: selectedImage,
//             provinceId: _selectedProvinceId ?? 0,
//             wardId: _selectedWardId ?? 0,
//             email: _emailCon.text.trim(),
//           ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AuthBloc, AuthState>(
//       listener: (context, state) {
//         print("bloccus $state");
//         if (state is AuthFailure) {
//           EasyLoading.showToast("Không thể lấy thông tin người dùng");
//         } else if (state is AuthLoading) {
//           EasyLoading.show(
//             status: 'Đang tải',
//             maskType: EasyLoadingMaskType.black,
//           );
//         } else if (state is AuthUserSuccess) {
//           EasyLoading.dismiss();
//           EasyLoading.showToast("Cập nhật thông tin thành công",
//               toastPosition: EasyLoadingToastPosition.bottom);
//         }
//       },
//       builder: (context, state) {
//         if (state is AuthUserSuccess) {
//           final user = state.user;
//           if (_isFirstLoad) {
//             _fullnameCon.text = user?.fullname ?? 'Khách';
//             _emailCon.text = user?.email ?? '';
//             selectedBirthday = user?.birthday ?? DateTime(2000);
//             _birthdayCon.text = user?.birthday != null
//                 ? DateFormat('dd/MM/yyyy').format(user!.birthday!)
//                 : '';
//             _genderFieldValue = user?.gender;
//             _selectedProvinceId = user?.province?.id;
//             _selectedWardId = user?.ward?.id;
//             _phoneCon.text = user?.phone ?? '';
//             // imagePath = user?.image;
//             _isFirstLoad = false;
//           }

//           return Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 SizedBox(height: 20.h),
//                 _avatarField(),
//                 SizedBox(height: 40.h),
//                 _fullnameField(),
//                 SizedBox(height: 16.h),
//                 Row(
//                   children: [
//                     Expanded(child: _birthdayField()),
//                     SizedBox(width: 16.w),
//                     Expanded(
//                       child: BlocProvider(
//                         create: (context) =>
//                             SelectCubit<int>(_genderFieldValue ?? 1),
//                         child: BlocBuilder<SelectCubit<int>, int>(
//                           builder: (context, state) {
//                             return CustomizeDropdown<int?>(
//                               items: {1: "Nam", 2: "Nữ"},
//                               onChanged: (int? v) {
//                                 context.read<SelectCubit<int>>().select(v!);
//                                 _genderFieldValue = v;
//                               },
//                               hintText: "Chọn giới tính",
//                               value: state ?? 1,
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16.h),
//                 _emailnameField(),
//                 SizedBox(height: 16.h),
//                 BlocBuilder<AddressCubit, AddressState>(
//                   builder: (context, state) {
//                     if (state is AddressLoading) {
//                       // return const CircularProgressIndicator();
//                     } else if (state is AddressLoaded) {
//                       final provinces = state.provinces;
//                       final items = {
//                         for (var p in provinces) p.id: p.name,
//                       };

//                       return CustomizeDropdown<int?>(
//                         items: items.cast<int?, String>(),
//                         onChanged: (int? selectedId) {
//                           if (selectedId != null) {
//                             setState(() {
//                               _selectedProvinceId = selectedId;
//                               _selectedWardId =
//                                   null; // reset quận/huyện khi đổi tỉnh
//                             });
//                             context.read<AddressCubit>().fetchWards(selectedId);
//                           }
//                         },
//                         hintText: "Chọn tỉnh/thành",
//                         value: _selectedProvinceId, // ✅ Sửa chỗ này
//                       );
//                     } else if (state is AddressError) {
//                       return Text("Lỗi: ${state.message}");
//                     }
//                     return const SizedBox.shrink();
//                   },
//                 ),
//                 SizedBox(height: 16.h),
//                 BlocBuilder<AddressCubit, AddressState>(
//                   builder: (context, state) {
//                     if (_selectedProvinceId == null)
//                       return const SizedBox.shrink();

//                     final wards = context.read<AddressCubit>().wards;
//                     if (wards.isEmpty) {
//                       return const SizedBox(
//                           height: 50,
//                           child: Center(child: CircularProgressIndicator()));
//                     }

//                     final items = {
//                       for (var ward in wards) ward.id: ward.name,
//                     };

//                     return CustomizeDropdown<int?>(
//                       items: items.cast<int?, String>(),
//                       onChanged: (int? selectedWardId) {
//                         setState(() {
//                           _selectedWardId = selectedWardId;
//                         });
//                       },
//                       hintText: "Chọn quận/huyện",
//                       value: _selectedWardId,
//                     );
//                   },
//                 ),
//                 SizedBox(height: 16.h),
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 3,
//                       child: _phoneField(),
//                     ),
//                     SizedBox(width: 16.w),
//                     Expanded(
//                       flex: 1,
//                       child: _changePhoneButton(),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 6.h),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     'Đổi sđt sẽ đăng nhập lại',
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       color: const Color(0xFF666666),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 40.h),
//                 _changeButton(),
//               ],
//             ),
//           );
//         }
//         return const SizedBox.shrink();
//       },
//     );
//   }

//   Widget _avatarField() {
//     final authState = context.read<AuthBloc>().state;
//     String? imagePathFromUser;
//     if (authState is AuthUserSuccess) {
//       imagePathFromUser = authState.user?.avatar;
//     }

//     return BlocBuilder<SelectImageCubit, SelectImageState>(
//       builder: (context, state) {
//         final image = state.image;

//         return Stack(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(50.r),
//               child: image != null
//                   ? Image.file(
//                       image,
//                       width: 96.w,
//                       height: 96.w,
//                       fit: BoxFit.cover,
//                     )
//                   : CustomNetworkAssetImage(
//                       imagePath: context.read<AuthBloc>().state
//                               is AuthUserSuccess
//                           ? (context.read<AuthBloc>().state as AuthUserSuccess)
//                                   .user!
//                                   .avatar ??
//                               ""
//                           : 'https://cdn-icons-png.flaticon.com/512/8345/8345328.png',
//                       width: 96.w,
//                       height: 96.w,
//                     ),
//             ),
//             Positioned(
//               bottom: 0,
//               right: 0,
//               child: GestureDetector(
//                 onTap: () async {
//                   await context.read<SelectImageCubit>().pickImage();
//                 },
//                 child: Container(
//                   width: 28.w,
//                   height: 28.w,
//                   decoration: const BoxDecoration(
//                     color: Colors.redAccent,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.edit,
//                     color: Colors.white,
//                     size: 16.w,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _emailnameField() => BasicInputField(
//         controller: _emailCon,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Nhập email';
//           }
//           return null;
//         },
//         hintText: "Nhập email",
//         textInputAction: TextInputAction.next,
//         suffixIcon: const Icon(Icons.edit),
//       );
//   Widget _fullnameField() => BasicInputField(
//         controller: _fullnameCon,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Họ tên không được để trống';
//           }
//           return null;
//         },
//         textInputAction: TextInputAction.next,
//         suffixIcon: const Icon(Icons.edit),
//       );

//   Widget _birthdayField() => BasicInputField(
//         controller: _birthdayCon,
//         readOnly: true,
//         onTap: () async {
//           DateTime initial = selectedBirthday ?? DateTime(2000);
//           DateTime? picked = await showDatePicker(
//             context: context,
//             initialDate: initial,
//             firstDate: DateTime(1900),
//             lastDate: DateTime.now(),
//             builder: (context, child) {
//               return Theme(
//                 data: Theme.of(context).copyWith(
//                   colorScheme: ColorScheme.light(
//                     primary: AppColor.primary400, // Màu header
//                     onPrimary: Colors.white, // Màu chữ trên header
//                     onSurface: Colors.black, // Màu chữ ngày
//                   ),
//                   textButtonTheme: TextButtonThemeData(
//                     style: TextButton.styleFrom(
//                       foregroundColor:
//                           AppColor.primary400, // Màu nút "OK", "Hủy"
//                     ),
//                   ),
//                 ),
//                 child: child!,
//               );
//             },
//           );

//           if (picked != null) {
//             selectedBirthday = picked;
//             _birthdayCon.text = DateFormat('dd/MM/yyyy').format(picked);
//           }
//         },
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Ngày sinh không được để trống';
//           }
//           return null;
//         },
//         suffixIcon: const Icon(Icons.calendar_month),
//       );

//   Widget _phoneField() => BasicInputField(
//         controller: _phoneCon,
//         fillColor: const Color(0xFFF0F0F0),
//         readOnly: true,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Số điện thoại không được để trống';
//           }
//           return null;
//         },
//         style: TextStyle(
//           color: AppColor.hurricane800.withValues(alpha: 0.3),
//         ),
//         textInputAction: TextInputAction.next,
//         keyboardType: TextInputType.phone,
//       );

//   Widget _changeButton() => BasicButton(
//         text: "Cập nhật",
//         onPressed: _onChange,
//         width: double.infinity,
//         fontSize: 18.sp,
//         padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
//         backgroundColor: AppColor.primary600,
//       );
//   Widget _changePhoneButton() => BasicButton(
//         text: "Đổi",
//         textColor: AppColor.primary600,
//         onPressed: () {
//           Navigator.push(context, slidePage(ChangePhone()));
//         },
//         width: double.infinity,
//         fontSize: 18.sp,
//         padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
//         backgroundColor: AppColor.primary600.withValues(alpha: 0.15),
//       );
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/cubit/select_image_cubit.dart';
import 'package:sci_fun/common/entities/settings_entity.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/custom_network_asset_image.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/profile/presentation/bloc/package_bloc.dart';
import 'package:sci_fun/features/profile/presentation/components/package/confirm_button.dart';
import 'package:sci_fun/features/profile/presentation/components/package/image_picker_section.dart';
import 'package:sci_fun/features/profile/presentation/components/package/payment_info_card.dart';
import 'package:sci_fun/features/profile/presentation/cubit/settings_cubit.dart';
import 'package:sci_fun/features/profile/presentation/widget/tutorial_step.dart';

class PaymentPage extends StatelessWidget {
  final int id;
  final String title;
  final String description;
  final String price;

  const PaymentPage({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SelectImageCubit>(),
      child: Scaffold(
        appBar: BasicAppbar(
          title: "Chi tiết lịch sử gói cước",
          showTitle: true,
          showBack: true,
        ),
        body: BlocBuilder<SelectImageCubit, SelectImageState>(
          builder: (context, imageState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, state) {
                    if (state is SettingsLoaded) {
                      // Tạo hàm lấy plainValue từ settingKey
                      String getValue(String key) {
                        return state.newsList
                                .firstWhere(
                                  (e) => e.settingKey == key,
                                  orElse: () => SettingsEntity(
                                      settingKey: '', plainValue: ''),
                                )
                                .plainValue ??
                            '';
                      }

                      final qrImagePath = getValue('qr_code');
                      final bankName = getValue('bank_name');
                      final bankAccount = getValue('bank_account');
                      final accountHolder = getValue('account_holder');
                      final paymentSyntax = getValue('payment_syntax');

                      return Column(
                        spacing: 16.h,
                        children: [
                          CustomNetworkAssetImage(
                            imagePath: qrImagePath,
                            width: 200.w,
                            height: 200.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<PackageBloc>()
                                  .add(PackageGetInstructions());
                            },
                            child: BlocListener<PackageBloc, PackageState>(
                              listener: (context, state) {
                                if (state is PackageInstructionsSuccess) {
                                  showTutorialBottomSheet(
                                      context, state.instructions);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.h, horizontal: 10.w),
                                decoration: BoxDecoration(
                                  color: AppColor.primary600
                                      .withValues(alpha: 0.15),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.r)),
                                ),
                                child: Text(
                                  "Hướng dẫn mua gói",
                                  style: TextStyle(
                                    color: AppColor.primary600,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          PaymentInfoCard(
                            title: title,
                            description: description,
                            price: price,
                            bankName: bankName,
                            bankAccount: bankAccount,
                            accountHolder: accountHolder,
                            paymentSyntax: paymentSyntax,
                          ),
                          const ImagePickerSection(),
                        ],
                      );
                    } else if (state is SettingsLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Center(
                        child:
                            Text("Đã xảy ra lỗi khi tải thông tin người dùng"));
                  },
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(16.w),
          child: BlocConsumer<PackageBloc, PackageState>(
            listener: (context, state) {
              if (state is PackageBuying) {
                EasyLoading.show(
                    status: 'Đang tải', maskType: EasyLoadingMaskType.black);
              } else if (state is PackageBuySuccess) {
                EasyLoading.dismiss();
                EasyLoading.showToast(state.message,
                    toastPosition: EasyLoadingToastPosition.bottom);

                // Reset state trước khi pop
                context.read<PackageBloc>().add(PackageGetSession());
                Navigator.pop(context);
              } else if (state is PackageBuyFailure) {
                EasyLoading.dismiss();
                EasyLoading.showToast(state.message,
                    toastPosition: EasyLoadingToastPosition.bottom);
              }
            },
            builder: (context, packageState) {
              return BlocBuilder<SelectImageCubit, SelectImageState>(
                builder: (context, state) {
                  return ConfirmButton(
                    isEnabled: state.image != null,
                    id: id,
                    image: state.image,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

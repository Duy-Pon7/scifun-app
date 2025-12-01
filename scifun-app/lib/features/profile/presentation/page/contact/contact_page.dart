import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/entities/settings_entity.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/features/profile/presentation/widget/social_circle_button.dart';
import 'package:sci_fun/features/profile/presentation/widget/text_with_copy_icon.dart';
import 'package:sci_fun/core/utils/assets/app_image.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class ContactPage extends StatelessWidget {
  final List<SettingsEntity> settings;
  const ContactPage({super.key, required this.settings});

  String getSettingValue(String key) {
    return settings
            .firstWhere(
              (e) => e.settingKey == key,
              orElse: () => SettingsEntity(
                id: 0,
                settingKey: '',
                settingName: '',
                plainValue: '',
                desc: '',
                typeInput: 0,
                typeData: null,
                group: 0,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            )
            .plainValue ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: BasicAppbar(
          title: "Về chúng tôi",
          showTitle: true,
          showBack: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.r),
                        child: Image.asset(
                          AppImage.logo,
                          width: 90.w,
                          height: 90.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Ôn thi lớp 10",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 8.h),
                    Html(
                      data: getSettingValue('address').isNotEmpty
                          ? getSettingValue('address')
                          : "<p>Không có nội dung giới thiệu.</p>",
                      style: {
                        "body": Style(
                          fontSize: FontSize(16.sp),
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                        ),
                        "p": Style(margin: Margins.only(bottom: 12)),
                      },
                    ),
                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SocialCircleButton(
                          imageUrl: AppImage.facebook,
                          linkUrl: 'https://www.facebook.com/',
                        ),
                        SocialCircleButton(
                          imageUrl: AppImage.instagram,
                          linkUrl: 'https://www.instagram.com/',
                        ),
                        SocialCircleButton(
                          imageUrl: AppImage.whatsapp,
                          linkUrl: 'https://www.whatsapp.com/',
                        ),
                        SocialCircleButton(
                          imageUrl: AppImage.line,
                          linkUrl: 'https://line.me/',
                        ),
                      ],
                    ),
                    SizedBox(height: 40.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 16.h),
                      child: Column(
                        children: [
                          TextWithCopyIcon(
                            label: 'Sđt:',
                            value: getSettingValue('hotline'),
                            copyValue: getSettingValue('hotline'),
                            dividerColor: AppColor.border,
                          ),
                          TextWithCopyIcon(
                            label: 'Email:',
                            value: getSettingValue('email'),
                            copyValue: getSettingValue('email'),
                            dividerColor: AppColor.border,
                          ),
                          TextWithCopyIcon(
                            label: 'Zalo:',
                            value: getSettingValue('hotline'),
                            copyValue: getSettingValue('hotline'),
                            dividerColor: AppColor.border,
                          ),
                          TextWithCopyIcon(
                            label: 'Facebook:',
                            value: 'Thi Lớp 10',
                            copyValue: 'https://www.facebook.com/thilop10',
                            dividerColor: AppColor.border,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

  static const String _fallbackAddressHtml = '''
<p>
<b>SciFun - Học tập khoa học thú vị</b><br>
Chúng tôi luôn sẵn sàng lắng nghe ý kiến, phản hồi và hỗ trợ bạn trong quá trình học tập.
Nếu có bất kỳ thắc mắc hoặc góp ý nào, hãy liên hệ với chúng tôi qua các kênh bên dưới.
</p>
<p>
Địa chỉ: 123 Đường Khoa Học, Quận Tri Thức, TP. Học Tập<br>
Hotline: 0912 345 678<br>
Email: support@scifun.vn
</p>
''';
  static const String _fallbackHotline = '0912 345 678';
  static const String _fallbackEmail = 'support@scifun.vn';
  static const String _fallbackZalo = '0912 345 678';
  static const String _fallbackFacebookName = 'SciFun Official';
  static const String _fallbackFacebookUrl =
      'https://www.facebook.com/scifun.official';
  static const String _fallbackInstagramUrl =
      'https://www.instagram.com/scifun.official';
  static const String _fallbackWhatsappUrl = 'https://wa.me/84912345678';
  static const String _fallbackLineUrl = 'https://line.me/R/ti/p/@scifun';

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

  String getSettingValueOrFallback(String key, String fallbackValue) {
    final value = getSettingValue(key).trim();
    return value.isNotEmpty ? value : fallbackValue;
  }

  @override
  Widget build(BuildContext context) {
    final addressHtml =
        getSettingValueOrFallback('address', _fallbackAddressHtml);
    final hotline = getSettingValueOrFallback('hotline', _fallbackHotline);
    final email = getSettingValueOrFallback('email', _fallbackEmail);
    final zalo = getSettingValueOrFallback('zalo', _fallbackZalo);
    final facebookUrl =
        getSettingValueOrFallback('facebook', _fallbackFacebookUrl);
    final facebookDisplay = getSettingValueOrFallback(
      'facebookDisplay',
      _fallbackFacebookName,
    );
    final instagramUrl =
        getSettingValueOrFallback('instagram', _fallbackInstagramUrl);
    final whatsappUrl =
        getSettingValueOrFallback('whatsapp', _fallbackWhatsappUrl);
    final lineUrl = getSettingValueOrFallback('line', _fallbackLineUrl);

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: BasicAppbar(
          title: "Liên hệ",
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
                      "SciFun - Học tập khoa học thú vị",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 8.h),
                    Html(
                      data: addressHtml,
                      style: {
                        "body": Style(
                          fontSize: FontSize(18.sp),
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
                          linkUrl: facebookUrl,
                        ),
                        SocialCircleButton(
                          imageUrl: AppImage.instagram,
                          linkUrl: instagramUrl,
                        ),
                        SocialCircleButton(
                          imageUrl: AppImage.whatsapp,
                          linkUrl: whatsappUrl,
                        ),
                        SocialCircleButton(
                          imageUrl: AppImage.line,
                          linkUrl: lineUrl,
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
                            value: hotline,
                            copyValue: hotline,
                            dividerColor: AppColor.border,
                          ),
                          TextWithCopyIcon(
                            label: 'Email:',
                            value: email,
                            copyValue: email,
                            dividerColor: AppColor.border,
                          ),
                          TextWithCopyIcon(
                            label: 'Zalo:',
                            value: zalo,
                            copyValue: zalo,
                            dividerColor: AppColor.border,
                          ),
                          TextWithCopyIcon(
                            label: 'Facebook:',
                            value: facebookDisplay,
                            copyValue: facebookUrl,
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

final List<SettingsEntity> mockContactSettings = [
  SettingsEntity(
    id: 1,
    settingKey: 'address',
    settingName: 'Địa chỉ liên hệ',
    plainValue: '''
<p>
<b>SciFun – Học tập khoa học thú vị</b><br>
Chúng tôi luôn sẵn sàng hỗ trợ bạn trong quá trình học tập.
Nếu có bất kỳ thắc mắc hoặc góp ý nào, vui lòng liên hệ qua các kênh bên dưới.
</p>
<p>
📍 Địa chỉ: 123 Đường Khoa Học, Quận Tri Thức, TP. Học Tập<br>
📞 Hotline: 0123 456 789<br>
📧 Email: support@scifun.vn
</p>
''',
    desc: '',
    typeInput: 0,
    typeData: null,
    group: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  SettingsEntity(
    id: 2,
    settingKey: 'hotline',
    settingName: 'Hotline',
    plainValue: '0123 456 789',
    desc: '',
    typeInput: 0,
    typeData: null,
    group: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  SettingsEntity(
    id: 3,
    settingKey: 'email',
    settingName: 'Email hỗ trợ',
    plainValue: 'support@scifun.vn',
    desc: '',
    typeInput: 0,
    typeData: null,
    group: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  SettingsEntity(
    id: 4,
    settingKey: 'facebook',
    settingName: 'Facebook',
    plainValue: 'https://www.facebook.com/scifun',
    desc: '',
    typeInput: 0,
    typeData: null,
    group: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
  SettingsEntity(
    id: 5,
    settingKey: 'zalo',
    settingName: 'Zalo',
    plainValue: '0123 456 789',
    desc: '',
    typeInput: 0,
    typeData: null,
    group: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
];

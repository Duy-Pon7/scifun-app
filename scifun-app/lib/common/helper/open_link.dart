import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openLink({required String link}) async {
  try {
    await launchUrl(Uri.parse(link));
  } catch (e) {
    EasyLoading.showToast('Mở link thất bại');
  }
}
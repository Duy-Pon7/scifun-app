import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/widget/change_confirm_dialog.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';
import 'package:sci_fun/features/profile/presentation/page/guest_sync/guest_sync_procedure_page.dart';

const String kGuestRestrictedFeatureMessage =
    'Vui l\u00f2ng \u0111\u1ed3ng b\u1ed9 t\u00e0i kho\u1ea3n \u0111\u1ec3 d\u00f9ng ch\u1ee9c n\u0103ng n\u00e0y nha!';

Future<bool> isGuestAccount(BuildContext context) async {
  try {
    final userState = context.read<UserCubit>().state;
    if (userState is UserLoaded) {
      return userState.user.data?.isGuest == true;
    }
  } catch (_) {
    // UserCubit may be unavailable in some navigation contexts.
  }

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  if (token == null || token.isEmpty) {
    return false;
  }

  try {
    final parts = token.split('.');
    if (parts.length < 2) {
      return false;
    }

    final payload = utf8.decode(
      base64Url.decode(base64Url.normalize(parts[1])),
    );
    final map = jsonDecode(payload);
    if (map is! Map<String, dynamic>) {
      return false;
    }

    final claim = map['isGuest'];
    if (claim is bool) {
      return claim;
    }
    if (claim is String) {
      return claim.toLowerCase() == 'true';
    }

    return false;
  } catch (_) {
    return false;
  }
}

Future<bool> guardGuestRestrictedFeature(
  BuildContext context, {
  String title = '\u0110\u1ed3ng b\u1ed9 t\u00e0i kho\u1ea3n \u0111\u1ec3 ti\u1ebfp t\u1ee5c',
  String message = kGuestRestrictedFeatureMessage,
}) async {
  final isGuest = await isGuestAccount(context);
  if (!context.mounted) {
    return false;
  }
  if (!isGuest) {
    return true;
  }

  final shouldOpenSync = await showGuestSyncRequiredDialog(
    context: context,
    titleText: title,
    messageText: message,
  );

  if (shouldOpenSync == true && context.mounted) {
    Navigator.push(
      context,
      slidePage(const GuestSyncProcedurePage()),
    );
  }

  return false;
}

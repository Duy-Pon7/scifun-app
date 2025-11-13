import 'dart:ui';

import 'package:flutter/material.dart';

enum PackageStatus { pending, active, rejected }

extension PackageStatusX on PackageStatus {
  String get description {
    switch (this) {
      case PackageStatus.pending:
        return 'Chờ duyệt';
      case PackageStatus.active:
        return 'Đã duyệt';
      case PackageStatus.rejected:
        return 'Đã huỷ';
    }
  }

  Color get color {
    switch (this) {
      case PackageStatus.pending:
        return Color(0xFF007AFF);
      case PackageStatus.active:
        return Color(0xFF34C759);
      case PackageStatus.rejected:
        return Color(0xFFB10503);
    }
  }

  /// Chuyển string thành enum
  static PackageStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'pending':
        return PackageStatus.pending;
      case 'active':
        return PackageStatus.active;
      case 'rejected':
        return PackageStatus.rejected;
      default:
        return PackageStatus.pending; // default fallback
    }
  }
}

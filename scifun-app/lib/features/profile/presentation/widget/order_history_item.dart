import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/profile/domain/entities/order_history_entity.dart';

class OrderHistoryItem extends StatelessWidget {
  const OrderHistoryItem({
    super.key,
    required this.order,
  });

  final UserOrderEntity order;

  @override
  Widget build(BuildContext context) {
    final status = (order.status ?? '').toUpperCase();

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColor.skyblue50,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColor.skyblue100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _buildPlanTitle(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _statusColor(status).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  _statusLabel(status),
                  style: TextStyle(
                    color: _statusColor(status),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          _line(
            context: context,
            label: 'Số tiền',
            value: _formatAmount(),
          ),
          SizedBox(height: 6.h),
          _line(
            context: context,
            label: 'Cổng thanh toán',
            value: _buildProviderInfo(),
          ),
          SizedBox(height: 6.h),
          _line(
            context: context,
            label: 'Thời gian',
            value: _formatDate(order.createdAt),
          ),
        ],
      ),
    );
  }

  Widget _line({
    required BuildContext context,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 108.w,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  String _buildPlanTitle() {
    final tier = order.planTier?.trim();
    final period = order.period?.trim();
    final type = order.type?.trim();

    final title = <String>[
      if (tier != null && tier.isNotEmpty) tier,
      if (period != null && period.isNotEmpty) period,
    ].join(' - ');

    if (title.isNotEmpty) {
      return title;
    }
    if (type != null && type.isNotEmpty) {
      return type;
    }
    return 'Gói cước';
  }

  String _buildProviderInfo() {
    final provider = order.provider?.trim();
    final providerRef = order.providerRef?.trim();
    if ((provider ?? '').isEmpty && (providerRef ?? '').isEmpty) {
      return '--';
    }
    if ((provider ?? '').isEmpty) {
      return providerRef!;
    }
    if ((providerRef ?? '').isEmpty) {
      return provider!;
    }
    return '$provider - $providerRef';
  }

  String _formatAmount() {
    final symbol =
        (order.currency ?? '').trim().isEmpty ? 'VND' : order.currency!;
    final formatted = NumberFormat.currency(
      locale: 'vi_VN',
      decimalDigits: 0,
      symbol: '',
    ).format(order.total);

    return '${formatted.trim()} $symbol';
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '--';
    }
    return DateFormat('dd/MM/yyyy HH:mm').format(date.toLocal());
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'PAID':
        return 'Đã thanh toán';
      case 'PENDING':
        return 'Đang chờ';
      case 'FAILED':
      case 'CANCELED':
      case 'CANCELLED':
        return 'Thất bại';
      default:
        return status.isEmpty ? '--' : status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'PAID':
        return const Color(0xFF16A34A);
      case 'PENDING':
        return const Color(0xFFEA580C);
      case 'FAILED':
      case 'CANCELED':
      case 'CANCELLED':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF6B7280);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';

class PaymentInfoCard extends StatefulWidget {
  final String title;
  final String description;
  final String price;
  final String bankName;
  final String bankAccount;
  final String accountHolder;
  final String paymentSyntax;
  const PaymentInfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.bankName,
    required this.bankAccount,
    required this.accountHolder,
    required this.paymentSyntax,
  });

  @override
  State<PaymentInfoCard> createState() => _PaymentInfoCardState();
}

class _PaymentInfoCardState extends State<PaymentInfoCard> {
  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ')
        .format(double.tryParse(widget.price) ?? 0);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Color(0x1AFF0300),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        spacing: 24.h,
        children: [
          _infoRow("Gói: ${widget.title}", "Tổng tiền: $formattedPrice",
              widget.price),
          _infoRow("Mô tả:", widget.description, widget.description),
          _infoRow("Thụ hưởng:", widget.bankAccount, widget.bankAccount),
          _infoRow("Ngân hàng:", widget.bankName, widget.bankName),
          _infoRow("STK:", widget.accountHolder, widget.accountHolder),
          _infoRow("Nội dung:", widget.paymentSyntax, widget.paymentSyntax),
        ],
      ),
    );
  }

  Widget _infoRow(String? title, String? subtitle, String copyText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              if (subtitle != null)
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    subtitle,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColor.hurricane800.withValues(alpha: 0.6),
                        ),
                  ),
                ),
            ],
          ),
        ),
        IconButton(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: copyText));
            EasyLoading.showToast(
                toastPosition: EasyLoadingToastPosition.bottom,
                'Đã sao chép vào clipboard');
          },
          icon: Icon(
            Icons.copy_rounded,
            color: AppColor.hurricane800.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

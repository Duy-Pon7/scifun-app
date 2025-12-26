import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';

class PolicyPage extends StatelessWidget {
  final String? plainValue;
  const PolicyPage({super.key, required this.plainValue});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: BasicAppbar(
          title: "Chính sách",
          showTitle: true,
          showBack: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Html(
                data: mockPolicyHtml,
                style: {
                  "body": Style(
                    fontSize: FontSize(16.sp),
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                  "p": Style(margin: Margins.only(bottom: 12)),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final String mockPolicyHtml = """
<h2>Chính sách & Điều khoản sử dụng</h2>

<p>
Chào mừng bạn đến với ứng dụng <strong>Sci Fun</strong>.
Khi sử dụng ứng dụng này, bạn đồng ý tuân thủ các điều khoản và chính sách được nêu dưới đây.
</p>

<h3>1. Thu thập thông tin</h3>
<p>
Chúng tôi có thể thu thập một số thông tin cơ bản nhằm cải thiện trải nghiệm người dùng, bao gồm:
</p>
<ul>
  <li>Thông tin thiết bị (loại thiết bị, hệ điều hành)</li>
  <li>Dữ liệu sử dụng ứng dụng</li>
  <li>Thông tin phản hồi từ người dùng</li>
</ul>

<h3>2. Mục đích sử dụng thông tin</h3>
<p>
Thông tin thu thập được sử dụng cho các mục đích sau:
</p>
<ul>
  <li>Cải thiện chất lượng nội dung học tập</li>
  <li>Nâng cao hiệu suất và độ ổn định của ứng dụng</li>
  <li>Hỗ trợ người dùng khi cần thiết</li>
</ul>

<h3>3. Bảo mật thông tin</h3>
<p>
Chúng tôi cam kết bảo mật thông tin cá nhân của người dùng và không chia sẻ cho bên thứ ba
nếu không có sự đồng ý của bạn, trừ trường hợp pháp luật yêu cầu.
</p>

<h3>4. Quyền và nghĩa vụ của người dùng</h3>
<p>
Người dùng có trách nhiệm:
</p>
<ul>
  <li>Sử dụng ứng dụng đúng mục đích giáo dục</li>
  <li>Không sao chép hoặc phát tán nội dung trái phép</li>
  <li>Tuân thủ các quy định pháp luật hiện hành</li>
</ul>

<h3>5. Thay đổi chính sách</h3>
<p>
Chính sách này có thể được cập nhật theo thời gian.
Mọi thay đổi sẽ được thông báo trực tiếp trong ứng dụng.
</p>

<p><em>Cảm ơn bạn đã tin tưởng và sử dụng ứng dụng Sci Fun!</em></p>
""";

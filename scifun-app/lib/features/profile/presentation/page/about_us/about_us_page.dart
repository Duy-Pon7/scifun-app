import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/utils/assets/app_image.dart';

class AboutUsPage extends StatelessWidget {
  final String? plainValue;
  const AboutUsPage({super.key, required this.plainValue});

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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.asset(
                    AppImage.aboutus,
                    width: double.infinity,
                    height: 260.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              Html(
                data:
                    '''<p>Hiện nay, Internet và thiết bị di động phủ sóng rộng khắp; học sinh, sinh viên dành phần lớn thời gian trên các nền tảng số và mạng xã hội. Nội dung khoa học xuất hiện rất nhiều nhưng phân tán, không đồng nhất chất lượng, thậm chí có thông tin sai lệch do ảnh hưởng của AI tạo sinh và tin giả. Người học dễ bị quá tải thông tin, khó hệ thống hóa kiến thức và duy trì hứng thú lâu dài.</p><p>Bên cạnh đó, giáo dục hiện nay chú trọng năng lực STEM, học qua trải nghiệm và tự học có hướng dẫn. Giáo viên và quản trị cần công cụ số để giao bài, tạo quiz, theo dõi tiến độ – thống kê, còn người học cần lộ trình cá nhân hóa, phản hồi tức thời. Tuy nhiên, các nguồn học liệu tiếng Việt còn rời rạc; nhiều nền tảng thiên về luyện thi, thiếu tính tương tác và trò-chơi-hóa giúp khơi gợi tò mò khoa học.</p><p>Nhận thức thực tiễn ấy và mong muốn mang kiến thức khoa học tự nhiên đến gần người học theo cách hấp dẫn, đáng tin cậy và đo lường được, nhóm chúng em quyết định chọn đề tài tiểu luận chuyên ngành: “ỨNG DỤNG HỌC TẬP KIẾN THỨC THÚ VỊ VỀ KHOA HỌC TỰ NHIÊN – SCIFUN.”</p><p>SciFun tập trung chuẩn hóa & tập trung học liệu, kết hợp video minh họa – thí nghiệm ảo – quiz, cung cấp thống kê/tiến độ và cá nhân hóa lộ trình, hoạt động đa nền tảng với phân quyền User/Admin. Vì vậy, việc xây dựng SciFun là cấp thiết để nâng cao hiệu quả tự học khoa học, hỗ trợ dạy học số và góp phần lan tỏa văn hóa học tập suốt đời.</p>''',
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/helper/transition_page.dart';
import 'package:sci_fun/common/page/topic_page.dart';
import 'package:sci_fun/common/widget/basic_text_button.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/usecase.dart';
import 'package:sci_fun/features/home/domain/entity/news_entity.dart';
import 'package:sci_fun/features/home/domain/usecase/get_all_news.dart';
import 'package:sci_fun/features/home/presentation/cubit/news_cubit.dart';
import 'package:sci_fun/features/home/presentation/page/news_page.dart';
import 'package:sci_fun/features/home/presentation/widget/news_item.dart';

class ListNews extends StatelessWidget {
  const ListNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Tin tức",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            BasicTextButton(
              text: "Xem thêm",
              onPressed: () {
                Navigator.push(
                  context,
                  slidePage(
                    TopicPage<NewsEntity, void>(
                      title: 'Tin tức',
                      param: PaginationParam<void>(page: 1),
                      usecase: sl<GetAllNews>(),
                      itemBuilder: (context, news) => NewsItem(
                        image: news.image ?? "",
                        title: news.title ?? "Chưa có",
                        createdAt: news.postedAt ?? DateTime.now(),
                        description: news.excerpt ?? "Chưa có",
                        onTap: () => Navigator.push(
                          context,
                          slidePage(NewsPage(
                            newsId: news.id ?? 0,
                            title: news.title ?? "",
                            createdAt: news.postedAt ?? DateTime.now(),
                            image: news.image ?? "",
                            content: news.content ?? "",
                          )),
                        ),
                      ),
                    ),
                  ),
                );
              },
              textColor: Colors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
            )
          ],
        ),
        BlocBuilder<NewsCubit, NewsState>(
          builder: (context, state) {
            if (state is NewsLoaded) {
              return Column(
                spacing: 12.h,
                children: state.newsList.map((item) {
                  return NewsItem(
                    image: item.image ?? "",
                    title: item.title ?? "Chưa có",
                    createdAt: item.postedAt ?? DateTime.now(),
                    description: item.excerpt ?? "Chưa có",
                    onTap: () {
                      Navigator.push(
                        context,
                        slidePage(NewsPage(
                          newsId: item.id ?? 0,
                          title: item.title ?? "",
                          createdAt: item.postedAt ?? DateTime.now(),
                          image: item.image ?? "",
                          content: item.content ?? "",
                        )),
                      );
                    },
                  );
                }).toList(),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

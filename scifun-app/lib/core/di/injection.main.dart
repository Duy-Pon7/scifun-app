part of 'injection.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //core
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  await dotenv.load(fileName: ".env");
  await ScreenUtil.ensureScreenSize();
  FlutterNativeSplash.remove();
  final sharedPrefs = await SharedPreferences.getInstance();
  sl
    ..registerLazySingleton(() => SharePrefsService(prefs: sharedPrefs))
    ..registerLazySingleton(
        () => CheckTokenInterceptor(sharePrefsService: sl()))
    ..registerLazySingleton(() => DioClient(checkTokenInterceptor: sl()))
    ..registerLazySingleton(
        () => IsAuthorizedCubit(sharePrefsService: sl<SharePrefsService>()))
    ..registerLazySingleton(() => NavigatorKeyService())
    ..registerFactory(() => ObscureTextCubit())
    ..registerLazySingleton<DashboardCubit>(() => DashboardCubit())
    ..registerFactory(() => SelectImageCubit())
    ..registerFactory(() => OtpCubit(sl()))
    ..registerFactory(() => SelectTabCubit())
    ..registerFactory(() => CountdownCubit(totalSeconds: sl()))
    ..registerFactory<SubjectRemoteDatasource>(
      () => SubjectRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerFactory<SubjectRepository>(
      () => SubjectRepositoryImpl(
        subjectRemoteDatasource: sl<SubjectRemoteDatasource>(),
      ),
    )
    ..registerFactory(
      () => GetAllSubjects(subjectRepository: sl<SubjectRepository>()),
    )
    ..registerFactory(() => SubjectCubit(getAllSubjects: sl<GetAllSubjects>()));
  // Other
  await _authInit();
  await _topicInit();
  await _addressInti();
  await _notiInti();
  await _statisticsInti();
  await _profile();
  _homeInit();
  _questionInit();
  _videoInit();
  _leaderboardInit();
}

Future<void> _profile() async {
  sl
    ..registerFactory<UserRemoteDatasource>(
        () => UserRemoteDatasourceImpl(dioClient: sl()))
    ..registerFactory<UserRepository>(
        () => UserRepositoryImpl(userRemoteDatasource: sl()))
    ..registerFactory(() => GetInfoUser(userRepository: sl()))
    ..registerFactory(() => UpdateInfoUser(userRepository: sl()))
    ..registerFactory(() => UserCubit(
          getInfoUser: sl(),
          updateInfoUser: sl(),
        ))
    // ..registerFactory(() => Changes(userRepository: sl()))
    // ..registerLazySingleton(() => UserBloc(
    //       change: sl(),
    //     ))

    //Packages
    ..registerFactory<PackagesRemoteDatasource>(
        () => PackagesRemoteDatasourceImpl(dioClient: sl()))
    ..registerFactory<PackagesRepository>(
        () => PackagesRepositoryImpl(packagesRemoteDatasource: sl()))
    ..registerFactory(() => GetPackages(packagesRepository: sl()))
    ..registerFactory(() => BuyPackagesUseCase(repository: sl()))
    ..registerFactory(() => GetInstructions(packagesRepository: sl()))
    ..registerFactory(() => GetHistoryPackages(packagesRepository: sl()))
    ..registerLazySingleton(() => PackageBloc(
          getPackage: sl(),
          buyPackages: sl(),
          getInstructions: sl(),
        ));
}

Future<void> _statisticsInti() async {
  sl
    ..registerFactory<ProgressRemoteDatasource>(
        () => ProgressRemoteDatasourceImpl(dioClient: sl()))
    ..registerFactory<ProgressRepository>(
        () => ProgressRepositoryImpl(progressRemoteDatasource: sl()))
    ..registerFactory(() => GetProgress(progressRepository: sl()))
    ..registerLazySingleton(() => ProgressCubit(getProgress: sl()));
}

Future<void> _topicInit() async {
  sl
    ..registerFactory<TopicRemoteDatasource>(
        () => TopicRemoteDatasourceImpl(dioClient: sl()))
    ..registerFactory<TopicRepository>(
        () => TopicRepositoryImpl(topicRemoteDatasource: sl()))
    ..registerFactory(() => GetAllTopics(topicRepository: sl()))
    ..registerLazySingleton(() => TopicCubit(sl()));
}

Future<void> _notiInti() async {
  sl
    ..registerFactory<NotificationRemoteDatasource>(
        () => NotificationRemoteDatasourceImpl(dioClient: sl()))
    ..registerFactory<NotificationRepository>(
        () => NotificationRepositoryImpl(notificationRemoteDatasource: sl()))
    ..registerFactory(() => GetNotifications(sl()))
    ..registerFactory(() => GetNotificationDetail(sl()))
    ..registerFactory(() => MarkAsRead(sl()))
    ..registerFactory(() => MarkAsReadAll(sl()))
    ..registerFactory(() => DeleteNotification(sl()));
}

Future<void> _addressInti() async {
  sl
    ..registerFactory<AddressRemoteDatasource>(
        () => AddressRemoteDatasourceImpl(dioClient: sl()))
    ..registerFactory<AddressRepository>(
        () => AddressRepositoryImpl(addressRemoteDatasource: sl()))
    ..registerFactory(() => GetProvinces(sl()))
    ..registerFactory(() => GetWards(sl()))
    ..registerLazySingleton(() => AddressCubit(sl(), sl()));
}

Future<void> _authInit() async {
  sl
    ..registerFactory<AuthRemoteDatasource>(() =>
        AuthRemoteDatasourceImpl(dioClient: sl(), sharePrefsService: sl()))
    ..registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(authRemoteDatasource: sl()))
    ..registerFactory(() => Login(authRepository: sl()))
    ..registerFactory(() => Signup(authRepository: sl()))
    ..registerFactory(() => SendEmail(authRepository: sl()))
    ..registerFactory(() => ChangePassword(authRepository: sl()))
    ..registerFactory(() => CheckEmailPhone(authRepository: sl()))
    ..registerFactory(() => ResendOtp(authRepository: sl()))
    ..registerFactory(() => VerificationOtp(authRepository: sl()))
    ..registerFactory(() => CheckedCubit())
    // ..registerFactory(() => ObscureTextCubit())
    // ..registerFactory(() => SelectGendersCubit())
    ..registerFactory(() => GetAuth(authRepository: sl()))
    ..registerFactory(() => AuthBloc(
          login: sl(),
          signup: sl(),
          sendEmail: sl(),
          resendOtp: sl(),
          verificationOtp: sl(),
          checkEmailPhone: sl(),
          getAuth: sl(),
          changPass: sl(),
          // change: sl(),
        ));
}

void _homeInit() {
  sl
    ..registerFactory<NewsRemoteDatasource>(
      () => NewsRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerFactory<NewsRepository>(
      () => NewsRepositoryImpl(
        newsRemoteDatasource: sl<NewsRemoteDatasource>(),
      ),
    )
    ..registerFactory(
      () => GetAllNews(newsRepository: sl<NewsRepository>()),
    )
    ..registerFactory(
      () => GetNewsDetail(newsRepository: sl<NewsRepository>()),
    )
    ..registerFactory(
      () => NewsCubit(sl<GetAllNews>(), sl<GetNewsDetail>()),
    )
    ..registerFactory<LessonCategoryRemoteDatasource>(
      () => LessonCategoryRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerFactory<LessonCategoryRepository>(
      () => LessonCategoryRepositoryImpl(
        lessonCategoryRemoteDatasource: sl<LessonCategoryRemoteDatasource>(),
      ),
    )
    ..registerFactory(
      () => GetLessonCategory(
          lessonCategoryRepository: sl<LessonCategoryRepository>()),
    )
    // ..registerFactory<LessonRemoteDatasource>(
    //   () => LessonRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    // )
    // ..registerFactory<LessonRepository>(
    //   () => LessonRepositoryImpl(
    //     lessonRemoteDatasource: sl<LessonRemoteDatasource>(),
    //   ),
    // )
    // ..registerFactory(
    //   () => GetListLesson(lessonRepository: sl<LessonRepository>()),
    // )
    // ..registerFactory(
    //   () => GetKeyListLesson(lessonRepository: sl<LessonRepository>()),
    // )
    // ..registerFactory(
    //   () => GetSubjectProgress(lessonRepository: sl<LessonRepository>()),
    // )
    // ..registerFactory(
    //   () => GetLessonDetail(lessonRepository: sl<LessonRepository>()),
    // )
    // ..registerFactory(
    //   () => LessonCubit(sl<GetLessonDetail>(), sl<GetLessonCategory>()),
    // )
    ..registerFactory<QuizzRemoteDatasource>(
      () => QuizzRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerFactory<QuizzRepository>(
      () => QuizzRepositoryImpl(
        quizzRemoteDatasource: sl<QuizzRemoteDatasource>(),
      ),
    )
    ..registerFactory(
      () => GetAllQuizzes(quizzRepository: sl<QuizzRepository>()),
    )
    ..registerFactory(
      () => GetTrendQuizzes(quizzRepository: sl<QuizzRepository>()),
    )
    ..registerFactory(
      () => quizz_get_submission_detail.GetSubmissionDetail(
          quizzRepository: sl<QuizzRepository>()),
    )
    ..registerFactory(
      () => TrendQuizzCubit(sl<GetTrendQuizzes>()),
    )
    ..registerFactory(
      () => QuizzCubit(sl<GetAllQuizzes>()),
    );
}

void _questionInit() {
  sl
    ..registerFactory<QuestionRemoteDatasource>(
      () => QuestionRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerFactory<QuestionRepository>(
      () => QuestionRepositoryImpl(
        questionRemoteDatasource: sl<QuestionRemoteDatasource>(),
      ),
    )
    ..registerFactory(
      () => GetAllQuestions(questionRepository: sl<QuestionRepository>()),
    )
    ..registerFactory(
      () => SubmitQuiz(questionRepository: sl<QuestionRepository>()),
    )
    ..registerFactory(
      () => GetSubmissionDetail(questionRepository: sl<QuestionRepository>()),
    );
}

void _leaderboardInit() {
  sl
    ..registerFactory<LeaderboardRemoteDatasource>(
      () => LeaderboardRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerFactory<LeaderboardRepository>(
      () => LeaderboardRepositoryImpl(
        leaderboardRemoteDatasource: sl<LeaderboardRemoteDatasource>(),
      ),
    )
    ..registerFactory(
      () => GetLeaderboard(leaderboardRepository: sl<LeaderboardRepository>()),
    )
    ..registerFactory(
      () => RebuildLeaderboard(
          leaderboardRepository: sl<LeaderboardRepository>()),
    )
    ..registerFactory(
      () => LeaderboardsCubit(
        getLeaderboard: sl<GetLeaderboard>(),
        rebuildLeaderboard: sl<RebuildLeaderboard>(),
      ),
    );
}

void _videoInit() {
  sl
    ..registerFactory<VideoRemoteDatasource>(
      () => VideoRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerFactory<VideoRepository>(
      () => VideoRepositoryImpl(
        videoRemoteDatasource: sl<VideoRemoteDatasource>(),
      ),
    )
    ..registerFactory(
      () => GetAllVideos(videoRepository: sl<VideoRepository>()),
    )
    ..registerFactory(
      () => VideoPaginationCubit(sl<GetAllVideos>()),
    );
}

void resetSingleton() {
  sl
    ..resetLazySingleton<SharePrefsService>()
    ..resetLazySingleton<NavigatorKeyService>()
    ..resetLazySingleton<DashboardCubit>()
    // ..resetLazySingleton<IsAuthorizedCubit>()
    ..resetLazySingleton<DioClient>();
}

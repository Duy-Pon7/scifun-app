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
    ..registerFactory(() => QuizzCubit(sl<GetQuizzDetail>(), sl<AddQuizz>(),
        sl<GetQuizzExamsets>(), sl<GetQuizzByLesson>()))
    ..registerLazySingleton(() => QuizzResultPaginatorCubit(
          usecase: sl(),
          quizzId: sl(),
        ))
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
  await _addressInti();
  await _notiInti();
  await _examInti();
  await _statisticsInti();
  await _profile();
  _homeInit();
}

Future<void> _profile() async {
  sl
    ..registerFactory<UserRemoteDatasource>(
        () => UserRemoteDatasourceImpl(dioClient: sl()))
    ..registerFactory<UserRepository>(
        () => UserRepositoryImpl(userRemoteDatasource: sl()))
    ..registerFactory(() => Changes(userRepository: sl()))
    ..registerLazySingleton(() => UserBloc(
          change: sl(),
        ))

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
        ))
    ..registerLazySingleton(() => PackageHistoryCubit(
          getHistoryPackages: sl(),
        ))

    //Settings
    ..registerFactory<SettingsRemoteDatasource>(
        () => SettingsRemoteDatasourceImpl(dioClient: sl()))
    ..registerFactory<SettingsRepository>(
        () => SettingsRepositoryImpl(settingsRemoteDatasource: sl()))
    ..registerFactory(() => GetSettings(settingsRepository: sl()))
    ..registerLazySingleton(() => SettingsCubit(
          sl<GetSettings>(),
        ))
    //Faqs
    ..registerFactory<FaqsRemoteDatasource>(
        () => FaqsRemoteDatasourceImpl(dioClient: sl()))
    ..registerFactory<FaqsRepository>(
        () => FaqsRepositoryImpl(faqsRemoteDatasource: sl()))
    ..registerFactory(() => GetFaqs(faqsRepository: sl()))
    ..registerLazySingleton(() => FaqsCubit(
          sl<GetFaqs>(),
        ));
}

Future<void> _examInti() async {
  sl
    ..registerFactory<ExamsetRemoteDatasource>(
        () => ExamsetRemoteDatasourceImpl(dioClient: sl()))
    ..registerFactory<ExamsetRepository>(
        () => ExamsetRepositoryImpl(examsetRemoteDatasource: sl()))
    ..registerFactory(() => GetExamset(sl()))
    ..registerLazySingleton(() => ExamsetPaginatorCubit(
          sl(),
        ))
    ..registerLazySingleton(() => ExamsetCubit(sl()));
}

Future<void> _statisticsInti() async {
  sl
    ..registerFactory<SchoolRemoteDatasource>(
        () => SchoolRemoteDatasourceImpl(dioClient: sl()))
    ..registerFactory<SchoolRepository>(
        () => SchoolRepositoryImpl(schoolRemoteDatasource: sl()))
    ..registerFactory(() => GetSchool(sl()))
    ..registerFactory(
      () => GetListSchool(schoolRepository: sl<SchoolRepository>()),
    )
    ..registerFactory(
      () => GetListSchoolData(schoolRepository: sl<SchoolRepository>()),
    )
    ..registerLazySingleton(() => SchoolCubit(sl()))
    ..registerLazySingleton(() => SchoolPaginatorCubit(sl()));
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
    ..registerFactory(() => DeleteNotification(sl()))
    ..registerLazySingleton(() => NotificationPaginatorCubit(
          sl(),
        ))
    ..registerLazySingleton(() => NotiCubit(sl(), sl(), sl(), sl()));
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
    ..registerFactory<AuthRemoteDatasource>(
        () => AuthRemoteDatasourceImpl(dioClient: sl()))
    ..registerFactory<AuthRepository>(() =>
        AuthRepositoryImpl(authRemoteDatasource: sl(), sharePrefsService: sl()))
    ..registerFactory(() => Login(authRepository: sl()))
    ..registerFactory(() => Signup(authRepository: sl()))
    ..registerFactory(() => SendEmail(authRepository: sl()))
    ..registerFactory(() => VerifyOtp(authRepository: sl()))
    ..registerFactory(() => ResetPassword(authRepository: sl()))
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
          verifyOtp: sl(),
          resetPassword: sl(),
          resendOtp: sl(),
          verificationOtp: sl(),
          checkEmailPhone: sl(),
          getAuth: sl(),
          changPass: sl(),
          change: sl(),
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
    ..registerFactory<LessonRemoteDatasource>(
      () => LessonRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerFactory<LessonRepository>(
      () => LessonRepositoryImpl(
        lessonRemoteDatasource: sl<LessonRemoteDatasource>(),
      ),
    )
    ..registerFactory(
      () => GetListLesson(lessonRepository: sl<LessonRepository>()),
    )
    ..registerFactory(
      () => GetKeyListLesson(lessonRepository: sl<LessonRepository>()),
    )
    ..registerFactory(
      () => GetSubjectProgress(lessonRepository: sl<LessonRepository>()),
    )
    ..registerFactory(
      () => GetLessonDetail(lessonRepository: sl<LessonRepository>()),
    )
    ..registerFactory(
      () => ProgressCubit(sl<GetSubjectProgress>()),
    )
    ..registerFactory(
      () => LessonCubit(sl<GetLessonDetail>(), sl<GetLessonCategory>()),
    )
    ..registerFactory<QuizzRemoteDatasource>(
      () => QuizzRemoteDatasourceImpl(dioClient: sl<DioClient>()),
    )
    ..registerFactory<QuizzRepository>(
      () => QuizzRepositoryImpl(
        quizzRemoteDatasource: sl<QuizzRemoteDatasource>(),
      ),
    )
    ..registerFactory(
      () => GetQuizzResult(quizzRepository: sl<QuizzRepository>()),
    )
    ..registerFactory(
      () => GetQuizzByCate(quizzRepository: sl<QuizzRepository>()),
    )
    ..registerFactory(
      () => GetQuizzByLesson(quizzRepository: sl<QuizzRepository>()),
    )
    ..registerFactory(
      () => GetQuizzDetail(quizzRepository: sl<QuizzRepository>()),
    )
    ..registerFactory(
      () => GetQuizzExamsets(quizzRepository: sl<ExamsetRepository>()),
    )
    ..registerFactory(
      () => AddQuizz(quizzRepository: sl<QuizzRepository>()),
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

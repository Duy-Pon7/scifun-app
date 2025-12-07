//! Chưa làm
//? Còn vấn đề
// Hoàn thành
class AuthApiUrls {
  AuthApiUrls._();
  //? Kiểm tra sao nó hiển thị lỗi lúc mới vào và check token trong thời gian bao lâu
  static const String login = '/user/login'; //
  static const String signup = '/user/register'; //
  static const String verificationOtp = '/user/verify-otp'; //

  static const String forgotPassword = '/user/forgot-password'; //!
  static const String updatePassword = '/user/update-password'; //!
  static const String sendEmail = '/user/resend-otp';
  static const String resendOtp = '/user/resend-otp';
  static const String checkEmailPhone = '/user/check-email-phone';
  static const String getAuth = '/user/get-user/';
}

class UserApiUrls {
  UserApiUrls._();
  static const String getInfo = '/user/get-user/'; //
  //? Còn đang hiển thị lỗi change info. Chưa hoạt động
  static const String updateInfo = '/user/update-user/'; //
  static const String reviseInfo = '/users/update';
  static const String changePassword = '/auth/change-password';
}

class SubjectApiUrl {
  SubjectApiUrl._();
  //? Còn thiếu search ở ngoài là chỉ search theo chủ đề yêu thích
  static const String getSubjects = '/subject/get-subjects'; //
}

class TopicApiUrl {
  TopicApiUrl._();
  static const String getTopics = '/topic/get-topics'; //
}

class QuizApiUrl {
  QuizApiUrl._();

  static const String getQuizzes = '/quiz/get-quizzes'; //
}

class QuestionApiUrl {
  QuestionApiUrl._();

  static const String getQuestions = '/question/get-questions'; //!
  static const String getQuestionById = '/question/get-questionById'; //!
}

class SubmissionApiUrl {
  SubmissionApiUrl._();

  static const String postSubmission = '/submission/handle-submit'; //!
  static const String getSubmissionDetail =
      '/submission/get-submissionDetail'; //!
  static const String getUserProgress = '/user-progress'; //
}
//? ----------------------------------------------------------

class NotificationApiUrls {
  NotificationApiUrls._();

  static const String getAllNotifications = '/notifications/get-all';
  static const String getNotifications = '/notifications';
  static const String deleteNoti = '/notifications';
  static const String markAsRead = '/notifications/read';
  static const String markAsReadAll = '/notifications/read-all';
}

class HomeApiUrls {
  HomeApiUrls._();

  static const String getNews = '/posts';
  static const String getLessonCategory = '/lesson-categories';
  static const String getLesson = '/lessons';
  static const String getQuizzByCate = '/quizzes';
  static const String getResultQuizz = '/quiz-results';
  static const String addQuizz = '/quizzes/score/multiple-choice';
}

class PackagesApiUrl {
  PackagesApiUrl._();

  static const String getPackages = '/packages';
  static const String buyPackages = '/packages/buy';
  static const String instructionsPackages = '/packages/instructions';
  static const String historyPackages = '/packages/notifications';
}

class SettingsApiUrl {
  SettingsApiUrl._();

  static const String getSettings = '/settings/general';
}

class FaqsApiUrl {
  FaqsApiUrl._();

  static const String getFaqs = '/faqs';
}

class AddressApiUrl {
  AddressApiUrl._();

  static const String getProvinces = '/address/provinces';
  static const String getWards = '/address/wards';
}

class SchoolApiUrl {
  SchoolApiUrl._();

  static const String getSchoolScore = '/school-scores';
  static const String getSchoolScoreData = '/school-scores/scores';
  static const String getListSchool = '/schools';
}

class ExamsetApiUrl {
  ExamsetApiUrl._();

  static const String getExamset = '/exam-sets';
  static const String getExamsetQuizz = '/exam-sets/search';
}

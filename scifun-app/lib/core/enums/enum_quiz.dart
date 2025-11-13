enum EnumQuiz { completed, notComplete, waitting }

extension EnumQuizX on EnumQuiz {
  String get description {
    switch (this) {
      case EnumQuiz.completed:
        return 'Đã hoàn thành Đã hoàn thành Đã hoàn thành';
      case EnumQuiz.notComplete:
        return 'Chưa hoàn thành';
      case EnumQuiz.waitting:
        return 'Đang chấm';
    }
  }
}

EnumQuiz toEnumQuiz({required String status}) {
  switch (status) {
    case 'completed':
      return EnumQuiz.completed;
    case 'not_complete':
      return EnumQuiz.notComplete;
    case 'waitting':
      return EnumQuiz.waitting;
    default:
      return EnumQuiz.notComplete;
  }
}

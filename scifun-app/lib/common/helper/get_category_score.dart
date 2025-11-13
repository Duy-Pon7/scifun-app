String getCategoryScore(int score) {
  if (score >= 9 && score <= 10) {
    return "Xuất sắc"; // Xuất sắc
  } else if (score >= 8 && score < 9) {
    return "Giỏi"; // Giỏi
  } else if (score >= 6.5 && score < 8) {
    return "Khá"; // Khá
  } else if (score >= 5 && score < 6.5) {
    return "Trung bình"; // Trung bình
  } else {
    return "Chưa đạt"; // Chưa đạt
  }
}

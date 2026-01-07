String getCategoryScore(int score) {
  if (score >= 90 && score <= 100) {
    return "Xuất sắc"; // Xuất sắc
  } else if (score >= 80 && score < 90) {
    return "Giỏi"; // Giỏi
  } else if (score >= 65 && score < 80) {
    return "Khá"; // Khá
  } else if (score >= 50 && score < 65) {
    return "Trung bình"; // Trung bình
  } else {
    return "Chưa đạt"; // Chưa đạt
  }
}

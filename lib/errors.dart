class Errors {
  static String showError(String showError) {
    switch (showError) {
      case "firebase_auth/email-already-in-use":
        return "Bu mail adreesi zaten kullanımda!.Lütfen farklı bir Email ile kayıt olun.";

      case "user-error-not_found":
        return "Bu kullanıcı sistemde bulunmamaktadır";

      default:
        return " hataa vara hata var imdatt hata";
    }
  }
}

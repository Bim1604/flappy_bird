class StringUtils {
  static bool isNullOrWhite(String? value) {
    return value == null ||
        value == "" ||
        value.isEmpty ||
        value == " " ||
        value.trim() == "" ||
        value.trim() == " " ||
        value.trim() == "null";
  }


}
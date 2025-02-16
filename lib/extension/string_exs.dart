import 'dart:io';


extension ExString on String {

  bool isNullOrWhiteSpace() {
    return this == "" ||
        length == 0 ||
        this == " " ||
        trim() == "" ||
        trim() == " " ||
        trim() == "null";
  }

  Map<String, Object?> toJson(String key) {
    return {key: this};
  }
}

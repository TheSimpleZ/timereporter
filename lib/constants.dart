class StorageKeys {
  static const username = "username";
  static const password = "password";
  static const isLoggedIn = "isLoggedIn";
  static const workOrder = "workOrder";
  static const activity = "activity";
  static const hoursPerDay = "hoursPerDay";
  static const autoTimeReport = "autoTimeReport";
  static const ready = "ready";
  static const timeSheet = "timeSheet";
  static const plans = "plans";
  static const workOrderList = "workOrderList";
}

class TimeCodes {
  static const normalTime = "Normal Time";
  static const homeSick = "Home sick";
  static const vacation = "Vacation";

  static const abbreviations = {
    "N": normalTime,
    "HS": homeSick,
    "VAC": vacation
  };
}

typedef T Deserializer<T>(Map<String, dynamic> json);

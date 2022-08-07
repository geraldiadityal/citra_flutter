part of 'services.dart';

class PrefsHelper {
  final SharedPreferences sharedPreferences;

  PrefsHelper({required this.sharedPreferences});

  String TOKEN = "USER_TOKEN";
  String USERID = "USER_ID";

  String? initialUserToken() {
    final prefs = sharedPreferences;
    if (prefs.getString(TOKEN) != null) {
      User.token = prefs.getString(TOKEN);
    }
    return prefs.getString(TOKEN);
  }

  int? initUserId() {
    final prefs = sharedPreferences;
    if (prefs.getInt(USERID) != null) {
      return prefs.getInt(USERID);
    }
    return prefs.getInt(USERID);
  }

  void setUserToken(String value) async {
    final prefs = sharedPreferences;
    prefs.setString(TOKEN, value);
  }

  void setUserId(int value) async {
    final prefs = sharedPreferences;
    prefs.setInt(USERID, value);
  }

  void removeUserToken() async {
    final prefs = sharedPreferences;
    prefs.remove(TOKEN);
  }

  void removeUserId() async {
    final prefs = sharedPreferences;
    prefs.remove(USERID);
  }
}

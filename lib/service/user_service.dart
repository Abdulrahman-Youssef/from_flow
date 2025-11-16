import 'package:form_flow/models/user_model.dart';
import 'package:form_flow/service/shared_pref_service.dart';
import 'package:get/get.dart';

class UserService extends GetxService {
  static const _userKey = 'auth_user';
  final _sharedPref = SharedPrefService();

  // Reactive user
  UserModel? user;

  @override
  void onInit() {
    super.onInit();
    final userJson = _sharedPref.getJson(_userKey);
    if (userJson != null) {
      print("user in not null");
      user = UserModel.fromJson(userJson);
    }else{
      throw "user is null";
    }

  }


  // Update user in memory and storage
  Future<void> setUser(UserModel newUser) async {
    user = newUser;
    await _sharedPref.saveJson(_userKey, newUser.toJson());
  }

  Future<void> clearUser() async {
    user = null;
    await _sharedPref.remove(_userKey);
  }
}

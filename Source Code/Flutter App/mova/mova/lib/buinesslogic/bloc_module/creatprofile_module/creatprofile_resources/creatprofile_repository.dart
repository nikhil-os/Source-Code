import '../../../apiservice/creat_user/create_user_modal.dart';
import 'creatprofile_provider.dart';

class CreatprofileRepository {
  final _provide = CreatProfileProvider();

  Future<CreateUserModal> creatprofile(String? email, String? password, int loginType, String? fcmToken, String? identity, String? name, String? image) {
    return _provide.creatprofile(
        email, password, loginType, fcmToken, identity, name, image);
  }
}

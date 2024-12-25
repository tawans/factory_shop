import 'package:factory_shop/features/auth/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_repository.g.dart';

@riverpod
class AuthRepository extends _$AuthRepository {
  late final SharedPreferences _prefs;

  @override
  FutureOr<UserModel?> build() async {
    _prefs = await SharedPreferences.getInstance();
    final userId = _prefs.getString('userId');
    if (userId == null) return null;

    // TODO: API 연동 시 실제 사용자 정보를 가져오도록 수정
    return UserModel(
      id: userId,
      email: _prefs.getString('userEmail') ?? '',
      username: _prefs.getString('username') ?? '',
      profileImage: 'https://picsum.photos/200',
    );
  }

  Future<void> login(String email, String password) async {
    // TODO: API 연동 시 실제 로그인 로직으로 수정
    final user = UserModel(
      id: '1',
      email: email,
      username: email.split('@')[0],
      profileImage: 'https://picsum.photos/200',
    );

    await _prefs.setString('userId', user.id);
    await _prefs.setString('userEmail', user.email);
    await _prefs.setString('username', user.username);

    state = AsyncValue.data(user);
  }

  Future<void> logout() async {
    await _prefs.clear();
    state = const AsyncValue.data(null);
  }

  Future<void> register(String email, String password, String username) async {
    // TODO: API 연동 시 실제 회원가입 로직으로 수정
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      username: username,
      profileImage: 'https://picsum.photos/200',
    );

    await _prefs.setString('userId', user.id);
    await _prefs.setString('userEmail', user.email);
    await _prefs.setString('username', user.username);

    state = AsyncValue.data(user);
  }
}

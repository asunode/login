import '../models/app_user.dart';
import '../models/authorized_menu_item.dart';

abstract class AuthorizedMenuRepository {
  Future<List<AuthorizedMenuItem>> getMenusForUser(AppUser user);
}


import '../../domain/contracts/authorized_menu_repository.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/authorized_menu_item.dart';
import '../mock/mock_authorized_menus.dart';

class MockAuthorizedMenuRepository implements AuthorizedMenuRepository {
  const MockAuthorizedMenuRepository();

  @override
  Future<List<AuthorizedMenuItem>> getMenusForUser(AppUser user) async {
    final normalizedRole = user.role.trim().toLowerCase();
    return List<AuthorizedMenuItem>.unmodifiable(
      menusForRole(normalizedRole),
    );
  }
}
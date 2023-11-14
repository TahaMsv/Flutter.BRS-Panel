import '../../core/abstracts/controller_abs.dart';
import '../../core/classes/user_class.dart';
import '../../core/util/handlers/failure_handler.dart';
import 'dialogs/add_user_dialog.dart';
import 'usecases/add_update_user_usecase.dart';
import 'usecases/get_users_usecase.dart';
import 'users_state.dart';

class UsersController extends MainController {
  late UsersState usersState = ref.read(usersProvider);

  /// View -------------------------------------------------------------------------------------------------------------

  addUpdateUser(User? u) async {
    await nav.dialog(AddUpdateUserDialog(user: u,));
  }

  /// Requests ---------------------------------------------------------------------------------------------------------

  addUpdateUserRequest(User user) async {
    AddUpdateUserUseCase addUpdateUserUseCase = AddUpdateUserUseCase();
    AddUpdateUserRequest addUpdateUserRequest = AddUpdateUserRequest(user0: user);
    final fOrR = await addUpdateUserUseCase(request: addUpdateUserRequest);
    fOrR.fold((l) => FailureHandler.handle(l), (r) {
      final userP = ref.read(userListProvider.notifier);
      userP.state = r.users;
      nav.pop();
    });
  }

  getUsers() async {
    GetUsersUseCase getUsersUseCase = GetUsersUseCase();
    GetUsersRequest getUsersRequest = GetUsersRequest();
    usersState.loading = true;
    final fOrR = await getUsersUseCase(request: getUsersRequest);
    usersState.loading = false;
    fOrR.fold((l) => FailureHandler.handle(l), (r) {
      final userP = ref.read(userListProvider.notifier);
      userP.state = r.users;
    });
  }

  @override
  void onInit() {
    getUsers();
    super.onInit();
  }
}

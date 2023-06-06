import '../../core/abstracts/controller_abs.dart';
import '../../core/util/basic_class.dart';
import '../../core/util/handlers/failure_handler.dart';

import 'users_state.dart';

class UsersController extends MainController {
  late UsersState usersState = ref.read(usersProvider);
  // UseCase UseCase = UseCase(repository: Repository());

}

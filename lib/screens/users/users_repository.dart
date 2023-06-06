import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../core/abstracts/exception_abs.dart';
import '../../core/abstracts/failures_abs.dart';
import '../../core/platform/network_info.dart';
import '../../initialize.dart';
import 'interfaces/users_repository_interface.dart';
import 'data_sources/users_local_ds.dart';
import 'data_sources/users_remote_ds.dart';

class UsersRepository implements UsersRepositoryInterface {
  final UsersRemoteDataSource usersRemoteDataSource = UsersRemoteDataSource();
  final UsersLocalDataSource usersLocalDataSource = UsersLocalDataSource();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  UsersRepository();
}

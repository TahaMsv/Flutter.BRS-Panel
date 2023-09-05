import 'package:flutter/foundation.dart';
import '../abstracts/exception_abs.dart';
import '../abstracts/failures_abs.dart';
import '../abstracts/parser_abs.dart';
import '../abstracts/response_abs.dart';
import 'handlers/failure_handler.dart';

class Parser implements ParserAbs {
  @override

  Future<R> pars<M, R>(ComputeCallback<M, R> callback, M message, {String? debugLabel,Map<String,dynamic>? example}) async {
    try {
      final res = await compute(callback, message);
      return res;
    } catch (e) {
      Failure f = ServerFailure.fromAppException(ParseException(message: e.toString(), trace: StackTrace.fromString(e.toString())));
      if(example!=null &&  message is Response && message.body is Map<String,dynamic>){
        List<String> neededKeys = example.keys.toList();
        List<String> keys =( message.body as Map<String,dynamic>).keys.toList();
        List<String> missingKeys = neededKeys.where((element) => !keys.contains(element)).toList();
        String msg = 'Missing Parameters:\n${missingKeys.join("\n")}';
        f= ServerFailure.fromAppException(ParseException(message: msg, trace: StackTrace.fromString(e.toString())));
      }
      FailureHandler.handle(f);
      rethrow;
    }
  }
}

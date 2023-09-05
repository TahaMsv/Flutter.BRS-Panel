import 'package:flutter/foundation.dart';

abstract class ParserAbs {

  Future<R> pars<M, R>(ComputeCallback<M, R> callback, M message, {String? debugLabel});
}
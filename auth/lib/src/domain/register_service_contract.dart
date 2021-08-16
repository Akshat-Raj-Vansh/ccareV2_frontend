import 'package:async/async.dart';

abstract class IRegisterService {
  Future<Result<dynamic>> register(
    String phone,
  );
}

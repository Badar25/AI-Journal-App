
import '../network/dio_wrapper.dart';

abstract class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}
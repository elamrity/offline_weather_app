import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// في حالة فشل الاتصال بالسيرفر أو الـ API
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// في حالة عدم وجود بيانات في الكاش المحلي (Offline Cache Empty)
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
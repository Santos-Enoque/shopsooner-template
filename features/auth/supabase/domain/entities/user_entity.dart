import 'package:equatable/equatable.dart';

enum SubscriptionStatus { free, pro, premium }

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final bool emailVerified;
  final SubscriptionStatus subscriptionStatus;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.emailVerified = false,
    this.subscriptionStatus = SubscriptionStatus.free,
  });

  @override
  List<Object?> get props =>
      [id, email, name, emailVerified, subscriptionStatus];
}

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tictask/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String id,
    required String email,
    String? name,
    bool emailVerified = false,
    SubscriptionStatus subscriptionStatus = SubscriptionStatus.free,
  }) : super(
          id: id,
          email: email,
          name: name,
          emailVerified: emailVerified,
          subscriptionStatus: subscriptionStatus,
        );

  factory UserModel.fromSupabaseUser(User user) {
    // Get email verification status from user.emailConfirmedAt
    bool isEmailVerified = user.emailConfirmedAt != null;

    // Determine subscription status - default to free
    // In a real app, you'd get this from a database table
    SubscriptionStatus subscriptionStatus = SubscriptionStatus.free;

    return UserModel(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['full_name'] as String?,
      emailVerified: isEmailVerified,
      subscriptionStatus: subscriptionStatus,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['full_name'] as String?,
      emailVerified: json['email_verified'] as bool? ?? false,
      subscriptionStatus:
          _parseSubscriptionStatus(json['subscription_status'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': name,
      'email_verified': emailVerified,
      'subscription_status': subscriptionStatus.toString().split('.').last,
    };
  }

  static SubscriptionStatus _parseSubscriptionStatus(String? status) {
    if (status == null) return SubscriptionStatus.free;

    switch (status.toLowerCase()) {
      case 'pro':
        return SubscriptionStatus.pro;
      case 'premium':
        return SubscriptionStatus.premium;
      default:
        return SubscriptionStatus.free;
    }
  }
}

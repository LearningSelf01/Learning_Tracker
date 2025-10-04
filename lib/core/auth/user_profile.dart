import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfile {
  final String id;
  final String? fullName;
  final String? email;
  final String userType; // 'student' | 'teacher' | 'admin'

  const UserProfile({
    required this.id,
    required this.userType,
    this.fullName,
    this.email,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      fullName: map['full_name'] as String?,
      email: map['email'] as String?,
      userType: (map['user_type'] as String?) ?? 'student',
    );
  }
}

class ProfileNotFoundException implements Exception {
  final String message;
  ProfileNotFoundException([this.message = 'Profile not found']);
  @override
  String toString() => 'ProfileNotFoundException: $message';
}

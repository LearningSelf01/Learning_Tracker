import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'user_profile.dart';

class ProfileRepository {
  final SupabaseClient _client;
  ProfileRepository(this._client);

  Future<UserProfile?> getById(String userId) async {
    final res = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (res == null) return null;
    return UserProfile.fromMap(res as Map<String, dynamic>);
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(Supabase.instance.client);
});

final currentUserProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return null;
  return ref.read(profileRepositoryProvider).getById(user.id);
});

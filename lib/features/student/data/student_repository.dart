import 'package:supabase_flutter/supabase_flutter.dart';

class StudentRepository {
  StudentRepository();

  final SupabaseClient _supabase = Supabase.instance.client;

  // In-memory cache of the entire student_data row to avoid repeated queries
  static Map<String, dynamic>? _studentDataCache;
  static String? _cachedStudentId;

  // Adjust table and column names here if they differ in your Supabase schema
  static const String _validationTable = 'student_validation';
  static const String _validationUserIdCol = 'user_id';
  static const String _validationStudentIdCol = 'student_id';

  static const String _studentDataTable = 'student_data';
  static const String _studentDataIdCol = 'student_id';
  static const String _firstNameCol = 'first_name';
  static const String _middleNameCol = 'middle_name';
  static const String _lastNameCol = 'last_name';

  Future<String?> fetchStudentFullName() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    try {
      // Prefer cached data when available
      if (_studentDataCache != null) {
        final first = (_studentDataCache?[_firstNameCol] ?? '').toString().trim();
        final middle = (_studentDataCache?[_middleNameCol] ?? '').toString().trim();
        final last = (_studentDataCache?[_lastNameCol] ?? '').toString().trim();
        final parts = [first, middle, last].where((p) => p.isNotEmpty).toList();
        if (parts.isNotEmpty) return parts.join(' ');
      }

      // 1) Get student_id from validation table using auth user_id
      final validation = await _supabase
              .from(_validationTable)
              .select(_validationStudentIdCol)
              .eq(_validationUserIdCol, user.id)
              .maybeSingle()
          .timeout(const Duration(seconds: 3));

      final studentId = validation == null ? null : validation[_validationStudentIdCol];

      // Fallback to auth metadata full_name if no mapping
      if (studentId == null) {
        final fullName = user.userMetadata?['full_name'] as String?;
        return _normalizeFullName(fullName);
      }

      // 2) Fetch name parts from student_data (also cache full row)
      final profile = await _supabase
              .from(_studentDataTable)
              .select('*')
              .eq(_studentDataIdCol, studentId)
              .maybeSingle()
          .timeout(const Duration(seconds: 3));

      if (profile == null) {
        final fullName = user.userMetadata?['full_name'] as String?;
        return _normalizeFullName(fullName);
      }

      _studentDataCache = Map<String, dynamic>.from(profile as Map);
      _cachedStudentId = studentId?.toString();

      final first = (profile[_firstNameCol] ?? '').toString().trim();
      final middle = (profile[_middleNameCol] ?? '').toString().trim();
      final last = (profile[_lastNameCol] ?? '').toString().trim();

      final parts = [first, middle, last].where((p) => p.isNotEmpty).toList();
      if (parts.isEmpty) {
        final fullName = user.userMetadata?['full_name'] as String?;
        return _normalizeFullName(fullName);
      }
      return parts.join(' ');
    } on TimeoutException {
      final fullName = _supabase.auth.currentUser?.userMetadata?['full_name'] as String?;
      return _normalizeFullName(fullName);
    } catch (_) {
      // Gracefully fall back on any error
      final fullName = _supabase.auth.currentUser?.userMetadata?['full_name'] as String?;
      return _normalizeFullName(fullName);
    }
  }

  Future<({String firstName, String middleName, String lastName, String? studentId})>
      fetchStudentNameParts() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      return (firstName: '', middleName: '', lastName: '', studentId: null);
    }

    try {
      // Prefer cached data
      if (_studentDataCache != null) {
        final first = (_studentDataCache?[_firstNameCol] ?? '').toString().trim();
        final middle = (_studentDataCache?[_middleNameCol] ?? '').toString().trim();
        final last = (_studentDataCache?[_lastNameCol] ?? '').toString().trim();
        return (firstName: first, middleName: middle, lastName: last, studentId: _cachedStudentId);
      }

      final validation = await _supabase
          .from(_validationTable)
          .select(_validationStudentIdCol)
          .eq(_validationUserIdCol, user.id)
          .maybeSingle();

      final studentId = validation == null ? null : validation[_validationStudentIdCol]?.toString();

      if (studentId == null) {
        final fullName = _normalizeFullName(user.userMetadata?['full_name'] as String?);
        final parts = _splitFullName(fullName);
        return (
          firstName: parts.$1,
          middleName: parts.$2,
          lastName: parts.$3,
          studentId: null,
        );
      }

      final profile = await _supabase
          .from(_studentDataTable)
          .select('*')
          .eq(_studentDataIdCol, studentId)
          .maybeSingle();

      _studentDataCache = profile == null ? null : Map<String, dynamic>.from(profile as Map);
      _cachedStudentId = studentId;

      final first = (_studentDataCache?[_firstNameCol] ?? '').toString().trim();
      final middle = (_studentDataCache?[_middleNameCol] ?? '').toString().trim();
      final last = (_studentDataCache?[_lastNameCol] ?? '').toString().trim();

      return (firstName: first, middleName: middle, lastName: last, studentId: studentId);
    } on TimeoutException {
      final fullName = _normalizeFullName(_supabase.auth.currentUser?.userMetadata?['full_name'] as String?);
      final parts = _splitFullName(fullName);
      return (firstName: parts.$1, middleName: parts.$2, lastName: parts.$3, studentId: null);
    } catch (_) {
      final fullName = _normalizeFullName(_supabase.auth.currentUser?.userMetadata?['full_name'] as String?);
      final parts = _splitFullName(fullName);
      return (firstName: parts.$1, middleName: parts.$2, lastName: parts.$3, studentId: null);
    }
  }

  String? _normalizeFullName(String? v) {
    final t = (v ?? '').trim();
    return t.isEmpty ? null : t;
  }

  (String, String, String) _splitFullName(String? name) {
    final t = (name ?? '').trim();
    if (t.isEmpty) return ('', '', '');
    final parts = t.split(RegExp(r"\s+")).where((p) => p.isNotEmpty).toList();
    if (parts.length == 1) return (parts[0], '', '');
    if (parts.length == 2) return (parts[0], '', parts[1]);
    // take first, middle(s) joined, last
    final first = parts.first;
    final last = parts.last;
    final middle = parts.sublist(1, parts.length - 1).join(' ');
    return (first, middle, last);
  }

  // Returns the mapped student_id for the current auth user, or null if not found
  Future<String?> fetchStudentId() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    try {
      final validation = await _supabase
              .from(_validationTable)
              .select(_validationStudentIdCol)
              .eq(_validationUserIdCol, user.id)
              .maybeSingle()
          .timeout(const Duration(seconds: 3));
      return validation == null ? null : validation[_validationStudentIdCol]?.toString();
    } on TimeoutException {
      return null;
    } catch (_) {
      return null;
    }
  }

  // Fetches the ENTIRE student_data row for the current user.
  // Useful across the app wherever more fields are needed.
  Future<Map<String, dynamic>?> fetchStudentData() async {
    final studentId = await fetchStudentId();
    if (studentId == null) return null;
    try {
      final row = await _supabase
              .from(_studentDataTable)
              .select('*')
              .eq(_studentDataIdCol, studentId)
              .maybeSingle()
          .timeout(const Duration(seconds: 3));
      // row is dynamic?, normalize to Map<String, dynamic>
      if (row == null) return null;
      final map = Map<String, dynamic>.from(row as Map);
      // Also attach user_id for convenience
      final uid = _supabase.auth.currentUser?.id;
      if (uid != null) map['user_id'] = uid;
      _studentDataCache = map;
      _cachedStudentId = studentId;
      return map;
    } catch (_) {
      return null;
    }
  }

  // Force-load and cache student data; returns cached data when available unless forceRefresh is true
  Future<Map<String, dynamic>?> loadStudentData({bool forceRefresh = false}) async {
    if (!forceRefresh && _studentDataCache != null) return _studentDataCache;
    return await fetchStudentData();
  }

  // Access the currently cached student_data row (may be null until loaded)
  Map<String, dynamic>? get currentStudentData => _studentDataCache;

  /// Clears any in-memory caches. Call this on logout to avoid showing stale data.
  void clearCache() {
    _studentDataCache = null;
    _cachedStudentId = null;
  }
}

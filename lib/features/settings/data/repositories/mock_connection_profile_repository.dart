import '../../domain/contracts/connection_profile_repository.dart';
import '../../domain/models/connection_profile.dart';
import '../mock/mock_connection_profiles.dart';

class MockConnectionProfileRepository implements ConnectionProfileRepository {
  MockConnectionProfileRepository()
      : _profiles = List<ConnectionProfile>.from(mockConnectionProfiles);

  List<ConnectionProfile> _profiles;

  @override
  Future<List<ConnectionProfile>> getProfiles() async {
    return List<ConnectionProfile>.from(_profiles);
  }

  @override
  Future<ConnectionProfile> saveProfile(ConnectionProfile profile) async {
    _profiles = [..._profiles, profile];
    return profile;
  }

  @override
  Future<List<ConnectionProfile>> setActiveProfile(String profileId) async {
    _profiles = _profiles
        .map(
          (profile) => profile.copyWith(
            isActive: profile.id == profileId,
          ),
        )
        .toList();
    return List<ConnectionProfile>.from(_profiles);
  }

  @override
  Future<List<ConnectionProfile>> testConnection(String profileId) async {
    _profiles = _profiles
        .map(
          (profile) => profile.id == profileId
              ? profile.copyWith(
                  testStatus: profile.host.contains('127.0.0.1')
                      ? ConnectionTestStatus.success
                      : ConnectionTestStatus.failed,
                )
              : profile,
        )
        .toList();
    return List<ConnectionProfile>.from(_profiles);
  }

  @override
  Future<ConnectionProfile> updateProfile(ConnectionProfile profile) async {
    final index = _profiles.indexWhere((item) => item.id == profile.id);
    if (index == -1) {
      _profiles = [..._profiles, profile];
      return profile;
    }

    final updated = List<ConnectionProfile>.from(_profiles);
    updated[index] = profile;
    _profiles = updated;
    return profile;
  }
}


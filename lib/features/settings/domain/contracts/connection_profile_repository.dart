import '../models/connection_profile.dart';

abstract class ConnectionProfileRepository {
  Future<List<ConnectionProfile>> getProfiles();

  Future<ConnectionProfile> saveProfile(ConnectionProfile profile);

  Future<ConnectionProfile> updateProfile(ConnectionProfile profile);

  Future<List<ConnectionProfile>> setActiveProfile(String profileId);

  Future<List<ConnectionProfile>> testConnection(String profileId);
}


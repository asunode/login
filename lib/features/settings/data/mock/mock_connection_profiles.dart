import '../../domain/models/connection_profile.dart';

const List<ConnectionProfile> mockConnectionProfiles = [
  ConnectionProfile(
    id: 'cp1',
    name: 'Yerel Geliştirme',
    host: '127.0.0.1:5432',
    database: 'sworld_local',
    username: 'local_admin',
    isActive: true,
    testStatus: ConnectionTestStatus.success,
  ),
  ConnectionProfile(
    id: 'cp2',
    name: 'Staging Profil',
    host: '10.10.2.18:5432',
    database: 'sworld_stage',
    username: 'stage_reader',
    isActive: false,
    testStatus: ConnectionTestStatus.idle,
  ),
];



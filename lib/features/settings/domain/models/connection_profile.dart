enum ConnectionTestStatus {
  idle,
  success,
  failed,
}

class ConnectionProfile {
  const ConnectionProfile({
    required this.id,
    required this.name,
    required this.host,
    required this.database,
    required this.username,
    this.isActive = false,
    this.testStatus = ConnectionTestStatus.idle,
  });

  final String id;
  final String name;
  final String host;
  final String database;
  final String username;
  final bool isActive;
  final ConnectionTestStatus testStatus;

  ConnectionProfile copyWith({
    String? id,
    String? name,
    String? host,
    String? database,
    String? username,
    bool? isActive,
    ConnectionTestStatus? testStatus,
  }) {
    return ConnectionProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      host: host ?? this.host,
      database: database ?? this.database,
      username: username ?? this.username,
      isActive: isActive ?? this.isActive,
      testStatus: testStatus ?? this.testStatus,
    );
  }
}



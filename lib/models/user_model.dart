class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String farmName;
  final String role;
  final String profileImageUrl;
  final String? biodigesterType;
  final double? biodigesterCapacity;
  final String? location;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.farmName,
    this.role = 'user',
    this.profileImageUrl = '',
    this.biodigesterType,
    this.biodigesterCapacity,
    this.location,
    this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'farmName': farmName,
    'role': role,
    'profileImageUrl': profileImageUrl,
    'biodigesterType': biodigesterType,
    'biodigesterCapacity': biodigesterCapacity,
    'location': location ?? 'Plateau Central, Burkina Faso',
    'createdAt': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String? ?? '',
    fullName: json['fullName'] as String? ?? '',
    email: json['email'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    farmName: json['farmName'] as String? ?? '',
    role: json['role'] as String? ?? 'user',
    profileImageUrl: json['profileImageUrl'] as String? ?? '',
    biodigesterType: json['biodigesterType'] as String?,
    biodigesterCapacity: (json['biodigesterCapacity'] as num?)?.toDouble(),
    location: json['location'] as String?,
    createdAt: json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'] as String)
        : null,
  );

  UserModel copyWith({
    String? fullName,
    String? phone,
    String? farmName,
    String? role,
    String? biodigesterType,
    double? biodigesterCapacity,
    String? location,
  }) => UserModel(
    id: id,
    fullName: fullName ?? this.fullName,
    email: email,
    phone: phone ?? this.phone,
    farmName: farmName ?? this.farmName,
    role: role ?? this.role,
    profileImageUrl: profileImageUrl,
    biodigesterType: biodigesterType ?? this.biodigesterType,
    biodigesterCapacity: biodigesterCapacity ?? this.biodigesterCapacity,
    location: location ?? this.location,
    createdAt: createdAt,
  );

  static const UserModel mockUser = UserModel(
    id: 'USR-001',
    fullName: 'Moussa Traoré',
    email: 'moussa.traore@biodigit.bf',
    phone: '+226 70 12 34 56',
    farmName: 'Ferme BioDigit Plateau Central',
    role: 'Responsable Biodigesteur',
    profileImageUrl: '',
    location: 'Plateau Central, Burkina Faso',
    biodigesterType: 'Fixed-dome',
    biodigesterCapacity: 10.0,
  );
}

class FarmManager {
  final String name;
  final String email;
  final String assignedFarm;
  final String status;
  final String initials;

  const FarmManager({
    required this.name,
    required this.email,
    required this.assignedFarm,
    required this.status,
    required this.initials,
  });

  static List<FarmManager> mockManagers = [
    FarmManager(
      name: 'Ibrahim Sawadogo',
      email: 'i.sawadogo@biodigit.bf',
      assignedFarm: 'Coopérative Kadiogo',
      status: 'Healthy',
      initials: 'IS',
    ),
    FarmManager(
      name: 'Aïcha Kaboré',
      email: 'a.kabore@fermesbio.bf',
      assignedFarm: 'Ferme Bazèga',
      status: 'Maintenance',
      initials: 'AK',
    ),
    FarmManager(
      name: 'Ousmane Compaoré',
      email: 'o.compaore@bioenergie.bf',
      assignedFarm: 'Centre Zoundwéogo',
      status: 'Critical',
      initials: 'OC',
    ),
  ];
}

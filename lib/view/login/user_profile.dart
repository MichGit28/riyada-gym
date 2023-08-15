class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String dateOfBirth;
  final String weight;
  final String height;
  final String userId;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    required this.weight,
    required this.height,
    required this.userId,
  });

  // factory method to create a UserProfile instance from a map
  factory UserProfile.fromMap(Map<String, dynamic> data, String userId) {
    return UserProfile(
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      gender: data['gender'] ?? '',
      dateOfBirth: data['dateOfBirth'] ?? '',
      weight: data['weight'] ?? '',
      height: data['height'] ?? '',
      userId: userId,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      height: json['height'] as String,
      weight: json['weight'] as String,
      userId: json['userId'] as String,
    );
  }
}

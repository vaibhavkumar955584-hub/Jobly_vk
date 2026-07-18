class User {
  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;
  final String? resumeUrl;
  final String? phoneNumber;
  final String? bio;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
    this.resumeUrl,
    this.phoneNumber,
    this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      profileImageUrl: json['profile_image_url'],
      resumeUrl: json['resume_url'],
      phoneNumber: json['phone_number'],
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profile_image_url': profileImageUrl,
      'resume_url': resumeUrl,
      'phone_number': phoneNumber,
      'bio': bio,
    };
  }
}

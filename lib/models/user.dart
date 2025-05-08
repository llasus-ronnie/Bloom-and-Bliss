class User {
  static int _counter = 0; 
  final String id;
  final String fullName;
  final String email;
  final String password;
  final int phoneNumber;
  final bool isGuest;

  User({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    this.isGuest = false,
  }) : id = 'user_${_counter++}';
}

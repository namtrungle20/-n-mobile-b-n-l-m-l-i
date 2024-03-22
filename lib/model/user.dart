import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String username;
  final String password;

  User({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}
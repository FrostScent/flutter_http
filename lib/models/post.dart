class Post {
  final String user;
  final String email;

  Post({required this.user, required this.email});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(user: json['user'], email: json['email']);
  }
}

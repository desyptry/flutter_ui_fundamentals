class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;
  final String? createdAt;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
    this.createdAt,
  });
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: (json['status'] as String?) ?? 'planned',
      createdAt: json['created_at'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'title': title,
      'credits': credits,
      'status': status,
    };
  }
  bool get isDone => status == 'done';
  bool get isActive => status == 'active';
  bool get isPlanned => status == 'planned';
}
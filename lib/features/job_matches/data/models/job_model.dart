class JobBenefits {
  final bool accommodation;
  final bool food;
  final bool visa;

  const JobBenefits({
    required this.accommodation,
    required this.food,
    required this.visa,
  });

  factory JobBenefits.fromJson(Map<String, dynamic> json) {
    return JobBenefits(
      accommodation: json['accommodation'] as bool? ?? false,
      food: json['food'] as bool? ?? false,
      visa: json['visa'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'accommodation': accommodation, 'food': food, 'visa': visa};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobBenefits &&
          runtimeType == other.runtimeType &&
          accommodation == other.accommodation &&
          food == other.food &&
          visa == other.visa;

  @override
  int get hashCode => accommodation.hashCode ^ food.hashCode ^ visa.hashCode;
}

class Job {
  final String id;
  final String title;
  final String employerDisplay;
  final String country;
  final String city;
  final int salaryMinAed;
  final int salaryMaxAed;
  final double matchScore;
  final String matchReason;
  final List<String> skills;
  final JobBenefits benefits;
  final String description;
  final List<String> requirements;
  final DateTime postedAt;

  const Job({
    required this.id,
    required this.title,
    required this.employerDisplay,
    required this.country,
    required this.city,
    required this.salaryMinAed,
    required this.salaryMaxAed,
    required this.matchScore,
    required this.matchReason,
    required this.skills,
    required this.benefits,
    required this.description,
    required this.requirements,
    required this.postedAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] as String,
      title: json['title'] as String,
      employerDisplay: json['employer_display'] as String,
      country: json['country'] as String,
      city: json['city'] as String,
      salaryMinAed: (json['salary_min_aed'] as num).toInt(),
      salaryMaxAed: (json['salary_max_aed'] as num).toInt(),
      matchScore: (json['match_score'] as num).toDouble(),
      matchReason: json['match_reason'] as String,
      skills: (json['skills'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      benefits: JobBenefits.fromJson(json['benefits'] as Map<String, dynamic>),
      description: json['description'] as String,
      requirements: (json['requirements'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      postedAt: DateTime.parse(json['posted_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'employer_display': employerDisplay,
      'country': country,
      'city': city,
      'salary_min_aed': salaryMinAed,
      'salary_max_aed': salaryMaxAed,
      'match_score': matchScore,
      'match_reason': matchReason,
      'skills': skills,
      'benefits': benefits.toJson(),
      'description': description,
      'requirements': requirements,
      'posted_at': postedAt.toIso8601String(),
    };
  }

  String get formattedSalaryRange =>
      'AED ${salaryMinAed.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} - ${salaryMaxAed.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';

  String get formattedMatchScore =>
      '${matchScore.toStringAsFixed(matchScore.truncateToDouble() == matchScore ? 0 : 1)}%';

  Job copyWith({
    String? id,
    String? title,
    String? employerDisplay,
    String? country,
    String? city,
    int? salaryMinAed,
    int? salaryMaxAed,
    double? matchScore,
    String? matchReason,
    List<String>? skills,
    JobBenefits? benefits,
    String? description,
    List<String>? requirements,
    DateTime? postedAt,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      employerDisplay: employerDisplay ?? this.employerDisplay,
      country: country ?? this.country,
      city: city ?? this.city,
      salaryMinAed: salaryMinAed ?? this.salaryMinAed,
      salaryMaxAed: salaryMaxAed ?? this.salaryMaxAed,
      matchScore: matchScore ?? this.matchScore,
      matchReason: matchReason ?? this.matchReason,
      skills: skills ?? this.skills,
      benefits: benefits ?? this.benefits,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      postedAt: postedAt ?? this.postedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Job && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

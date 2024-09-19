class WorkExperience {
  String yearStart;
  String yearEnd;
  String jobTitle;
  String company;
  String description;

  WorkExperience({
    required this.yearStart,
    required this.yearEnd,
    required this.jobTitle,
    required this.company,
    required this.description,
  });

  Map<String, dynamic> toJson(int userId) {
    return {
      'userId': userId,
      'yearStart': yearStart,
      'yearEnd': yearEnd,
      'jobTitle': jobTitle,
      'company': company,
      'description': description,
    };
  }
}

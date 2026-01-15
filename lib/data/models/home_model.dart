class HomeResponse {
  final User user;
  final List<BannerItem> heroBanners;
  final ActiveCourse activeCourse;
  final List<CourseCategory> popularCourses;
  final LiveSession liveSession;

  HomeResponse({
    required this.user,
    required this.heroBanners,
    required this.activeCourse,
    required this.popularCourses,
    required this.liveSession,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      user: User.fromJson(json['user']),
      heroBanners: (json['hero_banners'] as List)
          .map((e) => BannerItem.fromJson(e))
          .toList(),
      activeCourse: ActiveCourse.fromJson(json['active_course']),
      popularCourses: (json['popular_courses'] as List)
          .map((e) => CourseCategory.fromJson(e))
          .toList(),
      liveSession: LiveSession.fromJson(json['live_session']),
    );
  }
}

class User {
  final String name;
  final String greeting;
  final int streakDays;

  User({required this.name, required this.greeting, required this.streakDays});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      greeting: json['greeting'],
      streakDays: json['streak']?['days'] ?? 0,
    );
  }
}

class BannerItem {
  final int id;
  final String title;
  final String image;
  final bool isActive;

  BannerItem({
    required this.id,
    required this.title,
    required this.image,
    required this.isActive,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      isActive: json['is_active'] ?? false,
    );
  }
}

class ActiveCourse {
  final int id;
  final String title;
  final int progress;
  final int testsCompleted;
  final int totalTests;

  ActiveCourse({
    required this.id,
    required this.title,
    required this.progress,
    required this.testsCompleted,
    required this.totalTests,
  });

  factory ActiveCourse.fromJson(Map<String, dynamic> json) {
    return ActiveCourse(
      id: json['id'],
      title: json['title'],
      progress: json['progress'],
      testsCompleted: json['tests_completed'],
      totalTests: json['total_tests'],
    );
  }
}

class CourseCategory {
  final int id;
  final String name;
  final List<Course> courses;

  CourseCategory({required this.id, required this.name, required this.courses});

  factory CourseCategory.fromJson(Map<String, dynamic> json) {
    return CourseCategory(
      id: json['id'],
      name: json['name'],
      courses: (json['courses'] as List)
          .map((e) => Course.fromJson(e))
          .toList(),
    );
  }
}

class Course {
  final int id;
  final String title;
  final String image;
  final String action;

  Course({
    required this.id,
    required this.title,
    required this.image,
    required this.action,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      action: json['action'],
    );
  }
}

class LiveSession {
  final String title;
  final String instructorName;
  final String sessionDate;
  final String sessionTime;

  LiveSession({
    required this.title,
    required this.instructorName,
    required this.sessionDate,
    required this.sessionTime,
  });

  factory LiveSession.fromJson(Map<String, dynamic> json) {
    return LiveSession(
      title: json['title'],
      instructorName: json['instructor']['name'],
      sessionDate: json['session_details']['date'],
      sessionTime: json['session_details']['time'],
    );
  }
}

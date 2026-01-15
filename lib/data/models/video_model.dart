class VideoResponse {
  final VideoData data;

  VideoResponse({required this.data});

  factory VideoResponse.fromJson(Map<String, dynamic> json) {
    return VideoResponse(data: VideoData.fromJson(json['data']));
  }
}

class VideoData {
  final String title;
  final List<VideoItem> videos;

  VideoData({required this.title, required this.videos});

  factory VideoData.fromJson(Map<String, dynamic> json) {
    return VideoData(
      title: json['title'],
      videos: (json['videos'] as List)
          .map((e) => VideoItem.fromJson(e))
          .toList(),
    );
  }
}

class VideoItem {
  final int id;
  final String title;
  final String description;
  final String status;
  final String? videoUrl;
  final int totalDuration;
  final int watchedDuration;
  final int progressPercentage;
  final bool hasPlayButton;

  VideoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.videoUrl,
    required this.totalDuration,
    required this.watchedDuration,
    required this.progressPercentage,
    required this.hasPlayButton,
  });

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      videoUrl: json['video_url'],
      totalDuration: json['total_duration'],
      watchedDuration: json['watched_duration'],
      progressPercentage: json['progress_percentage'],
      hasPlayButton: json['has_play_button'],
    );
  }

  bool get isLocked => status == 'locked';
  bool get isCompleted => status == 'completed';
  int get duration => totalDuration;

  VideoItem copyWith({String? status, int? progressPercentage}) {
    return VideoItem(
      id: id,
      title: title,
      description: description,
      status: status ?? this.status,
      videoUrl: videoUrl,
      totalDuration: totalDuration,
      watchedDuration: watchedDuration,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      hasPlayButton: hasPlayButton,
    );
  }
}

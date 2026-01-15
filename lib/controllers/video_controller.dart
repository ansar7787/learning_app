import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../data/models/video_model.dart';
import '../services/api_service.dart';

class VideoController extends GetxController {
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final videoData = Rxn<VideoData>();

  // Video Player
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  final isPlayerInitialized = false.obs;

  // Track current
  String? currentPlayingUrl;

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.onClose();
  }

  void fetchVideos() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final videoResponse = await ApiService.getVideos();
      videoData.value = videoResponse.data;

      // Auto-initialize first video if available
      if (videoResponse.data.videos.isNotEmpty) {
        final firstVideo = videoResponse.data.videos.first;
        if (firstVideo.videoUrl != null) {
          initializePlayer(firstVideo.videoUrl!);
        }
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initializePlayer(String url) async {
    try {
      // Force HTTPS
      if (url.startsWith('http://')) {
        url = url.replaceFirst('http://', 'https://');
      }

      // print("Initializing video: $url");
      currentPlayingUrl = url;

      // Dispose previous
      videoPlayerController?.dispose();
      chewieController?.dispose();
      isPlayerInitialized.value = false;

      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
      await videoPlayerController!.initialize();

      // Add Listener for Completion
      videoPlayerController!.addListener(_onVideoPositionChanged);

      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: videoPlayerController!.value.aspectRatio > 0
            ? videoPlayerController!.value.aspectRatio
            : 16 / 9,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );

      isPlayerInitialized.value = true;
    } catch (e) {
      // print("Video initialization error: $e");
      errorMessage.value = "Failed to play video"; // Show error in UI
    }
  }

  void playVideo(String url) {
    initializePlayer(url);
  }

  void _onVideoPositionChanged() {
    if (videoPlayerController == null) return;

    final value = videoPlayerController!.value;
    if (value.position >= value.duration && value.duration.inSeconds > 0) {
      // Video Finished
      _handleVideoCompletion();
    }
  }

  void _handleVideoCompletion() {
    // Prevent multiple calls if already handling
    // (though logic below handles index lookups so usually safe)
    if (videoData.value == null) return;

    final videos = videoData.value!.videos;
    final currentIndex = videos.indexWhere(
      (v) => v.videoUrl!.contains(currentPlayingUrl ?? ''),
    );

    if (currentIndex != -1 && currentIndex < videos.length) {
      // 1. Mark current as completed
      // Check if already completed to avoid infinite loops if listener fires multiple times
      if (videos[currentIndex].status == 'completed' &&
          (currentIndex + 1 >= videos.length ||
              videos[currentIndex + 1].status != 'locked')) {
        return; // Already processed
      }

      // print("Video $currentIndex finished. Unlocking next.");

      // Create new list to trigger Obx
      final newVideos = List<VideoItem>.from(videos);

      newVideos[currentIndex] = newVideos[currentIndex].copyWith(
        status: 'completed',
        progressPercentage: 100,
      );

      // 2. Unlock Next
      if (currentIndex + 1 < newVideos.length) {
        final nextVideo = newVideos[currentIndex + 1];
        newVideos[currentIndex + 1] = nextVideo.copyWith(
          status: 'active',
        ); // Unlock

        // 3. Play Next
        if (nextVideo.videoUrl != null) {
          // Remove listener before switching to avoid calling this again for old controller
          videoPlayerController?.removeListener(_onVideoPositionChanged);
          // Delay slightly to allow UI update
          Future.delayed(const Duration(milliseconds: 500), () {
            playVideo(nextVideo.videoUrl!);
          });
        }
      }

      // Update Data
      videoData.value = VideoData(
        title: videoData.value!.title,
        videos: newVideos,
      );
    }
  }
}

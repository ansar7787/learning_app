import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:learning_app/controllers/video_controller.dart';
import 'package:learning_app/data/models/video_model.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VideoController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF), // Light blueish background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text('Video', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // --- VIDEO PLAYER AREA ---
            Obx(() {
              if (controller.isPlayerInitialized.value &&
                  controller.chewieController != null) {
                return AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Chewie(controller: controller.chewieController!),
                );
              }
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              );
            }),

            // --- CURRENT VIDEO INFO ---
            Container(
              // White background for info
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Find current playing video if possible, or just show generic
                        // For now, showing dummy or first video title might change based on logic
                        const Text(
                          "Video Lesson", // Or dynamic title
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Understanding the Basics of Meditation",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(Icons.download, size: 20),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- TIMELINE HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Meditation Journey", // Dynamic?
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // --- TIMELINE LIST ---
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = controller.videoData.value;
                if (data == null || data.videos.isEmpty) {
                  return const Center(child: Text("No videos."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  itemCount: data.videos.length,
                  itemBuilder: (context, index) {
                    final video = data.videos[index];
                    final isLast = index == data.videos.length - 1;
                    return _TimelineItem(
                      video: video,
                      isLast: isLast,
                      onTap: () {
                        if (video.status != 'locked' &&
                            video.videoUrl != null) {
                          controller.playVideo(video.videoUrl!);
                        }
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final VideoItem video;
  final bool isLast;
  final VoidCallback onTap;

  const _TimelineItem({
    required this.video,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Icons based on status
    final isLocked = video.status == 'locked';
    final isCompleted = video.status == 'completed';
    // If not locked and not completed, assume it's the "current" or "in_progress" one
    // But for UI, check explicitly or just use logic.

    Widget statusIcon;
    if (isCompleted) {
      statusIcon = const CircleAvatar(
        radius: 14,
        backgroundColor: Colors.teal,
        child: Icon(Icons.check, color: Colors.white, size: 16),
      );
    } else if (isLocked) {
      statusIcon = const CircleAvatar(
        radius: 14,
        backgroundColor: Colors.white, // Or light grey
        child: Icon(Icons.lock, color: Colors.black54, size: 16),
      );
    } else {
      // In Progress / Active
      statusIcon = const CircleAvatar(
        radius: 14,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.play_arrow,
          color: Colors.black,
          size: 16,
        ), // Or custom dot
      );
    }

    return IntrinsicHeight(
      // Helps dashed line stretch
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- TIMELINE DRAWING ---
          Column(
            children: [
              statusIcon,
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: CustomPaint(painter: _DashedLinePainter()),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // --- CARD ---
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            video.description, // "Understanding..."
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: isLocked ? Colors.grey : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal.withValues(alpha: 0.5)
      ..strokeWidth = 2;
    var max = size.height;
    var dashWidth = 5;
    var dashSpace = 3;
    double startY = 0;
    while (startY < max) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

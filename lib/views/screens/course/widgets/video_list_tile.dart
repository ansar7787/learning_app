import 'package:flutter/material.dart';
import 'package:learning_app/data/models/video_model.dart';

class VideoListTile extends StatelessWidget {
  final VideoItem video;
  final bool isSelected;
  final VoidCallback onTap;

  const VideoListTile({
    super.key,
    required this.video,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: video.isLocked
                    ? Colors.grey.shade300
                    : video.isCompleted
                    ? Colors.green
                    : Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  video.isLocked
                      ? Icons.lock
                      : video.isCompleted
                      ? Icons.check
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    video.description, // Use description instead of instructor
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Text(
              '${video.duration ~/ 60}m',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:myapp/models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    debugPrint("Event DateTime: ${post.eventDateTime}");



    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Username
            Text(
              post.createdBy.username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            // Post content
            Text(post.content),
            const SizedBox(height: 6),

            // Post image
            if (post.image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(post.image[0], fit: BoxFit.cover),
              ),

            const SizedBox(height: 6),

            // Location and time
            if (post.place.isNotEmpty)
              Text("📍 ${post.place}", style: TextStyle(color: Colors.grey[700])),

          
              Text(
                "🗓️",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),

            const Divider(height: 20),

            // Scrollable action row to avoid overflow
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildActionButton(
                    Icons.thumb_up_alt_outlined,
                    "Interested",
                    () {
                      // Handle interested logic
                    },
                  ),
                  _buildActionButton(
                    Icons.thumb_down_alt_outlined,
                    "Not Interested",
                    () {
                      // Handle not interested logic
                    },
                  ),
                  _buildActionButton(
                    Icons.comment_outlined,
                    "Comment",
                    () {
                      // Handle comment logic
                    },
                  ),
                  _buildActionButton(
                    Icons.share_outlined,
                    "Share",
                    () {
                      // Handle share logic
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}

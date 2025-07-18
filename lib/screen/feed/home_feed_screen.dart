import 'package:flutter/material.dart';
import 'package:myapp/controllers/postProvider.dart';
import 'package:myapp/widgets/post_card.dart';
import 'package:provider/provider.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isInit = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final provider = Provider.of<PostProvider>(context, listen: false);
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300 &&
          provider.hasMore &&
          !provider.isLoading) {
        provider.fetchPosts();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<PostProvider>(context, listen: false).refreshPosts();
      _isInit = false;
    }
  }

  Future<void> _refresh() async {
    await Provider.of<PostProvider>(context, listen: false).refreshPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Feed"),
        centerTitle: true,
      ),
      body: Consumer<PostProvider>(
        builder: (ctx, postProvider, _) {
          final posts = postProvider.posts;

          if (postProvider.isLoading && posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (posts.isEmpty) {
            return const Center(child: Text("No posts yet."));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: posts.length + (postProvider.hasMore ? 1 : 0),
              itemBuilder: (ctx, index) {
                if (index < posts.length) {
                  return PostCard(post: posts[index]);
                } else {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

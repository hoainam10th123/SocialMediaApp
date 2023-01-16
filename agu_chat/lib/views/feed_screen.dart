import 'dart:convert';
import 'dart:io';
import 'package:agu_chat/views/widgets/feed/post_item.dart';
import 'package:flutter/material.dart';
import '../models/pagination.dart';
import '../models/post.dart';
import '../temp_data/widgets/following_users.dart';
import '../utils/const.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;

import '../utils/global.dart';
import 'add_post_screen.dart';

class FeedScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FeedScreenState();
  }
}

class FeedScreenState extends State<FeedScreen> {
  late PageController _pageController;
  final pageSize = 5;

  final PagingController<int, Post> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Pagination<Post> paginationPost = Pagination(
      totalPages: 1,
      pageNumber: 1,
      pageSize: 5,
      count: 1,
      items: []
  );

  Future<void> fetchPosts(int pageNumber) async {
    try {
      final uri = Uri.parse('$urlBase/api/posts?pageNumber=$pageNumber&pageSize=$pageSize');
      var response = await http.get(uri, headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${Global.user!.token}',
        HttpHeaders.contentTypeHeader: 'application/json',
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonReturn = jsonDecode(response.body);
        paginationPost = Pagination<Post>.fromJson(jsonReturn, Post.fromJsonModel);
      } else {
        print('error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  int pageNumber = 0;
  Future<void> _fetchPage(int pageKey) async {
    try {
      if(pageNumber < paginationPost.totalPages){
        pageNumber += 1;
        await Future.delayed(const Duration(seconds: 1));
        await fetchPosts(pageNumber);
        final isLastPage = paginationPost.totalPages == pageNumber;
        if (isLastPage) {
          _pagingController.appendLastPage(paginationPost.items);
        } else {
          final nextPageKey = pageKey + paginationPost.items.length;
          _pagingController.appendPage(paginationPost.items, nextPageKey);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Feeds'),
          actions: [
            IconButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPostScreen()),
                  );
                },
                icon: const Icon(Icons.add)
            )
          ],
        ),
        body: Column(
          children: [
            FollowingUsers(),
            Expanded(
                child: PagedListView<int, Post>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Post>(
                    itemBuilder: (context, item, index) => PostItem(post: item),
                  ),
                ),
            )
          ],
        )
    );
  }
}

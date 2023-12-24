import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miniblog/models/blog.dart';
import 'package:http/http.dart' as http;

class BlogDetail extends StatefulWidget {
  const BlogDetail({Key? key, required this.blogId}) : super(key: key);

  final String blogId;

  @override
  _BlogDetailState createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  Blog? blogDetay;

  @override
  void initState() {
    super.initState();
    fetchBlogDetay();
  }

  fetchBlogDetay() async {
    Uri url = Uri.parse(
        "https://tobetoapi.halitkalayci.com/api/Articles/${widget.blogId}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        blogDetay = Blog.fromJson(jsonData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blogDetay?.title ?? ""),
      ),
      body: blogDetay == null
          ? const Center(child: CircularProgressIndicator())
          : AspectRatio(
              aspectRatio: 2 / 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      blogDetay!.thumbnail ?? "",
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                      height: 300,
                    ),
                    const SizedBox(height: 10),
                    Text(blogDetay?.content ?? ""),
                    const SizedBox(height: 10),
                    Text(blogDetay?.author ?? ""),
                  ],
                ),
              ),
            ),
    );
  }
}

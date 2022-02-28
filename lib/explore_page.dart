import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:readmore/readmore.dart';
import 'api_model.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late InstagramExplore intaPosts;
  bool isLoading = false;
  int _current = 0;
  final CarouselController _controller = CarouselController();
  List items = List<String>.generate(10000, (i) => 'Item $i');
  late List<String> imgList = [];
  late List<Widget> imageSliders;
  @override
  void initState() {
    fetchLog();
  }

  Future<void> fetchLog() async {
    Response response = await get(
        "https://li3bzg1xs9.execute-api.ap-south-1.amazonaws.com/default/getInstaPosts");
    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        isLoading = true;
        intaPosts = InstagramExplore.fromJson(jsonDecode(response.body));
      });
    } else {}
  }

  // Widget user(int index) {
  //
  // }

  ImageSlider() {
    imageSliders = imgList
        .map((item) => Container(
              child: Container(
                child: Image.network(item, fit: BoxFit.cover, width: 100000),
              ),
            ))
        .toList();
  }
  Widget discription(int index){
    return  ReadMoreText(
      '${intaPosts.posts![index].postedBy} ${intaPosts.posts![index].description}',
      trimLines: 2,
      colorClickableText: Colors.white,
      trimMode: TrimMode.Line,
      trimCollapsedText: 'Show more',
      trimExpandedText: 'Show less',
      moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );
  }
  Widget postImage(int index) {
    return Container(
      child: Column(
        children: [
          Container(height:400,width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
              items: imageSliders,
              carouselController: _controller,
              options: CarouselOptions(
                //  autoPlay: false,
                  //enlargeCenterPage: false,
                  aspectRatio: 0.95,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 8,right: 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite_border,color: Colors.white,),
                    SizedBox(width: 10,),
                    Icon(Icons.mode_comment_outlined,color:Colors.white,),
                    SizedBox(width: 10,),
                    Icon(Icons.send,color: Colors.white,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 5.0,
                        height: 5.0,
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:  Colors.white
                                .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                      ),
                    );
                  }).toList(),
                ),
                Row(
                  children: [
                    Icon(Icons.bookmark_border_rounded,color: Colors.white,),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget scrollPage() {
    return isLoading
        ? ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: intaPosts.posts!.length,
            itemBuilder: (context, index) {
              imgList = intaPosts.posts![index].images!;
              ImageSlider();
              return Container(
                child: Column(
                  children: [Container(
                    margin: const EdgeInsets.only(top:20,left: 20, right: 20),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                            NetworkImage("${intaPosts.posts![index].profileImage}"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${intaPosts.posts![index].postedBy}",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration:BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white)
                            ),
                            child: Text(
                              "Follow",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.more_vert_rounded,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ],
                ),
                  ),
                    SizedBox(
                      height: 10,
                    ),
                    postImage(index),
                    Container(alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 8,left: 8),
                      child: Text("${intaPosts.posts![index].interactions!.likes} likes",style: TextStyle(color: Colors.white),),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 8,right: 8,top: 10,bottom: 20),
                        child: discription(index))
                  ],
                ),
              );
            },
          )
        : Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
      extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   backgroundColor: Colors.black87,
        //   title: Text("Explore"),
        // ),
        body: Container(
            color: Colors.black87,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(height: 70,),
                Row(
                  children: [
                  SizedBox(width: 20,),
                  Icon(Icons.arrow_back,color: Colors.white,),
                    SizedBox(width: 20,),
                  Text("Explore",style: TextStyle(color: Colors.white,fontSize: 18),),
                ],),
                Expanded(child: scrollPage()),
              ],
            )));
  }
}

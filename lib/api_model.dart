class InstagramExplore {
  int? status;
  String? message;
  List<Posts>? posts;

  InstagramExplore({this.status, this.message, this.posts});

  InstagramExplore.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['posts'] != null) {
      posts = <Posts>[];
      json['posts'].forEach((v) {
        posts!.add(new Posts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.posts != null) {
      data['posts'] = this.posts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Posts {
  List<String>? images;
  String? description;
  Interactions? interactions;
  String? postedBy;
  String? profileImage;

  Posts(
      {this.images,
        this.description,
        this.interactions,
        this.postedBy,
        this.profileImage});

  Posts.fromJson(Map<String, dynamic> json) {
    images = json['images'].cast<String>();
    description = json['description'];
    interactions = json['interactions'] != null
        ? new Interactions.fromJson(json['interactions'])
        : null;
    postedBy = json['postedBy'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['images'] = this.images;
    data['description'] = this.description;
    if (this.interactions != null) {
      data['interactions'] = this.interactions!.toJson();
    }
    data['postedBy'] = this.postedBy;
    data['profileImage'] = this.profileImage;
    return data;
  }
}

class Interactions {
  int? likes;
  int? comments;
  bool? bookmarked;

  Interactions({this.likes, this.comments, this.bookmarked});

  Interactions.fromJson(Map<String, dynamic> json) {
    likes = json['likes'];
    comments = json['comments'];
    bookmarked = json['bookmarked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['likes'] = this.likes;
    data['comments'] = this.comments;
    data['bookmarked'] = this.bookmarked;
    return data;
  }
}

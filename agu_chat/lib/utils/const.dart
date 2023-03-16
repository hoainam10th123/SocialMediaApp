import 'package:agu_chat/temp_data/user_modal.dart';
import 'package:agu_chat/views/profile_screen.dart';

import '../temp_data/post_model.dart';
import '../views/chat_screen.dart';
import '../views/feed_screen.dart';
import '../views/group_screen.dart';

const double paddingAll = 10;
List pages = [
  ChatScreen(),
  GroupScreen(),
  FeedScreen(),
  ProfileScreen()
];

//IP-PC: 192.168.1.119 run on real device
const serverName = "192.168.1.9"; //10.0.2.2 for mobile or localhost for desktop app
const urlBase = "http://$serverName:5291";
const hubUrl = "http://$serverName:5291/hubs/";

const fontSize = 22.0;

const appId = "9c29102f9b5749988c092d4d9bab52e9";// agora app id

final List<String> iconsCustom = [
  '😊','😆','😅','🤣','😂','😍','😘', '❤️','💘','🐶','🐵','🦊','🐴','🐷','🐔'
];

final _yourPosts = [_post1, _post3, _post5];
final _yourFavorites = [_post0, _post2, _post4];

// Posts
final _post0 = PostTemp(
  imageUrl: 'assets/images/post0.jpg',
  author: UserTemp(
    profileImageUrl: 'assets/images/user0.jpg',
    backgroundImageUrl: 'assets/images/user_background.jpg',
    name: 'Rebecca',
    following: 453,
    followers: 937,
    posts: [],
    favorites: [],
  ),
  title: 'Post 0',
  location: 'Location 0',
  likes: 102,
  comments: 37,
);
final _post1 = PostTemp(
  imageUrl: 'assets/images/post1.jpg',
  author: UserTemp(
    profileImageUrl: 'assets/images/user1.jpg',
    backgroundImageUrl: 'assets/images/user_background.jpg',
    name: 'Rebecca',
    following: 453,
    followers: 937,
    posts: [],
    favorites: [],
  ),
  title: 'Post 1',
  location: 'Location 1',
  likes: 532,
  comments: 129,
);
final _post2 = PostTemp(
  imageUrl: 'assets/images/post2.jpg',
  author: UserTemp(
    profileImageUrl: 'assets/images/user2.jpg',
    backgroundImageUrl: 'assets/images/user_background.jpg',
    name: 'Rebecca',
    following: 453,
    followers: 937,
    posts: [],
    favorites: [],
  ),
  title: 'Post 2',
  location: 'Location 2',
  likes: 985,
  comments: 213,
);
final _post3 = PostTemp(
  imageUrl: 'assets/images/post3.jpg',
  author: UserTemp(
    profileImageUrl: 'assets/images/user3.jpg',
    backgroundImageUrl: 'assets/images/user_background.jpg',
    name: 'Rebecca',
    following: 453,
    followers: 937,
    posts: [],
    favorites: [],
  ),
  title: 'Post 3',
  location: 'Location 3',
  likes: 402,
  comments: 25,
);
final _post4 = PostTemp(
  imageUrl: 'assets/images/post4.jpg',
  author: UserTemp(
    profileImageUrl: 'assets/images/user4.jpg',
    backgroundImageUrl: 'assets/images/user_background.jpg',
    name: 'Rebecca',
    following: 453,
    followers: 937,
    posts: [],
    favorites: [],
  ),
  title: 'Post 4',
  location: 'Location 4',
  likes: 628,
  comments: 74,
);
final _post5 = PostTemp(
  imageUrl: 'assets/images/post5.jpg',
  author: UserTemp(
    profileImageUrl: 'assets/images/user5.jpg',
    backgroundImageUrl: 'assets/images/user_background.jpg',
    name: 'Rebecca',
    following: 453,
    followers: 937,
    posts: [],
    favorites: [],
  ),
  title: 'Post 5',
  location: 'Location 5',
  likes: 299,
  comments: 28,
);

final posts = [_post0, _post1, _post2, _post3, _post4, _post5];
final users = [
  UserTemp(
    profileImageUrl: 'assets/images/user0.jpg',
    backgroundImageUrl: 'assets/images/user_background.jpg',
    name: 'Rebecca',
    following: 453,
    followers: 937,
    posts: [],
    favorites: [],
  ),
  UserTemp(
    profileImageUrl: 'assets/images/user1.jpg',
    backgroundImageUrl: 'assets/images/user_background.jpg',
    name: 'Rebecca',
    following: 453,
    followers: 937,
    posts: [],
    favorites: [],
  ),
  UserTemp(
    profileImageUrl: 'assets/images/user2.jpg',
    backgroundImageUrl: 'assets/images/user_background.jpg',
    name: 'Rebecca',
    following: 453,
    followers: 937,
    posts: [],
    favorites: [],
  ),
  UserTemp(
    profileImageUrl: 'assets/images/user3.jpg',
    backgroundImageUrl: 'assets/images/user_background.jpg',
    name: 'Rebecca',
    following: 453,
    followers: 937,
    posts: [],
    favorites: [],
  ),
  UserTemp(
    profileImageUrl: 'assets/images/user4.jpg',
    backgroundImageUrl: 'assets/images/user_background.jpg',
    name: 'Rebecca',
    following: 453,
    followers: 937,
    posts: [],
    favorites: [],
  ),
  UserTemp(
    profileImageUrl: 'assets/images/user5.jpg',
    backgroundImageUrl: 'assets/images/user_background.jpg',
    name: 'Rebecca',
    following: 453,
    followers: 937,
    posts: [],
    favorites: [],
  ),
  UserTemp(
    profileImageUrl: 'assets/images/user6.jpg',
    backgroundImageUrl: 'assets/images/user_background.jpg',
    name: 'Rebecca',
    following: 453,
    followers: 937,
    posts: [],
    favorites: [],
  ),
  UserTemp(
    profileImageUrl: 'assets/images/user.jpg',
    backgroundImageUrl: 'assets/images/user_background.jpg',
    name: 'Rebecca',
    following: 453,
    followers: 937,
    posts: _yourPosts,
    favorites: _yourFavorites,
  )
];


// Current User
final UserTemp currentUser = UserTemp(
  profileImageUrl: 'assets/images/user.jpg',
  backgroundImageUrl: 'assets/images/user_background.jpg',
  name: 'Rebecca',
  following: 453,
  followers: 937,
  posts: _yourPosts,
  favorites: _yourFavorites,
);

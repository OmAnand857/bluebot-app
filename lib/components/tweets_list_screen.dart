import 'package:flutter/material.dart';

class TweetsListScreen extends StatefulWidget {
  final DateTime selectedDate;
  const TweetsListScreen({super.key, required this.selectedDate});

  @override
  State<TweetsListScreen> createState() => _TweetsListScreenState();
}

class _TweetsListScreenState extends State<TweetsListScreen> {
  final List<Map<String, String>> tweets = [
    {
      'username': 'elonmusk',
      'avatar':
          'https://abs.twimg.com/sticky/default_profile_images/default_profile_400x400.png',
      'content':
          'Excited to announce new AI features coming to Twitter! #AI #Innovation',
      'time': '2h',
    },
    {
      'username': 'openai',
      'avatar':
          'https://abs.twimg.com/sticky/default_profile_images/default_profile_400x400.png',
      'content':
          'ChatGPT now supports image generation. Try it out! #ChatGPT #AI',
      'time': '3h',
    },
    {
      'username': 'flutterdev',
      'avatar':
          'https://abs.twimg.com/sticky/default_profile_images/default_profile_400x400.png',
      'content':
          'Flutter 3.0 is here with amazing new features for cross-platform apps! #Flutter',
      'time': '4h',
    },
  ];

  int currentPage = 1;
  final int tweetsPerPage = 2;

  List<Map<String, String>> get paginatedTweets {
    int start = (currentPage - 1) * tweetsPerPage;
    int end = (start + tweetsPerPage).clamp(0, tweets.length);
    return tweets.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tweets on ${widget.selectedDate.toLocal().toString().split(' ')[0]}',
        ),
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: paginatedTweets.length,
              itemBuilder: (context, index) {
                final tweet = paginatedTweets[index];
                return _tweetCard(tweet);
              },
            ),
          ),
          _paginationControls(),
        ],
      ),
    );
  }

  Widget _tweetCard(Map<String, String> tweet) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(tweet['avatar']!),
                  radius: 28,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Your Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.verified,
                            color: Color(0xFF1DA1F2),
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '@${tweet['username']}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.more_horiz,
                            color: Colors.grey[600],
                            size: 22,
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(tweet['content']!, style: TextStyle(fontSize: 15)),
                      if (tweet['content']!.contains('#')) ...[
                        SizedBox(height: 4),
                        Wrap(
                          children: tweet['content']!
                              .split(' ')
                              .where((word) => word.startsWith('#'))
                              .map(
                                (tag) => Padding(
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: Text(
                                    tag,
                                    style: TextStyle(color: Color(0xFF1DA1F2)),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            '11:30 PM · 21/03/2030 · ',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '987K Views',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 20, thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _tweetStat('82k', 'Retweets'),
                          _tweetStat('45k', 'Quotes'),
                          _tweetStat('91k', 'Likes'),
                          _tweetStat('78k', 'Bookmarks'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tweetStat(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _paginationControls() {
    int totalPages = (tweets.length / tweetsPerPage).ceil();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: currentPage > 1
                ? () => setState(() => currentPage--)
                : null,
          ),
          Text('Page $currentPage of $totalPages'),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: currentPage < totalPages
                ? () => setState(() => currentPage++)
                : null,
          ),
        ],
      ),
    );
  }
}

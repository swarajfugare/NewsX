class NewsArticle {
  final String id;
  final String title;
  final String summary; // English summary
  final String? summaryMr; // Marathi summary
  final String? summaryHi; // Hindi summary
  final String imageUrl;
  final String category;
  final String? categoryAi;
  final String author;
  final String authorAvatar;
  final DateTime publishedAt;
  final String readTime;
  final String language;
  final int likes;
  final int shares;
  final int commentsCount;
  final bool isLiked;
  final bool isBookmarked;
  final String sourceUrl;
  final String? whyItMatters;
  final String sentiment;
  final int importanceScore;
  final List<String> tags;
  final List<String> keywords;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    this.summaryMr,
    this.summaryHi,
    required this.imageUrl,
    required this.category,
    this.categoryAi,
    required this.author,
    required this.authorAvatar,
    required this.publishedAt,
    required this.readTime,
    this.language = 'English',
    required this.likes,
    required this.shares,
    required this.commentsCount,
    this.isLiked = false,
    this.isBookmarked = false,
    this.sourceUrl = 'https://news.google.com',
    this.whyItMatters = 'Key technological shift driving next-generation AI workflows.',
    this.sentiment = 'Neutral',
    this.importanceScore = 8,
    this.tags = const ['AI', 'Tech', 'NewsX'],
    this.keywords = const ['Innovation', 'Breakthrough'],
  });

  String getDisplaySummary(String selectedLang) {
    if (selectedLang == 'Hindi' && summaryHi != null && summaryHi!.isNotEmpty) {
      return summaryHi!;
    }
    if (selectedLang == 'Marathi' && summaryMr != null && summaryMr!.isNotEmpty) {
      return summaryMr!;
    }
    return summary;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'summary_mr': summaryMr,
      'summary_hi': summaryHi,
      'imageUrl': imageUrl,
      'category': category,
      'category_ai': categoryAi,
      'author': author,
      'authorAvatar': authorAvatar,
      'publishedAt': publishedAt.toIso8601String(),
      'readTime': readTime,
      'language': language,
      'likes': likes,
      'shares': shares,
      'commentsCount': commentsCount,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
      'sourceUrl': sourceUrl,
      'why_it_matters': whyItMatters,
      'sentiment': sentiment,
      'importance_score': importanceScore,
      'tags': tags,
      'keywords': keywords,
    };
  }

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      summaryMr: json['summary_mr'] as String?,
      summaryHi: json['summary_hi'] as String?,
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String? ?? '',
      category: json['category'] as String,
      categoryAi: json['category_ai'] as String?,
      author: json['author'] as String? ?? json['source_name'] as String? ?? 'NewsX',
      authorAvatar: json['authorAvatar'] as String? ?? json['author_avatar'] as String? ?? '',
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'] as String)
          : (json['published_at'] != null ? DateTime.parse(json['published_at'] as String) : DateTime.now()),
      readTime: json['readTime'] as String? ?? json['read_time'] as String? ?? '1 min',
      language: json['language'] as String? ?? 'English',
      likes: json['likes'] as int? ?? json['likes_count'] as int? ?? 0,
      shares: json['shares'] as int? ?? json['shares_count'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? json['comments_count'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      sourceUrl: json['sourceUrl'] as String? ?? json['source_url'] as String? ?? json['canonical_url'] as String? ?? 'https://news.google.com',
      whyItMatters: json['whyItMatters'] as String? ?? json['why_it_matters'] as String? ?? 'Key impact insight.',
      sentiment: json['sentiment'] as String? ?? 'Neutral',
      importanceScore: json['importanceScore'] as int? ?? json['importance_score'] as int? ?? 8,
      tags: (json['tags'] is List) ? (json['tags'] as List).map((e) => e.toString()).toList() : const ['AI', 'Tech'],
      keywords: (json['keywords'] is List) ? (json['keywords'] as List).map((e) => e.toString()).toList() : const ['News'],
    );
  }
}

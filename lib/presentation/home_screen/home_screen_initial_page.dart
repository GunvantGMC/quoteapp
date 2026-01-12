import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import './widgets/action_button_widget.dart';
import './widgets/quote_card_widget.dart';
import '../../services/quote_service.dart';
import '../../services/favorites_service.dart';
import '../../services/streak_service.dart';

class HomeScreenInitialPage extends StatefulWidget {
  const HomeScreenInitialPage({super.key});

  @override
  State<HomeScreenInitialPage> createState() => _HomeScreenInitialPageState();
}

class _HomeScreenInitialPageState extends State<HomeScreenInitialPage> {
  bool _isLoading = false;
  bool _isFavorited = false;
  int _streakDays = 0;
  final QuoteService _quoteService = QuoteService();
  final FavoritesService _favoritesService = FavoritesService();
  final StreakService _streakService = StreakService();

  Map<String, dynamic> _currentQuote = {
    "id": "",
    "text": "Loading your daily inspiration...",
    "author": "",
    "category": "",
  };

  @override
  void initState() {
    super.initState();
    _loadInitialQuote();
    _loadStreak();
  }

  Future<void> _loadStreak() async {
    final streak = await _streakService.getStreakCount();
    setState(() {
      _streakDays = streak;
    });
  }

  Future<void> _loadInitialQuote() async {
    setState(() => _isLoading = true);
    try {
      final quote = await _quoteService.getRandomQuote();
      final isFav = await _favoritesService.isFavorited(quote['id']);
      setState(() {
        _currentQuote = quote;
        _isFavorited = isFav;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _currentQuote = {
          "id": "error",
          "text": "Unable to load quote. Please try again.",
          "author": "",
          "category": "",
        };
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshQuote() async {
    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    try {
      final quote = await _quoteService.getRandomQuote();
      final isFav = await _favoritesService.isFavorited(quote['id']);
      setState(() {
        _currentQuote = quote;
        _isFavorited = isFav;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _currentQuote = {
          "id": "error",
          "text": "Unable to load quote. Please try again.",
          "author": "",
          "category": "",
        };
        _isLoading = false;
      });
      ScaffoldMessenger.of(context.mounted ? context : context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch new quote'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _toggleFavorite() async {
    HapticFeedback.lightImpact();

    if (_currentQuote['id'] == 'error' || _currentQuote['id'].isEmpty) {
      return;
    }

    final newFavoriteState = !_isFavorited;

    if (newFavoriteState) {
      final success = await _favoritesService.addToFavorites(_currentQuote);
      if (success) {
        setState(() => _isFavorited = true);
        ScaffoldMessenger.of(context.mounted ? context : context).showSnackBar(
          SnackBar(
            content: Text('Added to favorites'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else {
      final success = await _favoritesService.removeFromFavorites(
        _currentQuote['id'],
      );
      if (success) {
        setState(() => _isFavorited = false);
        ScaffoldMessenger.of(context.mounted ? context : context).showSnackBar(
          SnackBar(
            content: Text('Removed from favorites'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _shareQuote() {
    HapticFeedback.selectionClick();
    final String shareText =
        '"${_currentQuote["text"]}"\n\n- ${_currentQuote["author"]}';
    SharePlus.instance.share(
      ShareParams(text: shareText, subject: 'Inspirational Quote'),
    );
  }

  void _copyQuoteText() {
    HapticFeedback.lightImpact();
    final String copyText =
        '"${_currentQuote["text"]}"\n\n- ${_currentQuote["author"]}';
    Clipboard.setData(ClipboardData(text: copyText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quote copied to clipboard'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showQuoteOptions() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.content_copy,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text('Copy Quote'),
              onTap: () {
                Navigator.pop(context);
                _copyQuoteText();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.share,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text('Share Quote'),
              onTap: () {
                Navigator.pop(context);
                _shareQuote();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F2419), Color(0xFF1A3A2E), Color(0xFF0F2419)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(theme),
              SizedBox(height: 2.h),
              _buildStreakCounter(theme),
              Expanded(
                child: Center(
                  child: _isLoading
                      ? _buildLoadingIndicator(theme)
                      : QuoteCardWidget(
                          quote: _currentQuote,
                          onLongPress: _showQuoteOptions,
                        ),
                ),
              ),
              _buildActionBar(theme),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Daily Inspiration',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 20.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCounter(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF4ADE80), width: 2),
        borderRadius: BorderRadius.circular(30),
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, color: Color(0xFF4ADE80), size: 24),
          SizedBox(width: 2.w),
          Text(
            '$_streakDays',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Color(0xFF4ADE80),
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            'DAY STREAK',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return CircularProgressIndicator(color: Color(0xFF4ADE80), strokeWidth: 3);
  }

  Widget _buildActionBar(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Color(0xFF1A3A2E).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Color(0xFF2C5F41), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ActionButtonWidget(
            icon: _isFavorited ? 'favorite' : 'favorite_border',
            label: 'Favorite',
            onTap: _toggleFavorite,
            color: _isFavorited ? Color(0xFF4ADE80) : Color(0xFF6B8E7F),
          ),
          Container(width: 1, height: 6.h, color: Color(0xFF2C5F41)),
          ActionButtonWidget(
            icon: 'refresh',
            label: 'NEXT',
            onTap: _refreshQuote,
            color: Color(0xFF4ADE80),
            isLarge: true,
          ),
          Container(width: 1, height: 6.h, color: Color(0xFF2C5F41)),
          ActionButtonWidget(
            icon: 'share',
            label: 'Share',
            onTap: _shareQuote,
            color: Color(0xFF6B8E7F),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/favorites_service.dart';
import './widgets/empty_favorites_widget.dart';
import './widgets/favorite_quote_card_widget.dart';

/// Favorites Screen - Displays user's saved inspirational quotes collection
///
/// Features:
/// - Search functionality with real-time filtering
/// - Swipe-to-delete with confirmation dialog
/// - Long-press context menu (Share, Copy, Remove)
/// - Pull-to-refresh for cloud sync
/// - Empty state with navigation to Home
/// - Smooth scrolling with efficient cell recycling
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final FavoritesService _favoritesService = FavoritesService();

  List<Map<String, dynamic>> _allFavorites = [];
  List<Map<String, dynamic>> _filteredFavorites = [];
  bool _isSearching = false;
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// Load favorites from shared preferences
  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);

    final favorites = await _favoritesService.getFavorites();

    setState(() {
      _allFavorites = favorites.map((fav) {
        return {
          "id": fav['id'] ?? '',
          "quote": fav['text'] ?? fav['quote'] ?? '',
          "author": fav['author'] ?? 'Unknown',
          "dateSaved": fav['dateSaved'] != null
              ? DateTime.parse(fav['dateSaved'])
              : DateTime.now(),
          "category": fav['category'] ?? 'Inspiration',
        };
      }).toList();
      _filteredFavorites = List.from(_allFavorites);
      _isLoading = false;
    });
  }

  /// Handle search query changes with debouncing
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();

      if (_searchQuery.isEmpty) {
        _filteredFavorites = List.from(_allFavorites);
      } else {
        _filteredFavorites = _allFavorites.where((favorite) {
          final quote = (favorite["quote"] as String).toLowerCase();
          final author = (favorite["author"] as String).toLowerCase();
          return quote.contains(_searchQuery) || author.contains(_searchQuery);
        }).toList();
      }
    });
  }

  /// Handle pull-to-refresh
  Future<void> _handleRefresh() async {
    await _loadFavorites();
  }

  /// Remove quote from favorites with undo option
  Future<void> _removeFromFavorites(String quoteId, int index) async {
    final removedQuote = _filteredFavorites[index];

    // Remove from service first
    final success = await _favoritesService.removeFromFavorites(quoteId);

    if (success) {
      setState(() {
        _allFavorites.removeWhere((quote) => quote["id"] == quoteId);
        _filteredFavorites.removeAt(index);
      });

      ScaffoldMessenger.of(context.mounted ? context : context).showSnackBar(
        SnackBar(
          content: Text(
            'Quote removed from favorites',
            style: TextStyle(fontSize: 12.sp),
          ),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () async {
              await _favoritesService.addToFavorites({
                'id': removedQuote['id'],
                'text': removedQuote['quote'],
                'author': removedQuote['author'],
                'category': removedQuote['category'],
              });
              await _loadFavorites();
            },
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Show delete confirmation dialog
  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    final theme = Theme.of(context);

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(
                'Remove from Favorites?',
                style: theme.textTheme.titleLarge,
              ),
              content: Text(
                'This quote will be removed from your favorites collection.',
                style: theme.textTheme.bodyMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: Text(
                    'REMOVE',
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  /// Navigate to Home screen
  void _navigateToHome() {
    Navigator.of(context, rootNavigator: true).pushNamed('/home-screen');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Sticky search header
        Container(
          color: theme.scaffoldBackgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: Text(
                    'Favorites',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Search quotes or authors...',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'search',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: CustomIconWidget(
                                iconName: 'close',
                                color: theme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                _searchFocusNode.unfocus();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.5.h,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _isSearching = value.isNotEmpty;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // Favorites list or empty state
        Expanded(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                )
              : _filteredFavorites.isEmpty
              ? EmptyFavoritesWidget(
                  isSearching: _isSearching,
                  onDiscoverQuotes: _navigateToHome,
                )
              : RefreshIndicator(
                  onRefresh: _handleRefresh,
                  color: theme.colorScheme.primary,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    itemCount: _filteredFavorites.length,
                    separatorBuilder: (context, index) => SizedBox(height: 2.h),
                    itemBuilder: (context, index) {
                      final favorite = _filteredFavorites[index];

                      return FavoriteQuoteCardWidget(
                        quote: favorite["quote"] as String,
                        author: favorite["author"] as String,
                        dateSaved: favorite["dateSaved"] as DateTime,
                        category: favorite["category"] as String,
                        searchQuery: _searchQuery,
                        onDelete: () async {
                          final confirmed = await _showDeleteConfirmation(
                            context,
                          );
                          if (confirmed) {
                            await _removeFromFavorites(
                              favorite["id"] as String,
                              index,
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

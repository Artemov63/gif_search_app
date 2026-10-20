import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/gif_item.dart';
import '../services/giphy_service.dart';
import 'gif_details_screen.dart';
import '../widgets/search_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GiphyService _giphyService = GiphyService();
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<GifItem> _gifUrls = [];
  Timer? _debounce;
  int _searchVersion = 0;
  int? _loadingMoreVersion;
  bool _isLoading = false;
  String? _errorMessage;
  String? _paginationError;
  int _offset = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChanged);
    _scrollController.addListener(_onScroll);
    _loadGif('');
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _searchVersion++;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _loadGif(query);
    });
  }

  Future<void> _loadGif(String query) async {
    final currentVersion = ++_searchVersion;

    _currentQuery = query;
    _offset = 0;
    _hasMore = true;

    setState(() {
      _isLoading = true;
      _isLoadingMore = false;
      _errorMessage = null;
      _paginationError = null;
      _gifUrls = [];
    });

    try {
      final urls = await _giphyService.searchGifs(query, 0);

      if (!mounted || currentVersion != _searchVersion) return;

      setState(() {
        _gifUrls = urls;
        _offset = urls.length;
        _hasMore = urls.length == 25;
        _isLoading = false;
      });

      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      _loadMoreIfNeeded();
    } catch (error) {
      if (!mounted || currentVersion != _searchVersion) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load GIFs. Please try again.';
      });

      debugPrint('Failed to load GIFs: $error');
    }
  }

  Future<void> _loadMoreGifs({bool retry = false}) async {
    if (_loadingMoreVersion == _searchVersion ||
        _isLoading ||
        !_hasMore ||
        _gifUrls.isEmpty ||
        (_paginationError != null && !retry)) {
      return;
    }

    final currentVersion = _searchVersion;
    _loadingMoreVersion = currentVersion;
    setState(() {
      _isLoadingMore = true;
      _paginationError = null;
    });

    try {
      final urls = await _giphyService.searchGifs(_currentQuery, _offset);

      if (!mounted || currentVersion != _searchVersion) return;

      setState(() {
        _gifUrls.addAll(urls);
        _offset += urls.length;
        _hasMore = urls.length == 25;
      });
    } catch (error) {
      if (!mounted || currentVersion != _searchVersion) return;

      setState(() {
        _paginationError = 'Failed to load more GIFs.';
      });

      debugPrint('Failed to load more GIFs: $error');
    } finally {
      if (_loadingMoreVersion == currentVersion) {
        _loadingMoreVersion = null;

        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      }
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients ||
        _isLoading ||
        (_debounce?.isActive ?? false)) {
      return;
    }

    final position = _scrollController.position;

    if (position.extentAfter < 300) {
      _loadMoreGifs();
    }
  }

  void _loadMoreIfNeeded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          !_scrollController.hasClients ||
          _isLoading ||
          !_hasMore ||
          (_debounce?.isActive ?? false)) {
        return;
      }

      if (_scrollController.position.extentAfter < 300) {
        _loadMoreGifs();
      }
    });
  }

  void _onFocusChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _giphyService.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showTrending() {
    _debounce?.cancel();
    _searchController.clear();
    _searchFocusNode.unfocus();
    _loadGif('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        title: InkWell(
          onTap: _showTrending,
          child: Text(
            widget.title,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
        actions: const [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: Text(
                'Powered by GIPHY',
                style: TextStyle(fontSize: 11, color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_errorMessage!, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () => _loadGif(_currentQuery),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _gifUrls.isEmpty
                ? const Center(child: Text('No GIFs found'))
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final isLandscape =
                          MediaQuery.orientationOf(context) ==
                          Orientation.landscape;

                      final crossAxisCount =
                          isLandscape || constraints.maxWidth >= 1000 ? 4 : 2;

                      return Stack(
                        children: [
                          MasonryGridView.builder(
                            controller: _scrollController,
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            padding: const EdgeInsets.all(8),
                            gridDelegate:
                                SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                ),
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,

                            itemCount: _gifUrls.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  _searchFocusNode.unfocus();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GifDetailsScreen(
                                        gif: _gifUrls[index],
                                      ),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: AspectRatio(
                                    aspectRatio:
                                        _gifUrls[index].width /
                                        _gifUrls[index].height,
                                    child: Image.network(
                                      _gifUrls[index].url,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              color: const Color(0xFF30323C),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.broken_image_outlined,
                                                  color: Colors.white54,
                                                  size: 32,
                                                ),
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          if (_isLoadingMore)
                            const Positioned(
                              bottom: 100,
                              left: 0,
                              right: 0,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          if (_paginationError != null)
                            Positioned(
                              bottom: 80,
                              left: 16,
                              right: 16,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        child: Text('Failed to load more GIFs'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            _loadMoreGifs(retry: true),
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
          ),

          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: SafeArea(
              top: false,
              child: GifSearchBar(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: _onSearchChanged,
                onSubmitted: (value) {
                  _debounce?.cancel();
                  _loadGif(value);
                  _searchFocusNode.unfocus();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

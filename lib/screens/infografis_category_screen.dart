import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/bps_service.dart';
import '../models/infografis_model.dart';
import '../utils/infografis_category_mapper.dart';
import 'infografis_detail_screen.dart';
import '../utils/local_cache_image.dart';
import '../services/image_cache_manager.dart';

class InfografisCategoryScreen extends StatefulWidget {
  final String category;

  const InfografisCategoryScreen({
    super.key,
    required this.category,
  });

  @override
  State<InfografisCategoryScreen> createState() =>
      _InfografisCategoryScreenState();
}

class _InfografisCategoryScreenState extends State<InfografisCategoryScreen>
    with AutomaticKeepAliveClientMixin {
  late Future<List<InfografisModel>> _future;

  final ScrollController _scrollController = ScrollController();
  final int _pageSize = 6;

  final List<InfografisModel> _allData = [];
  final List<InfografisModel> _visibleData = [];

  bool _isLoadingMore = false;
  bool _isPreloading = false;
  double _preloadProgress = 0;

  @override
  void initState() {
    super.initState();
    _future = BpsService.getInfografis();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    const threshold = 150;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - threshold &&
        !_isLoadingMore &&
        _visibleData.length < _allData.length) {
      _loadMore();
    }
  }

  Future<void> _startPreload(List<InfografisModel> items) async {
    if (items.isEmpty || _isPreloading) return;

    setState(() {
      _isPreloading = true;
      _preloadProgress = 0;
    });

    await ImageCacheManager.preloadBatch(
      urls: items.map((e) => e.image).toList(),
      onProgress: (progress) {
        if (mounted) {
          setState(() => _preloadProgress = progress);
        }
      },
    );

    if (mounted) {
      setState(() => _isPreloading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);

    await Future.delayed(const Duration(milliseconds: 150));

    final nextItems =
        _allData.skip(_visibleData.length).take(_pageSize).toList();

    if (nextItems.isNotEmpty) {
      setState(() {
        _visibleData.addAll(nextItems);
      });

      _startPreload(nextItems);
    }

    if (mounted) {
      setState(() => _isLoadingMore = false);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final String categoryTitle =
        mapInfografisCategory(int.tryParse(widget.category) ?? 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryTitle,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder<List<InfografisModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Data infografis tidak ditemukan."),
            );
          }

          if (_allData.isEmpty) {
            final filtered = snapshot.data!
                .where((e) => e.category.toString() == widget.category)
                .toList();

            _allData.addAll(filtered);
            _visibleData.addAll(_allData.take(_pageSize));

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _startPreload(_visibleData);
            });
          }

          return Column(
            children: [
              if (_isPreloading)
                LinearProgressIndicator(value: _preloadProgress),
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _visibleData.length + (_isLoadingMore ? 1 : 0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    if (index >= _visibleData.length) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }

                    return _InfografisGridItem(item: _visibleData[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfografisGridItem extends StatelessWidget {
  final InfografisModel item;

  const _InfografisGridItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => InfografisDetailScreen(item: item),
          ),
        );
      },
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: SizedBox.expand(
                  child: LocalCacheImage(
                    imageUrl: item.image,
                    fit: BoxFit.cover, // full cover aman
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              child: Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

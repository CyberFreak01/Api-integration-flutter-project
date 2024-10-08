import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stockimagesapp/api_helper/pixabay_api.dart';
import 'package:stockimagesapp/image_view.dart';
import 'models/imgItem.dart';

void main() => runApp(const GridViewNetwork());

class GridViewNetwork extends StatefulWidget {
  const GridViewNetwork({super.key});

  @override
  State<GridViewNetwork> createState() => _GridViewNetworkState();
}

class _GridViewNetworkState extends State<GridViewNetwork> {
  List<Hit> imgItems = [];
  PixaApi api = PixaApi();
  final scrollController = ScrollController();
  int page = 1;
  bool isLoading = false;
  bool isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    loadData();
  }

  void _scrollListener() {
    if (!isLoading &&
        scrollController.position.pixels >
            scrollController.position.maxScrollExtent - 500) {
      page++;
      loadData();
    }
  }

  Future<void> loadData() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final jsonResponse = await api.getImages(
        apiKey: '46327378-e231823b238177af147e8d281',
        query: 'nature',
        page: page,
      );

      final decodedData = jsonResponse;
      var productsData = decodedData["hits"];
      debugPrint(jsonResponse.toString());
      setState(() {
        imgItems += List.from(productsData)
            .map<Hit>((item) => Hit.fromJson(item))
            .toList();
        isInitialLoad = false;
      });
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }



  Widget _buildImageItem(Hit product) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  product.largeImageUrl ?? "",
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildShimmerEffect();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error_outline, color: Colors.red),
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.thumb_up,
                                size: 16, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              '${product.likes}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.remove_red_eye,
                                size: 16, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              '${product.views}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Images',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stock Image App'),
          backgroundColor: Colors.blueAccent,
        ),
        body: SafeArea(
          child: isInitialLoad
              ? _buildInitialShimmer()
              : LayoutBuilder(
                  builder: (context, constraints) {
                    int columns = (constraints.maxWidth ~/ 300).toInt();
                    return Stack(
                      children: [
                        GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 16.0,
                            childAspectRatio: 1.0,
                          ),
                          padding: const EdgeInsets.all(8.0),
                          itemCount: imgItems.length,
                          controller: scrollController,
                          itemBuilder: (context, index) =>
                              InkWell(
                                onTap: () {
                    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => ZoomableImagePage(
        imageUrl: imgItems[index].largeImageUrl ?? "",
      ),
    );

                  },
                                child: _buildImageItem(imgItems[index])
                                ),
                        ),
                        if (isLoading && !isInitialLoad)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              color: Colors.white.withOpacity(0.8),
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Loading more images...',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
        ),
        drawer: const Drawer(
          backgroundColor: Colors.blueAccent,
          child: Center(child: Text("Browse Stock Images !")),
        ),
      ),
    );
  }

  Widget _buildInitialShimmer() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = (constraints.maxWidth ~/ 300).toInt();
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: 1.0,
          ),
          padding: const EdgeInsets.all(8.0),
          itemCount: 12, // Show 12 shimmer placeholders initially
          itemBuilder: (context, index) => Card(
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            child: _buildShimmerEffect(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

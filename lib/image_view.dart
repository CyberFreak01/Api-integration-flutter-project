import 'package:flutter/material.dart';
import 'dart:math' as math;

class ZoomableImagePage extends StatefulWidget {
  final String imageUrl;

  const ZoomableImagePage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<ZoomableImagePage> createState() => _WebZoomableImagePageState();
}

class _WebZoomableImagePageState extends State<ZoomableImagePage> {
  final TransformationController _transformationController = TransformationController();
  late TapDownDetails _doubleTapDetails;

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails.localPosition;
      // Zoom in to 2x on double tap
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 1, -position.dy * 1)
        ..scale(2.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.5,
              maxScale: 4.0,
              child: GestureDetector(
                onDoubleTapDown: _handleDoubleTapDown,
                onDoubleTap: _handleDoubleTap,
                child: Image.network(
                  widget.imageUrl,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / 
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.white,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 40),
                        const SizedBox(height: 16),
                        const Text(
                          'Error loading image',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close', 
                            style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  onPressed: () {
                    final Matrix4 currentMatrix = _transformationController.value;
                    final Matrix4 newMatrix = currentMatrix.clone()..scale(0.8);
                    _transformationController.value = newMatrix;
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'zoomIn',
                  onPressed: () {
                    final Matrix4 currentMatrix = _transformationController.value;
                    final Matrix4 newMatrix = currentMatrix.clone()..scale(1.2);
                    _transformationController.value = newMatrix;
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
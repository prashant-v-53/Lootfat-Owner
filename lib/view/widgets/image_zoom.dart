import 'package:flutter/material.dart';
import 'package:lootfat_owner/utils/utils.dart';

class ImageZoomScreen extends StatefulWidget {
  final String url;
  const ImageZoomScreen({
    super.key,
    required this.url,
  });

  @override
  State<ImageZoomScreen> createState() => _ImageZoomScreenState();
}

class _ImageZoomScreenState extends State<ImageZoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InteractiveViewer(
        panEnabled: true,
        child: Center(
          child: Hero(
            tag: widget.url,
            child: Image.network(
              '${widget.url}',
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) =>
                  Utils.loadingBuilder(
                context,
                child,
                loadingProgress,
              ),
              errorBuilder: (context, child, loadingProgress) =>
                  Utils.errorBuilder(
                context,
                child,
                loadingProgress,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

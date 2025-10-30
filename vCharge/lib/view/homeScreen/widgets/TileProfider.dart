import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/src/painting/image_provider.dart';
import 'package:flutter_map/flutter_map.dart';

class CachedTileProvider implements TileProvider {
  final String tileCacheKey;

  CachedTileProvider(this.tileCacheKey);

  ImageProvider getTile(int x, int y, int z) {
    // Modify the URL template to include x, y, and z values
    final String url =
        'https://api.mapbox.com/styles/v1/mapbox/outdoors-v12/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYXRoYXJ2YTcwIiwiYSI6ImNsZjk3cTUxZDJjc2czems3N2F3d2Y2aWUifQ._j3hKxoBC_Gnh4-qddn8lg';
// Use the cache manager to get the tile image
    return CachedNetworkImageProvider(url);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Map<String, String> generateReplacementMap(
      String urlTemplate, TileCoordinates coordinates, TileLayer options) {
    // TODO: implement generateReplacementMap
    throw UnimplementedError();
  }

  @override
  ImageProvider<Object> getImage(
      TileCoordinates coordinates, TileLayer options) {
    // TODO: implement getImage
    throw UnimplementedError();
  }

  @override
  ImageProvider<Object> getImageWithCancelLoadingSupport(
      TileCoordinates coordinates,
      TileLayer options,
      Future<void> cancelLoading) {
    // TODO: implement getImageWithCancelLoadingSupport
    throw UnimplementedError();
  }

  @override
  String? getTileFallbackUrl(TileCoordinates coordinates, TileLayer options) {
    // TODO: implement getTileFallbackUrl
    throw UnimplementedError();
  }

  @override
  String getTileUrl(TileCoordinates coordinates, TileLayer options) {
    // TODO: implement getTileUrl
    throw UnimplementedError();
  }

  @override
  // TODO: implement headers
  Map<String, String> get headers => throw UnimplementedError();

  @override
  String populateTemplatePlaceholders(
      String urlTemplate, TileCoordinates coordinates, TileLayer options) {
    // TODO: implement populateTemplatePlaceholders
    throw UnimplementedError();
  }

  @override
  // TODO: implement supportsCancelLoading
  bool get supportsCancelLoading => throw UnimplementedError();
}

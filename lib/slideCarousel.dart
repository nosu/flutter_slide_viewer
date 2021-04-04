import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/slides/v1.dart' as slides;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart' show SystemNavigator, rootBundle;
import 'package:transparent_image/transparent_image.dart';
import 'dart:io';

class SlideCarouselContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
          onTap: () => print('onTap()'),
          onTapCancel: () => print('onTapCancel()'),
          onTapDown: (datails) => print('onTapDown()'),
          onTapUp: (details) => print('onTapUp()'),
          onHorizontalDragDown: (details) => print('onHorizontalDragDown()'),
          onHorizontalDragCancel: () => print('onHorizontalDragCancel()'),
          onHorizontalDragStart: (details) => print('onHorizontalDragStart()'),
          onHorizontalDragUpdate: (details) => print('onHorizontalDragUpdate()'),
          onHorizontalDragEnd: (details) => print('onHorizontalDragEnd()'),
          onVerticalDragEnd: (details) {
            print("onVerticalDragEnd primaryVelocity:" + details.primaryVelocity.toString());
            if(details.primaryVelocity > 0) {
              print("Swipe down");
              SystemNavigator.pop();
            }
          },
          child: SlideCarousel()
      ),
    );
  }
}

class SlideCarousel extends StatelessWidget {

  Future<ServiceAccountCredentials> loadCredentials() async {
    print("loadCredentials()");
    var credentialJson = await rootBundle.loadString('.secret/gws-full-access.json');
    print("json loaded successfully.");
    ServiceAccountCredentials credentials = ServiceAccountCredentials.fromJson(credentialJson);
    print("Credential loaded successfully.");
    return credentials;
  }

  Future<List<slides.Thumbnail>> apiTest() async {
    print("apiTest()");
    const presentationId = "1moBhq1SBkfKaI4N-JeBvZUFcgJGa33y7PNQwhtruRPU";

    final credentials = await loadCredentials();
    final scopes = [slides.SlidesApi.presentationsReadonlyScope];
    final httpClient = await clientViaServiceAccount(credentials, scopes);
    try {
      var slidesApi = slides.SlidesApi(httpClient);
      var presentation = await slidesApi.presentations.get(presentationId);
      var futureThumbnails = presentation.slides.map((slide) async => await slidesApi.presentations.pages.getThumbnail(presentationId, slide.objectId));
      var thumbnails = await Future.wait(futureThumbnails);
      return thumbnails;
    } catch(e, trace) {
      print("Error: " + e.toString());
      print("Stacktrace" + trace.toString());
    } finally {
      httpClient.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Fullscreen sliding carousel demo')),
      body: FutureBuilder(
        future: apiTest(),
        builder: (context, AsyncSnapshot<List<slides.Thumbnail>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 非同期処理未完了 = 通信中
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.error != null) {
            // エラー
            return Center(
                child: Text('エラーがおきました')
            );
          };

          if(!snapshot.hasData) {
            return Center(
                child: Text('snapshot has no data')
            );
          }

          final double height = MediaQuery.of(context).size.height;
          final List<slides.Thumbnail> thumbnails = snapshot.data;
          return CarouselSlider(
            options: CarouselOptions(
              height: height,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              // autoPlay: false,
            ),
            items: thumbnails.map((thumbnail) => new GestureDetector(
              onTap: () {
                print(thumbnail.contentUrl + "clicked");
              },
              child: Center(
                  // child: Image.network(item, fit: BoxFit.cover, height: height,)
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: thumbnail.contentUrl,
                ),
              ),
            )).toList(),
          );
        },
      ),
    );
  }

}

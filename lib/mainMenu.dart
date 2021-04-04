import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slide_viewer/slideCarousel.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => print('onTap()'),
        onTapCancel: () => print('onTapCancel()'),
        onTapDown: (details) => print('onTapDown()'),
        onTapUp: (details) => print('onTapUp()'),
        onHorizontalDragDown: (details) => print('onHorizontalDragDown()'),
        onHorizontalDragCancel: () => print('onHorizontalDragCancel()'),
        onHorizontalDragStart: (details) => print('onHorizontalDragStart()'),
        onHorizontalDragUpdate: (details) => print('onHorizontalDragUpdate()'),
        onHorizontalDragEnd: (details) => print('onHorizontalDragEnd()'),
        child: MaterialApp(initialRoute: '/', routes: {
          // '/': (ctx) => MainMenuHome(),
          '/': (ctx) => SlideCarouselContainer(),
          '/slideCarousel': (ctx) => SlideCarouselContainer(),
        }),
      ),
    );
  }
}

class DemoItem extends StatelessWidget {
  final String title;
  final String route;

  DemoItem(this.title, this.route);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}

class MainMenuHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carousel demo'),
      ),
      body: ListView(
        children: <Widget>[
          DemoItem('GWS Slides as Carousel', '/slideCarousel'),
        ],
      ),
    );
  }
}

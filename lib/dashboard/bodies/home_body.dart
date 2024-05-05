import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/dashboard/bodies/product_body.dart';
import 'package:popover/popover.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  Future<List<BestsellerModel>> getProducts() async {
    final uri = Uri.parse('https://fakestoreapi.com/products');
    final list = <BestsellerModel>[];

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final rawList = responseBody as Iterable?; // [] | null
        for (var element in rawList ?? []) {
          final product = BestsellerModel.fromJson(element);
          list.add(product);
        }
        log(rawList.toString());
      } else {
        throw Exception('status code is not equal to 200');
      }
    } catch (e) {
      log(e.toString());
    }
    return list;
  }

  Future<List<String>> getCategories() async {
    final uri = Uri.parse('https://fakestoreapi.com/products/categories');
    final list = <String>[];

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final rawList = responseBody as Iterable?; // [] | null
        for (var element in rawList ?? []) {
          list.add(element);
        }
        log(rawList.toString());
      } else {
        throw Exception('status code is not equal to 200');
      }
    } catch (e) {
      log(e.toString());
    }
    return list;
  }

  Future<List> initScreen() async {
    return Future.wait([
      getProducts(),
      getCategories(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initScreen(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('error'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final products = snapshot.data?[0] as List<BestsellerModel>;
          final categories = snapshot.data?[1];
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                toolbarHeight: 80.0,
                expandedHeight: 80.0,
                backgroundColor: const Color.fromARGB(255, 255, 246, 244),
                flexibleSpace: FlexibleSpaceBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const _AppbarRow1(),
                      _AppbarRow2(
                        categories: categories,
                      ),
                      const _AppbarRow3(),
                    ],
                  ),
                ),
                centerTitle: true,
              ),
              SliverToBoxAdapter(
                child: CustomCarouselSliderWidget(),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'icon.png',
                        height: 42,
                        width: 42,
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        'Bestsellers',
                        style: TextStyle(
                          fontSize: 42,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverLayoutBuilder(builder: (context, constraints) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 1200.0,
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300.0,
                          mainAxisExtent: 400.0,
                          mainAxisSpacing: 15.0,
                          crossAxisSpacing: 15.0,
                        ),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductBody(
                                    id: product.id,
                                  ),
                                ),
                              );
                            },
                            child: ProductWidget(
                              title: product.title ?? '',
                              image: product.image ?? '',
                              price: product.price ?? 0.0,
                            ),
                          );
                        },
                        itemCount:
                            ((products.length) > 8) ? 8 : products.length,
                      ),
                    ),
                  ),
                );
              }),
              const SliverToBoxAdapter(
                child: ReklamaVideoWidget(),
              )
            ],
          );
        });
  }
}

class ReklamaVideoWidget extends StatelessWidget {
  const ReklamaVideoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 600,
      color: const Color.fromARGB(255, 239, 248, 242),
      child: const Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              'Biziň Bakjamyz',
              style: TextStyle(
                fontSize: 42,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconCommentWidget(
                icon: Icons.autorenew_outlined,
                text: 'Ygtybarly we Gaýtadan Ulanylýan',
              ),
              IconCommentWidget(
                icon: Icons.assignment_outlined,
                text: 'Amatly Bahadan',
              ),
              IconCommentWidget(
                icon: Icons.yard_outlined,
                text: 'Owadan Görnüşli',
              )
            ],
          ),
          // VideoReklamWidget()
        ],
      ),
    );
  }
}

class VideoReklamWidget extends StatefulWidget {
  const VideoReklamWidget({
    super.key,
  });

  @override
  State<VideoReklamWidget> createState() => _VideoReklamWidgetState();
}

class _VideoReklamWidgetState extends State<VideoReklamWidget> {
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.asset('plantReklam.mp4'),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: FlickVideoPlayer(flickManager: flickManager),
      ),
    );
  }
}

class IconCommentWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  const IconCommentWidget({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 50.0,
        ),
        Container(
          width: 300,
          child: Text(
            textAlign: TextAlign.center,
            maxLines: 2,
            text,
            style: const TextStyle(
              fontSize: 30,
            ),
          ),
        ),
      ],
    );
  }
}

// class BestsellersWidget extends StatefulWidget {
//   @override
//   State<BestsellersWidget> createState() => _BestsellersWidgetState();
// }

// class _BestsellersWidgetState extends State<BestsellersWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       color: Colors.white,
//       padding: EdgeInsets.all(10),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 50),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Image.asset(
//                   'icon.png',
//                   height: 42,
//                   width: 42,
//                 ),
//                 SizedBox(width: 20),
//                 Text(
//                   'Bestsellers',
//                   style: TextStyle(
//                     fontSize: 42,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             FutureBuilder(
//               future: getProducts(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return const Center(
//                     child: Text('error'),
//                   );
//                 }
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//                 if (snapshot.hasData) {
//                   return GridView.builder(
//                     shrinkWrap: true,
//                     gridDelegate:
//                         const SliverGridDelegateWithMaxCrossAxisExtent(
//                       maxCrossAxisExtent: 300.0,
//                     ),
//                     itemBuilder: (context, index) {
//                       final product = snapshot.data![index];
//                       return SizedBox(
//                         height: 250.0,
//                         child: Column(
//                           children: [
//                             Expanded(child: Image.network(product.image ?? '')),
//                             Text(product.category ?? ''),
//                             Text(product.title!),
//                             Text('${product.price} TMT'),
//                             Row(
//                               children: [
//                                 IconButton(
//                                     onPressed: () {},
//                                     icon: const Icon(Icons.favorite)),
//                                 ElevatedButton(
//                                     onPressed: () {},
//                                     child: const Icon(Icons.favorite)),
//                               ],
//                             )
//                           ],
//                         ),
//                       );
//                     },
//                     itemCount: snapshot.data?.length,
//                   );
//                 }
//                 return const SizedBox();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class BestsellerModel {
  final int? id;
  final String? title;
  final double? price;
  final String? description;
  final String? category;
  final String? image;

  BestsellerModel({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
  });

  factory BestsellerModel.fromJson(Map<String, dynamic> json) =>
      BestsellerModel(
        id: json["id"],
        title: json["title"],
        price: json["price"]?.toDouble(),
        description: json["description"],
        category: json["category"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "description": description,
        "category": category,
        "image": image,
      };
}

class ProductWidget extends StatefulWidget {
  final String title;
  final String image;
  final double price;

  const ProductWidget({
    super.key,
    required this.title,
    required this.image,
    required this.price,
  });

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  bool isButtonHovered = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image.network(
            widget.image,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          width: double.infinity,
          height: 85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isButtonHovered)
                const Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          '${widget.price.toStringAsFixed(2)}  TMT',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 15.0),
        MouseRegion(
          onEnter: (_) {
            setState(() {
              isButtonHovered = true;
            });
          },
          onExit: (_) {
            setState(() {
              isButtonHovered = false;
            });
          },
          child: TextButton(
            onPressed: () {
              // Add your code here to handle the button press
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 20, 146, 83),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
            child: const SizedBox(
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  SizedBox(width: 12.0),
                  Text(
                    'View Product',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomCarouselSliderWidget extends StatefulWidget {
  CustomCarouselSliderWidget({super.key});

  @override
  State<CustomCarouselSliderWidget> createState() =>
      _CustomCarouselSliderWidgetState();
}

class _CustomCarouselSliderWidgetState
    extends State<CustomCarouselSliderWidget> {
  int activeIndex = 0;

  final itemImages = [
    '1.jpg',
    '2.jpg',
    '5.jpg',
    '3.jpg',
    '4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
              height: 800,
              autoPlay: true,
              viewportFraction: 1,
              autoPlayInterval: const Duration(seconds: 7),
              autoPlayAnimationDuration: const Duration(milliseconds: 1200),
              enlargeCenterPage: true,
              onPageChanged: (index, reason) =>
                  setState(() => activeIndex = index),
            ),
            itemCount: itemImages.length,
            itemBuilder: (context, index, realIndex) {
              final itemImage = itemImages[index];
              return buildImage(itemImage, index);
            },
          ),
          const SizedBox(height: 32),
          buildIndicator(),
        ],
      ),
    );
  }

  Widget buildImage(String itemImage, int index) => Container(
        color: Colors.grey,
        child: Image.asset(
          itemImage,
          fit: BoxFit.fill,
          width: double.infinity,
        ),
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: itemImages.length,
        effect: const ExpandingDotsEffect(
          dotWidth: 15,
          dotHeight: 15,
          activeDotColor: Color.fromARGB(255, 20, 146, 83),
        ),
      );
}

class _AppbarRow3 extends StatelessWidget {
  const _AppbarRow3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        OutlinedTextFieldExample(),
        UserIconButton(),
      ],
    );
  }
}

class _AppbarRow2 extends StatelessWidget {
  final List<String> categories;
  const _AppbarRow2({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Category(
          categories: categories,
        ),
        const SizedBox(width: 40),
        CustomTextButton(
          text: "Sowgatlar",
          onPressed: () {},
        ),
        const SizedBox(width: 40),
        CustomTextButton(
          text: "Sargytlar",
          onPressed: () {},
        ),
      ],
    );
  }
}

class _AppbarRow1 extends StatelessWidget {
  const _AppbarRow1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'flower2.png',
      width: 70,
      height: 55,
      fit: BoxFit.cover,
    );
  }
}

class UserIconButton extends StatefulWidget {
  const UserIconButton({super.key});

  @override
  _UserIconButtonState createState() => _UserIconButtonState();
}

class _UserIconButtonState extends State<UserIconButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(
        Icons.person_outline,
        color: Color.fromARGB(255, 20, 146, 83), // Change the hover color here
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      padding: const EdgeInsets.all(12.0),
      iconSize: 28.0,
      visualDensity: VisualDensity.compact,
      alignment: Alignment.center,
      color: Colors.transparent, // Set the background color to transparent
      hoverColor: Colors.transparent,
      splashRadius: 24.0,
      focusColor: Colors.transparent,
      enableFeedback: true,
      mouseCursor: SystemMouseCursors.click,
    );
  }
}

class OutlinedTextFieldExample extends StatelessWidget {
  const OutlinedTextFieldExample({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 35,
      child: TextField(
        cursorColor: Colors.grey[600],
        style: TextStyle(
          color: Colors.grey[600],
        ),
        decoration: InputDecoration(
            prefixIconColor: const Color.fromARGB(255, 20, 146, 83),
            prefixIcon: const Icon(Icons.search),
            labelStyle: const TextStyle(fontSize: 15.0),
            labelText: 'Gözleg',
            floatingLabelStyle:
                const TextStyle(color: Color.fromARGB(255, 20, 146, 83)),
            hintText: 'Söz giriz...',
            isDense: true,
            contentPadding: const EdgeInsets.all(8),
            hintStyle: const TextStyle(fontSize: 15.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: Colors.amber),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 20, 146, 83)),
              borderRadius: BorderRadius.circular(15.0),
            )),
      ),
    );
  }
}

class Category extends StatelessWidget {
  final List<String> categories;
  const Category({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextButton(
      text: 'Kategoriýalar',
      onPressed: () {
        showPopover(
          context: context,
          bodyBuilder: (context) => ListItems(
            categories: categories,
          ),
          onPop: () => print('Popover was popped!'),
          direction: PopoverDirection.bottom,
          width: 200,
          height: 400,
          arrowHeight: 15,
          arrowWidth: 30,
        );
      },
    );
  }
}

class CustomTextButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  _CustomTextButtonState createState() => _CustomTextButtonState();
}

class _CustomTextButtonState extends State<CustomTextButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: widget.onPressed,
      onHover: (value) {
        setState(() {
          _isHovered = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              style: BorderStyle.solid,
              color: _isHovered
                  ? const Color.fromARGB(255, 87, 126, 125)
                  : Colors.transparent,
              width: 2.0,
            ),
          ),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: _isHovered
                ? const Color.fromARGB(255, 87, 140, 125)
                : const Color.fromARGB(255, 20, 146, 83),
          ),
        ),
      ),
    );
  }
}

class ListItems extends StatelessWidget {
  final List<String> categories;
  const ListItems({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: categories.map((e) {
          return InkWell(
            onTap: () {
              Navigator.of(context)
                ..pop()
                ..push(
                  MaterialPageRoute<SecondRoute>(
                    builder: (context) => SecondRoute(
                      category: e,
                    ),
                  ),
                );
            },
            child: Container(
              height: 50,
              color: Colors.amber[100],
              child: Center(child: Text(e)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SecondRoute extends StatefulWidget {
  final String category;
  const SecondRoute({super.key, required this.category});

  @override
  State<SecondRoute> createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  Future<List<BestsellerModel>> getProducts() async {
    final uri = Uri.parse(
        'https://fakestoreapi.com/products/categories/${widget.category}');
    final list = <BestsellerModel>[];

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final rawList = responseBody as Iterable?; // [] | null
        for (var element in rawList ?? []) {
          final product = BestsellerModel.fromJson(element);
          list.add(product);
        }
        log(rawList.toString());
      } else {
        throw Exception('status code is not equal to 200');
      }
    } catch (e) {
      log(e.toString());
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.category);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

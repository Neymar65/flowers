import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/product_model.dart';
import 'package:flutter_application_1/screens/product_body.dart';
import 'package:popover/popover.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  final String category;
  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Future<List<ProductModel>> getProducts() async {
    final uri = Uri.parse('https://fakestoreapi.com/products');
    final list = <ProductModel>[];

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final rawList = responseBody as Iterable?; // [] | null
        for (var element in rawList ?? []) {
          final product = ProductModel.fromJson(element);
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
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
            final products = snapshot.data?[0] as List<ProductModel>;
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
                  child: Container(
                    width: double.infinity,
                    height: 600,
                    child: Image.asset(
                      '3.jpg',
                      fit: BoxFit.fill,
                      width: double.infinity,
                    ),
                  ),
                ),
                SliverLayoutBuilder(builder: (context, constraints) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 1250.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'icon.png',
                                    height: 42,
                                    width: 42,
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    widget.category,
                                    style: TextStyle(
                                      fontSize: 42,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),
                              const Text(
                                'Plants make for the best house companions, suitable for all your moods and every aesthetic. Ugaoo brings you the widest variety of plants to choose from so you can buy plants online from the comfort of your home!',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 100.0),
                              GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 300.0,
                                    mainAxisExtent: 400.0,
                                    mainAxisSpacing: 35.0,
                                    crossAxisSpacing: 25.0,
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
                                        ontap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ProductBody(
                                                id: product.id,
                                              ),
                                            ),
                                          );
                                        },
                                        title: product.title ?? '',
                                        image: product.image ?? '',
                                        price: product.price ?? 0.0,
                                      ),
                                    );
                                  },
                                  itemCount:
                                      // ((products.length) > 8) ? 8 : products.length,
                                      products.length),
                            ],
                          ),
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
          }),
    );
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
      height: 270,
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
        ],
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

class ProductWidget extends StatefulWidget {
  final String title;
  final String image;
  final double price;
  final VoidCallback ontap;

  const ProductWidget({
    super.key,
    required this.title,
    required this.image,
    required this.price,
    required this.ontap,
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
            onPressed: widget.ontap,
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
                    'Harydy Görmek',
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
  Future<List<ProductModel>> getProducts() async {
    final uri = Uri.parse(
        'https://fakestoreapi.com/products/categories/${widget.category}');
    final list = <ProductModel>[];

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final rawList = responseBody as Iterable?; // [] | null
        for (var element in rawList ?? []) {
          final product = ProductModel.fromJson(element);
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

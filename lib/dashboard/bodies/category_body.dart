import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryBody extends StatelessWidget {
  const CategoryBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(
          floating: true,
          toolbarHeight: 80.0,
          expandedHeight: 80.0,
          backgroundColor: Color.fromARGB(255, 255, 246, 244),
          flexibleSpace: FlexibleSpaceBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _AppbarRow1(),
                _AppbarRow2(),
                _AppbarRow3(),
              ],
            ),
          ),
          centerTitle: true,
        ),
        SliverToBoxAdapter(
            child: SizedBox(
          width: double.infinity,
          height: 600,
          child: Image.asset(
            '3.jpg',
            fit: BoxFit.fill,
            width: double.infinity,
          ),
        )),
        SliverToBoxAdapter(
          child: AllProducts(),
        ),
        SliverToBoxAdapter(
          child: ReklamaWidget(),
        )
      ],
    );
  }
}

class ReklamaWidget extends StatelessWidget {
  const ReklamaWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 600,
      color: Color.fromARGB(255, 239, 248, 242),
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

class AllProducts extends StatefulWidget {
  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  Future<List<ProductModel>> getProducts() async {
    final uri = Uri.parse('https://fakestoreapi.com/products');
    final list = <ProductModel>[];

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body) as Map?;
        final rawList = responseBody?['products'] as Iterable?; // [] | null
        for (var element in rawList ?? []) {
          final product = ProductModel.fromJson(element);
          list.add(product);
        }
        print(rawList);
      } else {
        throw Exception('status code is not equal to 200');
      }
    } catch (e) {
      print(e);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'icon.png',
                  height: 42,
                  width: 42,
                ),
                SizedBox(width: 20),
                Text(
                  'Ähli Harytlar',
                  style: TextStyle(
                    fontSize: 42,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            FutureBuilder(
              future: getProducts(),
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
                // s
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProductModel {
  final int? id;
  final String? title;
  final double? price;
  final String? description;
  final String? category;
  final String? image;

  ProductModel({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
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

  ProductWidget({
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
    return SizedBox(
      height: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.image,
            width: double.infinity,
            height: 400,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 16.0),
          Container(
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
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isButtonHovered)
                  Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                  ),
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            '${widget.price.toStringAsFixed(2)}  TMT',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 15.0),
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
                  Color.fromARGB(255, 20, 146, 83),
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
      ),
    );
  }
}

class _AppbarRow3 extends StatelessWidget {
  const _AppbarRow3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedTextFieldExample(),
        UserIconButton(),
      ],
    );
  }
}

class _AppbarRow2 extends StatelessWidget {
  const _AppbarRow2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Category(),
        SizedBox(width: 40),
        CustomTextButton(
          text: "Sowgatlar",
          onPressed: () {},
        ),
        SizedBox(width: 40),
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
            prefixIcon: Icon(Icons.search),
            labelStyle: TextStyle(fontSize: 15.0),
            labelText: 'Gözleg',
            floatingLabelStyle:
                TextStyle(color: const Color.fromARGB(255, 20, 146, 83)),
            hintText: 'Söz giriz...',
            isDense: true,
            contentPadding: EdgeInsets.all(8),
            hintStyle: TextStyle(fontSize: 15.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Colors.amber),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 20, 146, 83)),
              borderRadius: BorderRadius.circular(15.0),
            )),
      ),
    );
  }
}

class Category extends StatelessWidget {
  const Category({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextButton(
      text: 'Kategoriýalar',
      onPressed: () {
        showPopover(
          context: context,
          bodyBuilder: (context) => const ListItems(),
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
  const ListItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context)
                ..pop()
                ..push(
                  MaterialPageRoute<SecondRoute>(
                    builder: (context) => SecondRoute(),
                  ),
                );
            },
            child: Container(
              height: 50,
              color: Colors.amber[100],
              child: const Center(child: Text('Entry A')),
            ),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[200],
            child: const Center(child: Text('Entry B')),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[300],
            child: const Center(child: Text('Entry C')),
          ),
        ],
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
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

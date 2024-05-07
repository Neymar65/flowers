import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/category_screen.dart';
import 'package:popover/popover.dart';

class CustomHeader extends StatefulWidget {
  final List<String> categories;
  const CustomHeader({super.key, required this.categories});

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
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
              categories: widget.categories,
            ),
            const _AppbarRow3(),
          ],
        ),
      ),
      centerTitle: true,
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
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context)
                    ..pop()
                    ..push(
                      MaterialPageRoute<CategoryScreen>(
                        builder: (context) => CategoryScreen(
                          category: e,
                        ),
                      ),
                    );
                },
                child: Container(
                  height: 50,
                  color: const Color.fromARGB(255, 255, 246, 244),
                  child: Center(
                      child: Text(
                    e,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 20, 146, 83),
                      fontSize: 18.0,
                    ),
                  )),
                ),
              ),
              Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }
}

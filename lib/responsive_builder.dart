import 'package:flutter/material.dart';

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    Key key,
    @required this.smallChild,
    this.largeChild,
  }) : super(key: key);
  final Widget smallChild;
  final Widget largeChild;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final isSmallDevice = constraints.maxWidth <= 800;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: (!isSmallDevice && largeChild != null)
              ? Builder(
                  key: ValueKey<String>("large-child-${largeChild.hashCode}"),
                  builder: (BuildContext context) => largeChild,
                )
              : Builder(
                  key: ValueKey<String>("small-child-${smallChild.hashCode}"),
                  builder: (BuildContext context) => smallChild,
                ),
        );
      },
    );
  }
}

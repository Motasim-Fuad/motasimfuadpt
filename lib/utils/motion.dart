import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Motion {
  static const Duration fast = Duration(milliseconds: 220);
  static const Duration page = Duration(milliseconds: 420);
  static const Duration reveal = Duration(milliseconds: 720);
  static const Curve ease = Curves.easeOutCubic;
}

enum MotionSlide { up, left, right }

class MotionHost extends InheritedWidget {
  final ScrollController controller;

  const MotionHost({
    super.key,
    required this.controller,
    required super.child,
  });

  static MotionHost? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MotionHost>();
  }

  @override
  bool updateShouldNotify(MotionHost oldWidget) =>
      controller != oldWidget.controller;
}

class MotionReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final MotionSlide slide;
  final Duration? duration;
  final VoidCallback? onVisible;

  const MotionReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.slide = MotionSlide.up,
    this.duration,
    this.onVisible,
  });

  @override
  State<MotionReveal> createState() => _MotionRevealState();
}

class _MotionRevealState extends State<MotionReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _offset;
  ScrollController? _scroll;
  bool _played = false;
  int _layoutTries = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? Motion.reveal,
    );
    final curve = CurvedAnimation(parent: _controller, curve: Motion.ease);
    _fade = curve;
    _offset = Tween<Offset>(begin: _begin(), end: Offset.zero).animate(curve);
  }

  Offset _begin() {
    switch (widget.slide) {
      case MotionSlide.up:
        return const Offset(0, 0.07);
      case MotionSlide.left:
        return const Offset(-0.045, 0);
      case MotionSlide.right:
        return const Offset(0.055, 0);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = MotionHost.maybeOf(context)?.controller;
    if (next != _scroll) {
      _scroll?.removeListener(_check);
      _scroll = next;
      _scroll?.addListener(_check);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (!mounted || _played) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _played = true;
      _controller.value = 1;
      widget.onVisible?.call();
      return;
    }
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) {
      if (_layoutTries++ < 16) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _check());
      }
      return;
    }
    final origin = box.localToGlobal(Offset.zero);
    final viewH = MediaQuery.sizeOf(context).height;
    final top = origin.dy;
    final bottom = top + box.size.height;
    final inView = top < viewH * 0.92 && bottom > 48;
    if (!inView) return;
    _played = true;
    widget.onVisible?.call();
    Future<void>.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _scroll?.removeListener(_check);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }
}

class MotionLine extends StatefulWidget {
  final Color color;
  final double height;
  final double? width;
  final Duration delay;

  const MotionLine({
    super.key,
    required this.color,
    this.height = 1,
    this.width,
    this.delay = Duration.zero,
  });

  @override
  State<MotionLine> createState() => _MotionLineState();
}

class _MotionLineState extends State<MotionLine> {
  bool _grow = false;

  @override
  Widget build(BuildContext context) {
    return MotionReveal(
      delay: widget.delay,
      onVisible: () {
        if (mounted) setState(() => _grow = true);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final end = widget.width ?? constraints.maxWidth;
          return Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Motion.ease,
              width: _grow ? end : 0,
              height: widget.height,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class MotionParallax extends StatefulWidget {
  final Widget child;
  final double factor;

  const MotionParallax({super.key, required this.child, this.factor = 0.12});

  @override
  State<MotionParallax> createState() => _MotionParallaxState();
}

class _MotionParallaxState extends State<MotionParallax> {
  ScrollController? _scroll;
  double _dy = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = MotionHost.maybeOf(context)?.controller;
    if (next != _scroll) {
      _scroll?.removeListener(_onScroll);
      _scroll = next;
      _scroll?.addListener(_onScroll);
      _onScroll();
    }
  }

  void _onScroll() {
    if (!mounted || _scroll == null || !_scroll!.hasClients) return;
    final next = -_scroll!.offset * widget.factor;
    if ((next - _dy).abs() < 0.4) return;
    setState(() => _dy = next);
  }

  @override
  void dispose() {
    _scroll?.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return Transform.translate(
      offset: Offset(0, _dy.clamp(-48, 48)),
      child: widget.child,
    );
  }
}

class MotionFadeOnScroll extends StatefulWidget {
  final Widget child;
  final double range;

  const MotionFadeOnScroll({super.key, required this.child, this.range = 180});

  @override
  State<MotionFadeOnScroll> createState() => _MotionFadeOnScrollState();
}

class _MotionFadeOnScrollState extends State<MotionFadeOnScroll> {
  ScrollController? _scroll;
  double _opacity = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = MotionHost.maybeOf(context)?.controller;
    if (next != _scroll) {
      _scroll?.removeListener(_onScroll);
      _scroll = next;
      _scroll?.addListener(_onScroll);
      _onScroll();
    }
  }

  void _onScroll() {
    if (!mounted || _scroll == null || !_scroll!.hasClients) return;
    final next = (1 - (_scroll!.offset / widget.range)).clamp(0.0, 1.0);
    if ((next - _opacity).abs() < 0.02) return;
    setState(() => _opacity = next);
  }

  @override
  void dispose() {
    _scroll?.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: _opacity, child: widget.child);
  }
}

class MotionPulseDot extends StatefulWidget {
  final Color color;
  const MotionPulseDot({super.key, this.color = const Color(0xFF2F473D)});

  @override
  State<MotionPulseDot> createState() => _MotionPulseDotState();
}

class _MotionPulseDotState extends State<MotionPulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    if (!(WidgetsBinding.instance.platformDispatcher.accessibilityFeatures.disableAnimations)) {
      _c.repeat(reverse: true);
    } else {
      _c.value = 1;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      );
    }
    return SizedBox(
      width: 14,
      height: 14,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = CurvedAnimation(parent: _c, curve: Curves.easeInOut).value;
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 7 + (t * 6),
                height: 7 + (t * 6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: 0.28 * (1 - t)),
                ),
              ),
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MotionHover extends StatefulWidget {
  final Widget child;
  final double lift;

  const MotionHover({super.key, required this.child, this.lift = 5});

  @override
  State<MotionHover> createState() => _MotionHoverState();
}

class _MotionHoverState extends State<MotionHover> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: Motion.fast,
        curve: Motion.ease,
        transformAlignment: Alignment.center,
        transform: Matrix4.translationValues(0, _hover ? -widget.lift : 0, 0),
        child: widget.child,
      ),
    );
  }
}

class MotionCount extends StatelessWidget {
  final String value;
  final TextStyle? style;
  final bool play;

  const MotionCount({
    super.key,
    required this.value,
    required this.play,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final match = RegExp(r'^(\d+)(.*)$').firstMatch(value);
    if (match == null) return Text(value, style: style);
    if (MediaQuery.disableAnimationsOf(context)) {
      return Text(value, style: style);
    }
    final suffix = match.group(2) ?? '';
    if (!play) return Text('0$suffix', style: style);
    final end = int.parse(match.group(1)!);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: end.toDouble()),
      duration: const Duration(milliseconds: 1100),
      curve: Motion.ease,
      builder: (context, n, _) {
        return Text('${n.round()}$suffix', style: style);
      },
    );
  }
}

class AppPageTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final fade = CurvedAnimation(parent: animation, curve: Motion.ease);
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.018),
          end: Offset.zero,
        ).animate(fade),
        child: child,
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

///TODO make it run the algorithm on Isolates so that it does not become unresponsive.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Happy Birthday',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SafeArea(
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int maxIterations = 40;
  double scaleFactor = 1;
  double fakeZoomFactor = 1;

  double offsetY = 0;
  double offsetX = 0;

  bool displayAnimation = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FloatingActionButton(
                backgroundColor: Colors.amber.shade700,
                onPressed: () {
                  setState(() {
                    fakeZoomFactor += 0.5;
                  });
                },
                child: const Icon(
                  Icons.zoom_in,
                  color: Colors.white,
                ),
              ),
              const SizedBox.square(
                dimension: 16,
              ),
              FloatingActionButton(
                backgroundColor: Colors.red.shade700,
                onPressed: () {
                  setState(() {
                    scaleFactor += 0.5;
                  });
                },
                child: const Icon(
                  Icons.zoom_in,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox.square(
            dimension: 16,
          ),
          FloatingActionButton(
            backgroundColor: Colors.amber.shade700,
            onPressed: () {
              setState(() {
                maxIterations += 40;
              });
            },
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            Transform.scale(
              scale: fakeZoomFactor,
              child: Transform.translate(
                offset: Offset(offsetX, offsetY),
                child: RepaintBoundary(
                  child: CustomPaintWithController(
                    maxIterations: maxIterations,
                    scaleFactor: scaleFactor,
                  ),
                ),
              ),
            ),
            if (displayAnimation) const HappyBirthdayText(),
            Theme(
              data: ThemeData(
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              child: Column(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      setState(() {
                        offsetY += 100;
                      });
                    },
                    icon: const Icon(Icons.arrow_upward),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          setState(() {
                            offsetX += 100;
                          });
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(
                        width: 36,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            offsetX -= 100;
                          });
                        },
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        offsetY -= 100;
                      });
                    },
                    icon: const Icon(Icons.arrow_downward),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    displayAnimation = !displayAnimation;
                  });
                },
                icon: Icon(
                  displayAnimation
                      ? Icons.play_disabled_rounded
                      : Icons.play_arrow_rounded,
                  color: Colors.amber.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPaintWithController extends StatefulWidget {
  const CustomPaintWithController({
    required this.maxIterations,
    required this.scaleFactor,
    super.key,
  });

  final int maxIterations;
  final double scaleFactor;

  @override
  State<CustomPaintWithController> createState() =>
      _CustomPaintWithControllerState();
}

class _CustomPaintWithControllerState extends State<CustomPaintWithController> {
  bool willChange = false;

  @override
  void didUpdateWidget(covariant CustomPaintWithController oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scaleFactor != widget.scaleFactor ||
        oldWidget.maxIterations != widget.maxIterations) {
      willChange = true;
    } else {
      willChange = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      isComplex: true,
      painter: FractalView(
        willChange: willChange,
        maxIterations: widget.maxIterations,
        width: MediaQuery.sizeOf(context).width * widget.scaleFactor,
        height: MediaQuery.sizeOf(context).height * widget.scaleFactor,
      ),
    );
  }
}

class HappyBirthdayText extends StatefulWidget {
  const HappyBirthdayText({
    super.key,
  });

  @override
  State<HappyBirthdayText> createState() => _HappyBirthdayTextState();
}

class _HappyBirthdayTextState extends State<HappyBirthdayText>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  late final Tween<double> generalTween;
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    generalTween = Tween<double>(begin: 2.4, end: 4);
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )
      ..forward()
      ..addListener(() {
        setState(() {
          if (controller.isCompleted) {
            controller.reverse();
          } else if (controller.isDismissed) {
            controller.forward();
          }
        });
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: generalTween.animate(controller),
        child: Opacity(
          opacity: generalTween.evaluate(controller) / 4,
          child: const Text(
            "Happy Birthday!",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class FractalView extends CustomPainter {
  final double _width;
  final double _height;
  final MathSet realSet = MathSet(start: -2, end: 1);
  final MathSet imaginarySet = MathSet(start: -1, end: 1);
  final int maxIterations;
  final bool willChange;

  CoordinatesComplex complexCoordinates =
      CoordinatesComplex(real: 0, imaginary: 0);

  late final List<Color> colors = List<Color>.generate(
    16,
    (int index) => index == 0
        ? Colors.black
        : Color(
            int.parse(
              // ignore: lines_longer_than_80_chars
              "FF40${getRandomHueValue(additionalValue: 20)}${getRandomHueValue()}",
              radix: 16,
            ),
          ),
  );

  @override
  void paint(Canvas canvas, Size size) {
    for (double i = 0; i < _width; i++) {
      for (double j = 0; j < _height; j++) {
        complexCoordinates.real =
            realSet.start + (i / _width) * (realSet.end - realSet.start);
        complexCoordinates.imaginary = imaginarySet.start +
            (j / _height) * (imaginarySet.end - imaginarySet.start);

        final MandelbrotResult mandelbrotResult = mandelbrot(
          complexCoordinates: complexCoordinates,
          maxIteration: maxIterations,
        );

        final Paint currentPaint = Paint()
          ..color = mandelbrotResult.isMandelbrotSet
              ? Colors.black
              : colors[(mandelbrotResult.value % colors.length - 1) + 1];

        currentPaint.style = PaintingStyle.fill;
        // ..style.
        canvas.drawRect(
          Rect.fromLTWH(i, j, 1, 1),
          currentPaint,
        );
      }
    }
  }

  FractalView({
    required double width,
    required double height,
    required this.willChange,
    required this.maxIterations,
  })  : _height = height,
        _width = width;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return willChange;
  }

  String getRandomHueValue({int additionalValue = 200}) =>
      (Random.secure().nextInt(56) + min<int>(200, additionalValue))
          .toRadixString(16)
          .toUpperCase();
}

// draw()

class MathSet {
  MathSet({
    required this.start,
    required this.end,
  });

  final double start;
  final double end;
}

class CoordinatesComplex {
  CoordinatesComplex({
    required this.real,
    required this.imaginary,
  });

  double real;
  double imaginary;
}

MandelbrotResult mandelbrot({
  required CoordinatesComplex complexCoordinates,
  required int maxIteration,
}) {
  CoordinatesComplex z = CoordinatesComplex(real: 0, imaginary: 0);
  double d = 0;
  int value = 0;

  do {
    final CoordinatesComplex p = CoordinatesComplex(
      real: (pow(z.real, 2) - pow(z.imaginary, 2)).toDouble(),
      imaginary: 2 * z.real * z.imaginary,
    );
    z = CoordinatesComplex(
      real: p.real + complexCoordinates.real,
      imaginary: p.imaginary + complexCoordinates.imaginary,
    );
    d = sqrt(pow(z.real, 2) + pow(z.imaginary, 2));
    value += 1;
  } while (d <= 2 && value < maxIteration);
  return MandelbrotResult(value: value, isMandelbrotSet: d <= 2);
}

class MandelbrotResult {
  int value;
  bool isMandelbrotSet;

  MandelbrotResult({
    required this.value,
    required this.isMandelbrotSet,
  });
}

class Complex {
  final double real;
  final double imaginary;

  Complex(this.real, this.imaginary);
}

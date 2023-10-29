import 'dart:async';
import 'dart:math';

import 'src/material/icon.dart';
import 'src/material/icons.dart';
import 'statefulhtml.dart';

void main() {
  runApp(
    MetaStorage.single(
      initialMeta: {
        Metadata.charset(charset: 'utf-8'),
        Metadata.meta(name: 'viewport', content: 'width=device-width'),
      },
      child: TestStateless(),
    ),
  );
}

Color generateRandomColor() {
  Random random = Random();
  int r = random.nextInt(255);
  int g = random.nextInt(255);
  int b = random.nextInt(255);
  return Color.rgb(r, g, b);
}

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TestState();
  }
}

List<String> randomTags = ['button', 'input', 'select'];
List<IconData> randomIcons = [
  Icons.account_box,
  Icons.account_circle,
  Icons.home,
  Icons.alarm
];

String randomTag() {
  Random random = Random();
  return randomTags[random.nextInt(randomTags.length)];
}

IconData randomIcon() {
  Random random = Random();
  return randomIcons[random.nextInt(randomIcons.length)];
}

class TestState extends State<TestWidget> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  List<Widget> buildChildren(BuildContext context) {
    return [
      Frame.fillParent(
          layout: Layout(
            direction: Direction.horizontal,
            alignment: Alignment.center,
          ),
          fills: [
            ColorFill(
              generateRandomColor(),
            ),
          ],
          children: [
            Frame(
              height: FrameSize.hugContent,
              width: FrameSize.fillParent,
              fills: [
                ColorFill(
                  generateRandomColor(),
                ),
              ],
              layout: Layout(
                padding: Insets.symmetric(vertical: 12, horizontal: 30),
              ),
              children: [
                DOMElement(tag: randomTag(), style: {
                  'background-color': generateRandomColor().css,
                  'color': generateRandomColor().css,
                  'width': '180px',
                  'height': '80px',
                  'position': 'absolute',
                  'top': '0',
                  'left': '0',
                  'z-index': '999',
                }, children: [
                  Text('Hello!!!'),
                ]),
                Frame(
                  x: 20,
                  y: 30,
                  width: FrameSize.fixed(Unit.px(80)),
                  height: FrameSize.fixed(Unit.px(50)),
                  fills: [
                    ColorFill(
                      generateRandomColor(),
                    ),
                  ],
                ),
                Frame(
                    height: FrameSize.fixed(Unit.px(100)),
                    width: FrameSize.fillParent,
                    fills: [
                      ColorFill(
                        generateRandomColor(),
                      ),
                    ],
                    children: [
                      Frame(
                        x: 30,
                        y: 30,
                        width: FrameSize.fixed(Unit.px(40)),
                        height: FrameSize.fixed(Unit.px(20)),
                        fills: [
                          ColorFill(
                            generateRandomColor(),
                          ),
                        ],
                      )
                    ]),
              ],
            ),
            Frame(
                height: FrameSize.fixed(Unit.px(200)),
                width: FrameSize.fillParent,
                fills: [
                  ColorFill(
                    generateRandomColor(),
                  ),
                ],
                children: [
                  InheritedStyle.single(
                    styleSheet: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: generateRandomColor(),
                    ),
                    child: InheritedStyle.single(
                      styleSheet: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      child: Text.styled(
                        'Hello World',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ]),
            Frame(
              height: FrameSize.fillParent,
              width: FrameSize.fixed(Unit.px(400)),
              fills: [
                ColorFill(
                  generateRandomColor(),
                ),
              ],
            ),
            Frame(
                x: 30,
                y: 30,
                width: FrameSize.hugContent,
                height: FrameSize.hugContent,
                fills: [
                  ColorFill(
                    generateRandomColor(),
                  ),
                ],
                children: [
                  InheritedStyle(
                    styleSheet: IconStyle(
                      weight: IconWeight.w600,
                      type: IconType.rounded,
                      color: generateRandomColor(),
                    ),
                    children: [
                      Icon(randomIcon(),
                          style: IconStyle(
                            filled: false,
                            type: IconType.outlined,
                            size: 60,
                          )),
                    ],
                  ),
                ]),
          ]),
    ];
  }
}

class TestStateless extends StatelessWidget {
  const TestStateless({Key? key}) : super(key: key);

  @override
  List<Widget> build(BuildContext context) {
    return [TestWidget()];
  }
}

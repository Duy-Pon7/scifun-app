import 'package:flutter/material.dart';
import 'package:chiclet/chiclet.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({super.key});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     ChicletOutlinedAnimatedButton(
              //       onPressed: () {},
              //       height: 64,
              //       borderRadius: 0,
              //       child: const Icon(Icons.keyboard_return),
              //     ),
              //     ChicletAnimatedButton(
              //       onPressed: () {},
              //       height: 64,
              //       borderRadius: 0,
              //       child: const Icon(Icons.keyboard_return),
              //     ),
              //     ChicletAnimatedButton(
              //       onPressed: () {},
              //       height: 64,
              //       width: 140,
              //       borderRadius: 0,
              //       child: const Icon(Icons.keyboard_return),
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChicletOutlinedAnimatedButton(
                    onPressed: () {},
                    height: 64,
                    child: const Icon(Icons.keyboard_return_rounded),
                  ),
                  ChicletAnimatedButton(
                    onPressed: () {},
                    height: 64,
                    child: const Icon(Icons.keyboard_return_rounded),
                  ),
                  ChicletAnimatedButton(
                    onPressed: () {},
                    height: 64,
                    width: 140,
                    child: const Icon(Icons.keyboard_return_rounded),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChicletOutlinedAnimatedButton(
                    onPressed: () {},
                    height: 64,
                    buttonType: ChicletButtonTypes.circle,
                    child: const Icon(Icons.keyboard_return_rounded),
                  ),
                  ChicletAnimatedButton(
                    onPressed: () {},
                    height: 64,
                    buttonType: ChicletButtonTypes.circle,
                    child: const Icon(Icons.keyboard_return_rounded),
                  ),
                  ChicletAnimatedButton(
                    onPressed: () {},
                    width: 140,
                    height: 64,
                    borderRadius: 64,
                    buttonType: ChicletButtonTypes.roundedRectangle,
                    child: const Icon(Icons.keyboard_return_rounded),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChicletOutlinedAnimatedButton(
                    onPressed: () {},
                    height: 50,
                    width: 65,
                    buttonType: ChicletButtonTypes.oval,
                    child: const Icon(Icons.keyboard_return_rounded),
                  ),
                  ChicletAnimatedButton(
                    onPressed: () {},
                    height: 50,
                    width: 65,
                    buttonType: ChicletButtonTypes.oval,
                    child: const Icon(Icons.keyboard_return_rounded),
                  ),
                  ChicletAnimatedButton(
                    onPressed: () {},
                    height: 50,
                    width: 140,
                    buttonType: ChicletButtonTypes.oval,
                    child: const Icon(Icons.keyboard_return_rounded),
                  ),
                ],
              ),
              ChicletSegmentedButton(
                height: 66,
                buttonHeight: 6,
                padding: EdgeInsets.zero,
                children: [
                  ChicletButtonSegment(
                    onPressed: () {},
                    child: const Icon(Icons.shuffle_rounded),
                  ),
                  ChicletButtonSegment(
                    onPressed: () {},
                    child: const Icon(Icons.skip_previous_rounded),
                  ),
                  ChicletButtonSegment(
                    onPressed: () {},
                    child: const Icon(Icons.play_arrow),
                  ),
                  ChicletButtonSegment(
                    onPressed: () {},
                    child: const Icon(Icons.skip_next_rounded),
                  ),
                  ChicletButtonSegment(
                    onPressed: () {},
                    child: const Icon(Icons.repeat_rounded),
                  ),
                ],
              ),
              ChicletSegmentedButton(
                width: 330,
                height: 66,
                buttonHeight: 6,
                children: [
                  Expanded(
                    child: ChicletButtonSegment(
                      onPressed: () {},
                      child: const Text("Nộp bài"),
                    ),
                  ),
                  ChicletButtonSegment(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    child: const Icon(Icons.edit_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DraggableExampleApp extends StatelessWidget {
  const DraggableExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Draggable Sample')),
        body: const DraggableExample(),
      ),
    );
  }
}

class DraggableExample extends StatefulWidget {
  const DraggableExample({super.key});

  @override
  State<DraggableExample> createState() => _DraggableExampleState();
}

class _DraggableExampleState extends State<DraggableExample> {
  int acceptedData = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Draggable<int>(
          // Data is the value this Draggable stores.
          data: 10,
          feedback: Container(
            color: Colors.deepOrange,
            height: 100,
            width: 100,
            child: const Icon(Icons.directions_run),
          ),
          childWhenDragging: Container(
            height: 100.0,
            width: 100.0,
            color: Colors.pinkAccent,
            child: const Center(child: Text('Child When Dragging')),
          ),
          child: Container(
            height: 100.0,
            width: 100.0,
            color: Colors.lightGreenAccent,
            child: const Center(child: Text('Draggable')),
          ),
        ),
        DragTarget<int>(
          builder: (
            BuildContext context,
            List<dynamic> accepted,
            List<dynamic> rejected,
          ) {
            return Container(
              height: 100.0,
              width: 100.0,
              color: Colors.cyan,
              child: Center(
                child: Text('Value is updated to: $acceptedData'),
              ),
            );
          },
          onAcceptWithDetails: (DragTargetDetails<int> details) {
            setState(() {
              acceptedData += details.data;
            });
          },
        ),
      ],
    );
  }
}

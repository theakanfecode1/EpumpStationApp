import 'package:flutter/material.dart';

class ErrorPrompt extends StatelessWidget {
  final String message;

  ErrorPrompt(this.message);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: 80,
          maxWidth: 150,
          minHeight: 30,
          maxHeight: 50
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Top(),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(message,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,

                    ),),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}


class DrawTriangle extends CustomPainter {

  Paint _paint;

  DrawTriangle() {
    _paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(size.width/2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.height, size.width);
    path.close();
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
class Top extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right:5.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 10,maxHeight: 10),
              child: CustomPaint(
                size: Size(10,10),
                painter: DrawTriangle(),
              ),
            ),
          ),
          Container(
            color: Colors.red,
            height: 5,
          ),
        ],
      ),
    );
  }
}






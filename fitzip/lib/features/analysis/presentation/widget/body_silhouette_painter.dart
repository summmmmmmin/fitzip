import 'package:flutter/material.dart';

/// 카메라 화면 위에 그려지는 전신 실루엣 가이드 오버레이
class BodySilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 바깥 영역 어둡게 처리
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.45);

    // 실루엣 경계선
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // 전신 실루엣 비율 (화면 기준)
    final centerX = w / 2;
    final topY = h * 0.05;
    final bottomY = h * 0.92;
    final bodyWidth = w * 0.38;
    final headRadius = bodyWidth * 0.28;

    final path = _buildSilhouettePath(
        centerX, topY, bottomY, bodyWidth, headRadius, h);

    // 어두운 오버레이 (실루엣 외부)
    final fullRect = Rect.fromLTWH(0, 0, w, h);
    canvas.saveLayer(fullRect, Paint());
    canvas.drawRect(fullRect, overlayPaint);
    canvas.drawPath(path, Paint()..blendMode = BlendMode.clear);
    canvas.restore();

    // 실루엣 테두리
    canvas.drawPath(path, borderPaint);

    // 코너 포인트 마커
    _drawCornerMarkers(canvas, centerX, topY, bottomY, bodyWidth, headRadius, h);
  }

  Path _buildSilhouettePath(double cx, double topY, double bottomY,
      double bw, double hr, double h) {
    final path = Path();
    final shoulderY = topY + hr * 2.2 + h * 0.02;
    final waistY = shoulderY + (bottomY - shoulderY) * 0.35;
    final hipY = shoulderY + (bottomY - shoulderY) * 0.50;

    // 머리
    path.addOval(Rect.fromCircle(center: Offset(cx, topY + hr), radius: hr));

    // 몸통 (어깨 → 허리 → 힙 → 다리)
    final body = Path()
      ..moveTo(cx - bw * 0.52, shoulderY)
      ..cubicTo(cx - bw * 0.54, waistY - h * 0.02,
          cx - bw * 0.38, waistY, cx - bw * 0.32, waistY + h * 0.01)
      ..cubicTo(cx - bw * 0.50, hipY - h * 0.01,
          cx - bw * 0.52, hipY, cx - bw * 0.26, bottomY)
      ..lineTo(cx + bw * 0.26, bottomY)
      ..cubicTo(cx + bw * 0.52, hipY,
          cx + bw * 0.50, hipY - h * 0.01, cx + bw * 0.32, waistY + h * 0.01)
      ..cubicTo(cx + bw * 0.38, waistY,
          cx + bw * 0.54, waistY - h * 0.02, cx + bw * 0.52, shoulderY)
      ..lineTo(cx - bw * 0.52, shoulderY)
      ..close();

    path.addPath(body, Offset.zero);
    return path;
  }

  void _drawCornerMarkers(Canvas canvas, double cx, double topY,
      double bottomY, double bw, double hr, double h) {
    final markerPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    const len = 12.0;
    final shoulderY = topY + hr * 2.2 + h * 0.02;
    final leftX = cx - bw * 0.52;
    final rightX = cx + bw * 0.52;

    // 왼쪽 어깨
    canvas.drawLine(Offset(leftX, shoulderY), Offset(leftX + len, shoulderY), markerPaint);
    canvas.drawLine(Offset(leftX, shoulderY), Offset(leftX, shoulderY + len), markerPaint);

    // 오른쪽 어깨
    canvas.drawLine(Offset(rightX, shoulderY), Offset(rightX - len, shoulderY), markerPaint);
    canvas.drawLine(Offset(rightX, shoulderY), Offset(rightX, shoulderY + len), markerPaint);

    // 왼쪽 발
    canvas.drawLine(Offset(cx - bw * 0.26, bottomY),
        Offset(cx - bw * 0.26 + len, bottomY), markerPaint);
    // 오른쪽 발
    canvas.drawLine(Offset(cx + bw * 0.26, bottomY),
        Offset(cx + bw * 0.26 - len, bottomY), markerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

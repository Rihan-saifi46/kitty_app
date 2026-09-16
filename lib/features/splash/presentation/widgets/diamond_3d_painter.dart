import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 3D Faceted Brilliant-Cut Crystal Diamond Custom Painter.
///
/// Reproduces the exact 3D geometry, facet indices, lighting calculations,
/// metallic white gold specular shading, and sparkling stars from `loader.js`.
class Diamond3DPainter extends CustomPainter {
  Diamond3DPainter({
    required this.rotationY,
    required this.scaleFactor,
    required this.opacity,
  }) {
    _initGeometry();
  }

  final double rotationY;
  final double scaleFactor;
  final double opacity;

  static const List<double> _lightDir = <double>[0.42, 0.78, 0.52];
  static const double _fov = 460.0;
  static const double _pitchX = 0.36;
  static const double _rollZ = 0.06;

  final List<List<double>> _vertices = <List<double>>[];
  final List<_DiamondFace> _faces = <_DiamondFace>[];

  void _initGeometry() {
    const double rGirdle = 76.0;
    const double rTable = 40.0;
    const double hCrown = 30.0;
    const double hGirdleHalf = 2.0;
    const double hPavilion = 72.0;

    _vertices.clear();
    _faces.clear();

    // 1. Table Octagon (indices 0..7)
    for (int i = 0; i < 8; i++) {
      final double ang = (i * math.pi) / 4.0;
      _vertices.add(<double>[rTable * math.cos(ang), rTable * math.sin(ang), hCrown]);
    }

    // 2. Upper Girdle (indices 8..23)
    for (int i = 0; i < 16; i++) {
      final double ang = (i * math.pi) / 8.0;
      _vertices.add(<double>[rGirdle * math.cos(ang), rGirdle * math.sin(ang), hGirdleHalf]);
    }

    // 3. Lower Girdle (indices 24..39)
    for (int i = 0; i < 16; i++) {
      final double ang = (i * math.pi) / 8.0;
      _vertices.add(<double>[rGirdle * math.cos(ang), rGirdle * math.sin(ang), -hGirdleHalf]);
    }

    // 4. Culet apex (index 40)
    final int culetIdx = _vertices.length;
    _vertices.add(<double>[0.0, 0.0, -hPavilion]);

    // 5. Mid-pavilion star vertices (indices 41..48)
    final int midPavStart = _vertices.length;
    const double rMidPav = 38.0;
    const double hMidPav = -35.0;
    for (int i = 0; i < 8; i++) {
      final double ang = ((i + 0.5) * math.pi) / 4.0;
      _vertices.add(<double>[rMidPav * math.cos(ang), rMidPav * math.sin(ang), hMidPav]);
    }

    // Faces:
    // 1. Table
    for (int i = 1; i < 7; i++) {
      _faces.add(_DiamondFace(indices: <int>[0, i, i + 1], type: 'table'));
    }

    // 2. Crown & Star facets
    for (int i = 0; i < 8; i++) {
      final int t0 = i;
      final int t1 = (i + 1) % 8;
      final int g0 = 8 + i * 2;
      final int g1 = 8 + (i * 2 + 1) % 16;
      final int g2 = 8 + (i * 2 + 2) % 16;

      _faces.add(_DiamondFace(indices: <int>[t0, t1, g1], type: 'star'));
      _faces.add(_DiamondFace(indices: <int>[t0, g0, g1], type: 'crown'));
      _faces.add(_DiamondFace(indices: <int>[t1, g1, g2], type: 'crown'));
    }

    // 3. Girdle bands
    for (int i = 0; i < 16; i++) {
      final int u0 = 8 + i;
      final int u1 = 8 + (i + 1) % 16;
      final int l0 = 24 + i;
      final int l1 = 24 + (i + 1) % 16;
      _faces.add(_DiamondFace(indices: <int>[u0, l0, l1], type: 'girdle'));
      _faces.add(_DiamondFace(indices: <int>[u0, l1, u1], type: 'girdle'));
    }

    // 4. Pavilion
    for (int i = 0; i < 8; i++) {
      final int l0 = 24 + i * 2;
      final int l1 = 24 + (i * 2 + 1) % 16;
      final int l2 = 24 + (i * 2 + 2) % 16;
      final int mp = midPavStart + i;

      _faces.add(_DiamondFace(indices: <int>[l0, l1, mp], type: 'pavilion'));
      _faces.add(_DiamondFace(indices: <int>[l1, l2, mp], type: 'pavilion'));
      _faces.add(_DiamondFace(indices: <int>[mp, l0, culetIdx], type: 'pavilion'));
      _faces.add(_DiamondFace(indices: <int>[mp, culetIdx, l2], type: 'pavilion'));
    }
  }

  static List<double> _normalize(List<double> v) {
    final double len = math.sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
    if (len == 0) return <double>[0.0, 0.0, 0.0];
    return <double>[v[0] / len, v[1] / len, v[2] / len];
  }

  static List<double> _cross(List<double> a, List<double> b) {
    return <double>[
      a[1] * b[2] - a[2] * b[1],
      a[2] * b[0] - a[0] * b[2],
      a[0] * b[1] - a[1] * b[0],
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0.001) return;

    final double cx = size.width / 2.0;
    final double cy = size.height / 2.0;

    final double cosY = math.cos(rotationY);
    final double sinY = math.sin(rotationY);
    final double cosX = math.cos(_pitchX);
    final double sinX = math.sin(_pitchX);
    final double cosZ = math.cos(_rollZ);
    final double sinZ = math.sin(_rollZ);

    final List<double> normLight = _normalize(_lightDir);

    final List<List<double>> transformed = <List<double>>[];
    final List<Offset> projected = <Offset>[];
    final List<double> zPositions = <double>[];

    for (int i = 0; i < _vertices.length; i++) {
      final List<double> v = _vertices[i];
      final double x = v[0] * scaleFactor;
      final double y = v[1] * scaleFactor;
      final double z = v[2] * scaleFactor;

      // Rotation around Y
      final double x1 = x * cosY + z * sinY;
      final double y1 = y;
      final double z1 = -x * sinY + z * cosY;

      // Rotation around X (pitch)
      final double x2 = x1;
      final double y2 = y1 * cosX - z1 * sinX;
      final double z2 = y1 * sinX + z1 * cosX;

      // Rotation around Z (roll)
      final double x3 = x2 * cosZ - y2 * sinZ;
      final double y3 = x2 * sinZ + y2 * cosZ;
      final double z3 = z2;

      transformed.add(<double>[x3, y3, z3]);
      zPositions.add(z3);

      final double zDist = math.max(20.0, _fov + z3);
      final double pFactor = _fov / zDist;
      final double px = cx + x3 * pFactor;
      final double py = cy - y3 * pFactor;
      projected.add(Offset(px, py));
    }

    final List<_RenderedFace> renderedFaces = <_RenderedFace>[];
    final List<_Sparkle> sparkles = <_Sparkle>[];

    for (int i = 0; i < _faces.length; i++) {
      final _DiamondFace face = _faces[i];
      final List<int> idx = face.indices;
      final List<double> v0 = transformed[idx[0]];
      final List<double> v1 = transformed[idx[1]];
      final List<double> v2 = transformed[idx[2]];

      final List<double> e1 = <double>[v1[0] - v0[0], v1[1] - v0[1], v1[2] - v0[2]];
      final List<double> e2 = <double>[v2[0] - v0[0], v2[1] - v0[1], v2[2] - v0[2]];
      final List<double> normal = _normalize(_cross(e1, e2));

      final double zAvg = (v0[2] + v1[2] + v2[2]) / 3.0;
      final bool isFront = normal[2] > -0.15;

      final double dotL = math.max(
        0.0,
        normal[0] * normLight[0] + normal[1] * normLight[1] + normal[2] * normLight[2],
      );

      final double rz = 2.0 * dotL * normal[2] - normLight[2];
      final double specular = math.pow(math.max(0.0, rz), 16).toDouble();

      renderedFaces.add(
        _RenderedFace(
          indices: idx,
          zAvg: zAvg,
          isFront: isFront,
          dotL: dotL,
          specular: specular,
        ),
      );

      if (isFront && specular > 0.76 && scaleFactor < 6.0) {
        final Offset pt = projected[idx[0]];
        sparkles.add(_Sparkle(x: pt.dx, y: pt.dy, intensity: specular));
      }
    }

    // Sort back to front (painter's algorithm)
    renderedFaces.sort((_RenderedFace a, _RenderedFace b) => a.zAvg.compareTo(b.zAvg));

    final Paint fillPaint = Paint()..style = PaintingStyle.fill;
    final Paint strokePaint = Paint()..style = PaintingStyle.stroke;

    for (int i = 0; i < renderedFaces.length; i++) {
      final _RenderedFace item = renderedFaces[i];
      final Offset p0 = projected[item.indices[0]];
      final Offset p1 = projected[item.indices[1]];
      final Offset p2 = projected[item.indices[2]];

      final Path path = Path()
        ..moveTo(p0.dx, p0.dy)
        ..lineTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..close();

      if (!item.isFront) {
        // Back facet shading
        fillPaint.color = Color.fromRGBO(8, 38, 32, 0.30 * opacity);
        canvas.drawPath(path, fillPaint);

        strokePaint.color = Color.fromRGBO(225, 232, 240, 0.16 * opacity);
        strokePaint.strokeWidth = math.min(2.5, 0.5 * math.max(1.0, scaleFactor * 0.35));
        canvas.drawPath(path, strokePaint);
      } else {
        final double lit = item.dotL;
        final double spec = item.specular;

        // White Gold: Luminous silvery-platinum metallic brilliance
        final int r = (220 + lit * 28 + spec * 45).clamp(0, 255).toInt();
        final int g = (226 + lit * 24 + spec * 40).clamp(0, 255).toInt();
        final int b = (235 + lit * 18 + spec * 35).clamp(0, 255).toInt();
        final double a = (0.70 + lit * 0.20 + spec * 0.28).clamp(0.0, 0.96) * opacity;

        fillPaint.color = Color.fromRGBO(r, g, b, a);
        canvas.drawPath(path, fillPaint);

        // Radiant facet edges
        final double edgeAlpha = (0.52 + spec * 0.45).clamp(0.0, 0.95) * opacity;
        strokePaint.color = Color.fromRGBO(242, 246, 252, edgeAlpha);
        strokePaint.strokeWidth = math.min(4.5, math.max(0.7, 0.85 * (scaleFactor * 0.38)));
        canvas.drawPath(path, strokePaint);
      }
    }

    // Render sparkle star glints
    final Paint sparklePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    for (int i = 0; i < sparkles.length; i++) {
      final _Sparkle sp = sparkles[i];
      final double size = 5.5 * sp.intensity;
      sparklePaint.color = Color.fromRGBO(255, 255, 255, (0.92 * sp.intensity * opacity).clamp(0.0, 1.0));

      canvas.drawLine(Offset(sp.x - size, sp.y), Offset(sp.x + size, sp.y), sparklePaint);
      canvas.drawLine(Offset(sp.x, sp.y - size), Offset(sp.x, sp.y + size), sparklePaint);
    }
  }

  @override
  bool shouldRepaint(covariant Diamond3DPainter oldDelegate) {
    return oldDelegate.rotationY != rotationY ||
        oldDelegate.scaleFactor != scaleFactor ||
        oldDelegate.opacity != opacity;
  }
}

class _DiamondFace {
  const _DiamondFace({required this.indices, required this.type});
  final List<int> indices;
  final String type;
}

class _RenderedFace {
  const _RenderedFace({
    required this.indices,
    required this.zAvg,
    required this.isFront,
    required this.dotL,
    required this.specular,
  });
  final List<int> indices;
  final double zAvg;
  final bool isFront;
  final double dotL;
  final double specular;
}

class _Sparkle {
  const _Sparkle({required this.x, required this.y, required this.intensity});
  final double x;
  final double y;
  final double intensity;
}

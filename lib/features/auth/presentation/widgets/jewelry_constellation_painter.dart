import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 3D Jewelry item geometry definition (vertices and triangular faces).
class _JewelryGeometry {
  const _JewelryGeometry({
    required this.vertices,
    required this.faces,
  });

  final List<List<double>> vertices;
  final List<_JewelryFace> faces;
}

class _JewelryFace {
  const _JewelryFace({
    required this.indices,
    required this.isGold,
  });

  final List<int> indices;
  final bool isGold;
}

/// A single 3D jewelry element within the constellation.
class _JewelryItem {
  _JewelryItem({
    required this.geometry,
    required this.baseX,
    required this.baseY,
    required this.baseZ,
    required this.baseScale,
    required this.rotSpeedY,
    required this.rotSpeedX,
    required this.rotSpeedZ,
    required this.basePhase,
  });

  final _JewelryGeometry geometry;
  final double baseX;
  final double baseY;
  final double baseZ;
  final double baseScale;
  final double rotSpeedY;
  final double rotSpeedX;
  final double rotSpeedZ;
  final double basePhase;
}

/// Face ready for painter's algorithm rendering.
class _RenderFace {
  _RenderFace({
    required this.indices,
    required this.zAvg,
    required this.isFront,
    required this.isGold,
    required this.dotL,
    required this.specular,
  });

  final List<int> indices;
  final double zAvg;
  final bool isFront;
  final bool isGold;
  final double dotL;
  final double specular;
}

/// CustomPainter rendering the full 3D luxury jewelry constellation from `diamond-bg.js`:
/// - Brilliant-cut 3D Diamonds
/// - Solitaire Engagement Rings (Gold band, 4 prongs, diamond gem)
/// - Tennis Bracelets (Curved gold band with pavé collets)
/// - Logo-gold facet edges, ambient lighting, specular highlights & starburst sparkles.
class JewelryConstellationPainter extends CustomPainter {
  JewelryConstellationPainter({
    required this.progress,
    this.opacity = 1.0,
  });

  /// Normalized animation progress (0.0 to 1.0).
  final double progress;

  /// Global master opacity.
  final double opacity;

  // Cached Geometries
  static final _JewelryGeometry _diamondGeom = _buildDiamondGeometry();
  static final _JewelryGeometry _ringGeom = _buildRingGeometry();
  static final _JewelryGeometry _braceletGeom = _buildBraceletGeometry();

  static final List<double> _lightDir = _normalize(<double>[0.48, 0.72, 0.50]);
  static const double _fov = 420.0;

  // Predefined constellation items matching diamond-bg.js exactly
  static final List<_JewelryItem> _items = <_JewelryItem>[
    // Top-Left: Classic Brilliant Diamond
    _JewelryItem(
      geometry: _diamondGeom,
      baseX: -0.34,
      baseY: -0.34,
      baseZ: 90.0,
      baseScale: 0.65,
      rotSpeedY: 0.24,
      rotSpeedX: 0.15,
      rotSpeedZ: 0.08,
      basePhase: 0.8,
    ),
    // Mid-Left: Solitaire Diamond Ring
    _JewelryItem(
      geometry: _ringGeom,
      baseX: -0.40,
      baseY: -0.02,
      baseZ: 60.0,
      baseScale: 1.00,
      rotSpeedY: -0.22,
      rotSpeedX: 0.16,
      rotSpeedZ: 0.10,
      basePhase: 2.1,
    ),
    // Bottom-Left: Classic Brilliant Diamond
    _JewelryItem(
      geometry: _diamondGeom,
      baseX: -0.32,
      baseY: 0.36,
      baseZ: 40.0,
      baseScale: 0.70,
      rotSpeedY: 0.26,
      rotSpeedX: -0.16,
      rotSpeedZ: 0.10,
      basePhase: 4.3,
    ),
    // Top-Right: Classic Brilliant Diamond
    _JewelryItem(
      geometry: _diamondGeom,
      baseX: 0.34,
      baseY: -0.34,
      baseZ: 80.0,
      baseScale: 0.65,
      rotSpeedY: -0.24,
      rotSpeedX: 0.15,
      rotSpeedZ: -0.10,
      basePhase: 1.5,
    ),
    // Mid-Right: Solitaire Diamond Ring
    _JewelryItem(
      geometry: _ringGeom,
      baseX: 0.40,
      baseY: -0.02,
      baseZ: 50.0,
      baseScale: 1.00,
      rotSpeedY: 0.22,
      rotSpeedX: -0.18,
      rotSpeedZ: 0.09,
      basePhase: 5.1,
    ),
    // Bottom-Right: ONE Bangle
    _JewelryItem(
      geometry: _braceletGeom,
      baseX: 0.32,
      baseY: 0.36,
      baseZ: 70.0,
      baseScale: 0.90,
      rotSpeedY: -0.22,
      rotSpeedX: 0.16,
      rotSpeedZ: 0.12,
      basePhase: 3.2,
    ),
    // Subtle Deep Background Layer (Center-top small delicate diamond)
    _JewelryItem(
      geometry: _diamondGeom,
      baseX: 0.00,
      baseY: -0.42,
      baseZ: -160.0,
      baseScale: 0.46,
      rotSpeedY: 0.18,
      rotSpeedX: 0.12,
      rotSpeedZ: 0.06,
      basePhase: 2.8,
    ),
    // Center-bottom small diamond
    _JewelryItem(
      geometry: _diamondGeom,
      baseX: 0.00,
      baseY: 0.42,
      baseZ: -160.0,
      baseScale: 0.50,
      rotSpeedY: -0.16,
      rotSpeedX: 0.13,
      rotSpeedZ: 0.07,
      basePhase: 4.0,
    ),
  ];

  static List<double> _normalize(List<double> v) {
    final double len = math.sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
    final double d = len == 0.0 ? 1.0 : len;
    return <double>[v[0] / d, v[1] / d, v[2] / d];
  }

  static List<double> _cross(List<double> a, List<double> b) {
    return <double>[
      a[1] * b[2] - a[2] * b[1],
      a[2] * b[0] - a[0] * b[2],
      a[0] * b[1] - a[1] * b[0],
    ];
  }

  // ===========================================================================
  // 1. CLASSIC BRILLIANT-CUT 3D DIAMOND GEOMETRY
  // ===========================================================================
  static _JewelryGeometry _buildDiamondGeometry() {
    const double rGirdle = 48.0;
    const double rTable = 26.0;
    const double hCrown = 15.0;
    const double hGirdleHalf = 1.4;
    const double hPavilion = 38.0;

    final List<List<double>> vertices = <List<double>>[];

    // 0..7: Table Octagon
    for (int i = 0; i < 8; i++) {
      final double ang = (i * math.pi) / 4.0;
      vertices.add(<double>[rTable * math.cos(ang), rTable * math.sin(ang), hCrown]);
    }

    // 8..23: Upper Girdle (16 pts)
    for (int i = 0; i < 16; i++) {
      final double ang = (i * math.pi) / 8.0;
      vertices.add(<double>[rGirdle * math.cos(ang), rGirdle * math.sin(ang), hGirdleHalf]);
    }

    // 24..39: Lower Girdle (16 pts)
    for (int i = 0; i < 16; i++) {
      final double ang = (i * math.pi) / 8.0;
      vertices.add(<double>[rGirdle * math.cos(ang), rGirdle * math.sin(ang), -hGirdleHalf]);
    }

    // 40: Culet apex
    final int culetIdx = vertices.length;
    vertices.add(<double>[0.0, 0.0, -hPavilion]);

    // 41..48: Mid-pavilion star vertices
    final int midPavStart = vertices.length;
    const double rMidPav = 24.0;
    const double hMidPav = -18.0;
    for (int i = 0; i < 8; i++) {
      final double ang = ((i + 0.5) * math.pi) / 4.0;
      vertices.add(<double>[rMidPav * math.cos(ang), rMidPav * math.sin(ang), hMidPav]);
    }

    final List<_JewelryFace> faces = <_JewelryFace>[];

    // 1. Table
    for (int i = 1; i < 7; i++) {
      faces.add(_JewelryFace(indices: <int>[0, i, i + 1], isGold: false));
    }

    // 2. Crown
    for (int i = 0; i < 8; i++) {
      final int t0 = i;
      final int t1 = (i + 1) % 8;
      final int g0 = 8 + i * 2;
      final int g1 = 8 + (i * 2 + 1) % 16;
      final int g2 = 8 + (i * 2 + 2) % 16;

      faces.add(_JewelryFace(indices: <int>[t0, t1, g1], isGold: false));
      faces.add(_JewelryFace(indices: <int>[t0, g0, g1], isGold: false));
      faces.add(_JewelryFace(indices: <int>[t1, g1, g2], isGold: false));
    }

    // 3. Girdle bands
    for (int i = 0; i < 16; i++) {
      final int u0 = 8 + i;
      final int u1 = 8 + (i + 1) % 16;
      final int l0 = 24 + i;
      final int l1 = 24 + (i + 1) % 16;
      faces.add(_JewelryFace(indices: <int>[u0, l0, l1], isGold: false));
      faces.add(_JewelryFace(indices: <int>[u0, l1, u1], isGold: false));
    }

    // 4. Pavilion
    for (int i = 0; i < 8; i++) {
      final int l0 = 24 + i * 2;
      final int l1 = 24 + (i * 2 + 1) % 16;
      final int l2 = 24 + (i * 2 + 2) % 16;
      final int mp = midPavStart + i;

      faces.add(_JewelryFace(indices: <int>[l0, l1, mp], isGold: false));
      faces.add(_JewelryFace(indices: <int>[l1, l2, mp], isGold: false));
      faces.add(_JewelryFace(indices: <int>[mp, l0, culetIdx], isGold: false));
      faces.add(_JewelryFace(indices: <int>[mp, culetIdx, l2], isGold: false));
    }

    return _JewelryGeometry(vertices: vertices, faces: faces);
  }

  // ===========================================================================
  // 2. SOLITAIRE DIAMOND ENGAGEMENT RING GEOMETRY
  // ===========================================================================
  static _JewelryGeometry _buildRingGeometry() {
    final List<List<double>> vertices = <List<double>>[];
    final List<_JewelryFace> faces = <_JewelryFace>[];

    const double rRing = 38.0;
    const double rTube = 3.6;
    const int segments = 16;
    const int tubeSides = 6;

    // Torus Band
    for (int i = 0; i < segments; i++) {
      final double theta = (i * 2.0 * math.pi) / segments;
      final double cosT = math.cos(theta);
      final double sinT = math.sin(theta);

      for (int j = 0; j < tubeSides; j++) {
        final double phi = (j * 2.0 * math.pi) / tubeSides;
        final double cosP = math.cos(phi);
        final double sinP = math.sin(phi);

        final double x = (rRing + rTube * cosP) * cosT;
        final double y = (rRing + rTube * cosP) * sinT;
        final double z = rTube * sinP;
        vertices.add(<double>[x, y, z]);
      }
    }

    for (int i = 0; i < segments; i++) {
      final int nextI = (i + 1) % segments;
      for (int j = 0; j < tubeSides; j++) {
        final int nextJ = (j + 1) % tubeSides;
        final int p0 = i * tubeSides + j;
        final int p1 = nextI * tubeSides + j;
        final int p2 = nextI * tubeSides + nextJ;
        final int p3 = i * tubeSides + nextJ;

        faces.add(_JewelryFace(indices: <int>[p0, p1, p2], isGold: true));
        faces.add(_JewelryFace(indices: <int>[p0, p2, p3], isGold: true));
      }
    }

    // 4 Prongs
    const double apexY = rRing + rTube;
    const double prongH = 14.0;
    const double prongSpread = 7.0;
    final List<List<double>> prongOffsets = <List<double>>[
      <double>[-prongSpread, apexY, -prongSpread],
      <double>[prongSpread, apexY, -prongSpread],
      <double>[prongSpread, apexY, prongSpread],
      <double>[-prongSpread, apexY, prongSpread],
      <double>[-prongSpread * 0.75, apexY + prongH, -prongSpread * 0.75],
      <double>[prongSpread * 0.75, apexY + prongH, -prongSpread * 0.75],
      <double>[prongSpread * 0.75, apexY + prongH, prongSpread * 0.75],
      <double>[-prongSpread * 0.75, apexY + prongH, prongSpread * 0.75],
    ];

    final int prongBaseIdx = vertices.length;
    for (final List<double> pt in prongOffsets) {
      vertices.add(pt);
    }

    for (int p = 0; p < 4; p++) {
      final int nextP = (p + 1) % 4;
      final int b0 = prongBaseIdx + p;
      final int b1 = prongBaseIdx + nextP;
      final int t0 = prongBaseIdx + 4 + p;
      final int t1 = prongBaseIdx + 4 + nextP;

      faces.add(_JewelryFace(indices: <int>[b0, b1, t1], isGold: true));
      faces.add(_JewelryFace(indices: <int>[b0, t1, t0], isGold: true));
    }

    // Solitaire Gem
    const double gemY = apexY + prongH - 2.0;
    const double gemRGirdle = 12.0;
    const double gemRTable = 6.5;
    const double gemHCrown = 5.0;
    const double gemHPavilion = 9.0;

    final int gemBaseIdx = vertices.length;
    for (int i = 0; i < 6; i++) {
      final double a = (i * math.pi) / 3.0;
      vertices.add(<double>[gemRTable * math.cos(a), gemY + gemHCrown, gemRTable * math.sin(a)]);
    }

    final int girdleIdx = vertices.length;
    for (int i = 0; i < 12; i++) {
      final double a = (i * math.pi) / 6.0;
      vertices.add(<double>[gemRGirdle * math.cos(a), gemY, gemRGirdle * math.sin(a)]);
    }

    final int gemCuletIdx = vertices.length;
    vertices.add(<double>[0.0, gemY - gemHPavilion, 0.0]);

    for (int i = 1; i < 5; i++) {
      faces.add(_JewelryFace(indices: <int>[gemBaseIdx, gemBaseIdx + i, gemBaseIdx + i + 1], isGold: false));
    }

    for (int i = 0; i < 6; i++) {
      final int t0 = gemBaseIdx + i;
      final int t1 = gemBaseIdx + (i + 1) % 6;
      final int g0 = girdleIdx + i * 2;
      final int g1 = girdleIdx + (i * 2 + 1) % 12;
      final int g2 = girdleIdx + (i * 2 + 2) % 12;

      faces.add(_JewelryFace(indices: <int>[t0, t1, g1], isGold: false));
      faces.add(_JewelryFace(indices: <int>[t0, g0, g1], isGold: false));
      faces.add(_JewelryFace(indices: <int>[t1, g1, g2], isGold: false));
    }

    for (int i = 0; i < 12; i++) {
      final int g0 = girdleIdx + i;
      final int g1 = girdleIdx + (i + 1) % 12;
      faces.add(_JewelryFace(indices: <int>[g0, g1, gemCuletIdx], isGold: false));
    }

    return _JewelryGeometry(vertices: vertices, faces: faces);
  }

  // ===========================================================================
  // 3. TENNIS BRACELET / LUXURY BANGLE GEOMETRY
  // ===========================================================================
  static _JewelryGeometry _buildBraceletGeometry() {
    final List<List<double>> vertices = <List<double>>[];
    final List<_JewelryFace> faces = <_JewelryFace>[];

    const double rx = 46.0;
    const double ry = 34.0;
    const double thickness = 2.4;
    const double bandWidth = 5.8;
    const int segments = 18;

    for (int i = 0; i < segments; i++) {
      final double theta = (i * 2.0 * math.pi) / segments;
      final double cosT = math.cos(theta);
      final double sinT = math.sin(theta);

      final double xOuter = (rx + thickness) * cosT;
      final double yOuter = (ry + thickness) * sinT;
      final double xInner = (rx - thickness) * cosT;
      final double yInner = (ry - thickness) * sinT;

      vertices.add(<double>[xOuter, yOuter, bandWidth * 0.5]);
      vertices.add(<double>[xOuter, yOuter, -bandWidth * 0.5]);
      vertices.add(<double>[xInner, yInner, -bandWidth * 0.5]);
      vertices.add(<double>[xInner, yInner, bandWidth * 0.5]);
    }

    for (int i = 0; i < segments; i++) {
      final int nextI = (i + 1) % segments;
      final int b0 = i * 4;
      final int b1 = nextI * 4;

      for (int s = 0; s < 4; s++) {
        final int nextS = (s + 1) % 4;
        final int p0 = b0 + s;
        final int p1 = b1 + s;
        final int p2 = b1 + nextS;
        final int p3 = b0 + nextS;

        faces.add(_JewelryFace(indices: <int>[p0, p1, p2], isGold: true));
        faces.add(_JewelryFace(indices: <int>[p0, p2, p3], isGold: true));
      }
    }

    // Pavé Diamond collets
    const int diamondCollets = 10;
    for (int d = 0; d < diamondCollets; d++) {
      final double theta = (d * 2.0 * math.pi) / diamondCollets;
      final double cosT = math.cos(theta);
      final double sinT = math.sin(theta);

      final double cx = (rx + thickness + 1.2) * cosT;
      final double cy = (ry + thickness + 1.2) * sinT;
      const double cz = 0.0;

      const double dRad = 2.8;
      final int dBaseIdx = vertices.length;

      vertices.add(<double>[cx, cy, cz + dRad]);
      vertices.add(<double>[cx + dRad * -sinT, cy + dRad * cosT, cz]);
      vertices.add(<double>[cx, cy, cz - dRad]);
      vertices.add(<double>[cx + dRad * sinT, cy - dRad * cosT, cz]);
      vertices.add(<double>[cx + (dRad * 0.8) * cosT, cy + (dRad * 0.8) * sinT, cz]);

      final int p0 = dBaseIdx;
      final int p1 = dBaseIdx + 1;
      final int p2 = dBaseIdx + 2;
      final int p3 = dBaseIdx + 3;
      final int apex = dBaseIdx + 4;

      faces.add(_JewelryFace(indices: <int>[p0, p1, apex], isGold: false));
      faces.add(_JewelryFace(indices: <int>[p1, p2, apex], isGold: false));
      faces.add(_JewelryFace(indices: <int>[p2, p3, apex], isGold: false));
      faces.add(_JewelryFace(indices: <int>[p3, p0, apex], isGold: false));
    }

    return _JewelryGeometry(vertices: vertices, faces: faces);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0.001) return;

    final double w = size.width;
    final double h = size.height;
    final double responsiveFactor = (w / 1200.0).clamp(0.65, 1.0);

    // Continuous time in seconds
    final double time = progress * 24.0;

    final Paint fillPaint = Paint()..style = PaintingStyle.fill;
    final Paint strokePaint = Paint()..style = PaintingStyle.stroke;
    final Paint sparklePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (final _JewelryItem item in _items) {
      final double rotY = item.basePhase + item.rotSpeedY * time;
      final double rotX = item.basePhase * 0.65 + item.rotSpeedX * time;
      final double rotZ = item.basePhase * 0.35 + item.rotSpeedZ * time;
      final double floatY = math.sin(time * 0.75 + item.basePhase) * 5.5;

      final double cx = w * 0.5 + item.baseX * w;
      final double cy = h * 0.5 + item.baseY * h + floatY;
      final double scale = item.baseScale * responsiveFactor;

      _renderItem(
        canvas: canvas,
        item: item,
        cx: cx,
        cy: cy,
        scale: scale,
        rotY: rotY,
        rotX: rotX,
        rotZ: rotZ,
        fillPaint: fillPaint,
        strokePaint: strokePaint,
        sparklePaint: sparklePaint,
      );
    }
  }

  void _renderItem({
    required Canvas canvas,
    required _JewelryItem item,
    required double cx,
    required double cy,
    required double scale,
    required double rotY,
    required double rotX,
    required double rotZ,
    required Paint fillPaint,
    required Paint strokePaint,
    required Paint sparklePaint,
  }) {
    final _JewelryGeometry geom = item.geometry;
    final double cosY = math.cos(rotY), sinY = math.sin(rotY);
    final double cosX = math.cos(rotX), sinX = math.sin(rotX);
    final double cosZ = math.cos(rotZ), sinZ = math.sin(rotZ);

    final List<List<double>> transformed = <List<double>>[];
    final List<Offset> projected = <Offset>[];

    for (final List<double> v in geom.vertices) {
      final double x = v[0] * scale;
      final double y = v[1] * scale;
      final double z = v[2] * scale;

      // Rotation Y
      final double x1 = x * cosY + z * sinY;
      final double y1 = y;
      final double z1 = -x * sinY + z * cosY;

      // Rotation X
      final double x2 = x1;
      final double y2 = y1 * cosX - z1 * sinX;
      final double z2 = y1 * sinX + z1 * cosX;

      // Rotation Z
      final double x3 = x2 * cosZ - y2 * sinZ;
      final double y3 = x2 * sinZ + y2 * cosZ;
      final double z3 = z2;

      transformed.add(<double>[x3, y3, z3]);

      final double zDist = math.max(20.0, _fov + z3 + item.baseZ);
      final double pFactor = _fov / zDist;
      final double px = cx + x3 * pFactor;
      final double py = cy - y3 * pFactor;
      projected.add(Offset(px, py));
    }

    final List<_RenderFace> renderFaces = <_RenderFace>[];
    final List<Map<String, double>> sparkles = <Map<String, double>>[];

    for (final _JewelryFace face in geom.faces) {
      final List<int> idx = face.indices;
      final List<double> v0 = transformed[idx[0]];
      final List<double> v1 = transformed[idx[1]];
      final List<double> v2 = transformed[idx[2]];

      final List<double> e1 = <double>[v1[0] - v0[0], v1[1] - v0[1], v1[2] - v0[2]];
      final List<double> e2 = <double>[v2[0] - v0[0], v2[1] - v0[1], v2[2] - v0[2]];
      final List<double> norm = _normalize(_cross(e1, e2));

      final double zAvg = (v0[2] + v1[2] + v2[2]) / 3.0;
      final bool isFront = norm[2] > -0.14;

      final double dotL = math.max(0.0, norm[0] * _lightDir[0] + norm[1] * _lightDir[1] + norm[2] * _lightDir[2]);
      final double rz = 2.0 * dotL * norm[2] - _lightDir[2];
      final double specular = math.pow(math.max(0.0, rz), face.isGold ? 12 : 18).toDouble();

      renderFaces.add(_RenderFace(
        indices: idx,
        zAvg: zAvg,
        isFront: isFront,
        isGold: face.isGold,
        dotL: dotL,
        specular: specular,
      ));

      if (isFront && specular > 0.82 && !face.isGold) {
        final Offset pt = projected[idx[0]];
        sparkles.add(<String, double>{'x': pt.dx, 'y': pt.dy, 'intensity': specular});
      }
    }

    // Painter's algorithm: sort by depth
    renderFaces.sort((_RenderFace a, _RenderFace b) => a.zAvg.compareTo(b.zAvg));

    final Path path = Path();
    for (final _RenderFace f in renderFaces) {
      final Offset p0 = projected[f.indices[0]];
      final Offset p1 = projected[f.indices[1]];
      final Offset p2 = projected[f.indices[2]];

      path.reset();
      path.moveTo(p0.dx, p0.dy);
      path.lineTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
      path.close();

      if (f.isGold) {
        if (!f.isFront) {
          fillPaint.color = Color.fromRGBO(70, 52, 18, 0.22 * opacity);
          canvas.drawPath(path, fillPaint);
          strokePaint.color = Color.fromRGBO(204, 162, 67, 0.18 * opacity);
          strokePaint.strokeWidth = 0.7;
          canvas.drawPath(path, strokePaint);
        } else {
          final double lit = f.dotL;
          final double spec = f.specular;
          final int r = (204 + lit * 36 + spec * 15).toInt().clamp(0, 255);
          final int g = (162 + lit * 44 + spec * 40).toInt().clamp(0, 255);
          final int b = (67 + lit * 45 + spec * 75).toInt().clamp(0, 255);
          final double a = (0.24 + lit * 0.20 + spec * 0.22).clamp(0.0, 0.58) * opacity;

          fillPaint.color = Color.fromRGBO(r, g, b, a);
          canvas.drawPath(path, fillPaint);

          final double edgeAlpha = (0.35 + spec * 0.45).clamp(0.0, 0.85) * opacity;
          strokePaint.color = Color.fromRGBO(244, 226, 170, edgeAlpha);
          strokePaint.strokeWidth = 0.9;
          canvas.drawPath(path, strokePaint);
        }
      } else {
        if (!f.isFront) {
          fillPaint.color = Color.fromRGBO(50, 38, 14, 0.24 * opacity);
          canvas.drawPath(path, fillPaint);
          strokePaint.color = Color.fromRGBO(204, 162, 67, 0.22 * opacity);
          strokePaint.strokeWidth = 0.7;
          canvas.drawPath(path, strokePaint);
        } else {
          final double lit = f.dotL;
          final double spec = f.specular;
          final int r = (204 + lit * 38 + spec * 13).toInt().clamp(0, 255);
          final int g = (165 + lit * 48 + spec * 36).toInt().clamp(0, 255);
          final int b = (72 + lit * 55 + spec * 75).toInt().clamp(0, 255);
          final double a = (0.22 + lit * 0.20 + spec * 0.24).clamp(0.0, 0.55) * opacity;

          fillPaint.color = Color.fromRGBO(r, g, b, a);
          canvas.drawPath(path, fillPaint);

          final double edgeAlpha = (0.42 + spec * 0.45).clamp(0.0, 0.90) * opacity;
          strokePaint.color = Color.fromRGBO(244, 226, 170, edgeAlpha);
          strokePaint.strokeWidth = 1.05;
          canvas.drawPath(path, strokePaint);
        }
      }
    }

    // Sparkles on facet vertices in warm logo gold
    for (final Map<String, double> sp in sparkles) {
      final double sx = sp['x']!;
      final double sy = sp['y']!;
      final double intensity = sp['intensity']!;
      final double size = 4.2 * intensity;
      sparklePaint.color = Color.fromRGBO(255, 238, 175, (0.85 * intensity).clamp(0.0, 1.0) * opacity);

      canvas.drawLine(Offset(sx - size, sy), Offset(sx + size, sy), sparklePaint);
      canvas.drawLine(Offset(sx, sy - size), Offset(sx, sy + size), sparklePaint);
    }
  }

  @override
  bool shouldRepaint(covariant JewelryConstellationPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.opacity != opacity;
  }
}

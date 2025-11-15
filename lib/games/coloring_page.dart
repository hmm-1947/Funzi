import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:naif/helpers/sketches_game_levels.dart';
import 'package:naif/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColoringPage extends StatefulWidget {
  const ColoringPage({super.key});

  @override
  State<ColoringPage> createState() => _ColoringPageState();
}

class _ColoringPageState extends State<ColoringPage>
    with WidgetsBindingObserver {
  String? selectedSketch;

  final sketches = sketchesGameLevels;

  final Map<String, List<DrawingStroke>> savedDrawings = {};
  List<Offset> currentEraserStroke = [];
  bool isZoomMode = false;
  final TransformationController _transformController =
      TransformationController();

  Color selectedColor = Colors.red;
  double brushSize = 8.0;
  double eraserSize = 15.0;
  bool isErasing = false;

  List<DrawingStroke> strokes = [];
  List<Offset> currentStroke = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadAllSavedDrawings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _saveAllDrawings();
      _transformController.value = Matrix4.identity();
    }
  }

  // ---------------- STORAGE ----------------
  Future<void> _loadAllSavedDrawings() async {
    final prefs = await SharedPreferences.getInstance();
    for (var sketch in sketches) {
      final data = prefs.getString(sketch);
      if (data != null) {
        savedDrawings[sketch] = _decodeDrawing(data);
      }
    }
    setState(() {}); // ensure UI refresh
  }

  Future<void> _saveDrawing(String sketch) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _encodeDrawing(strokes);
    await prefs.setString(sketch, encoded);
    savedDrawings[sketch] = List.from(strokes);
  }

  Future<void> _saveAllDrawings() async {
    if (selectedSketch != null) {
      await _saveDrawing(selectedSketch!);
    }
  }

  String _encodeDrawing(List<DrawingStroke> strokes) {
    final data = strokes.map((stroke) {
      return {
        'color': stroke.color.value,
        'strokeWidth': stroke.strokeWidth,
        'points': stroke.points.map((p) => {'dx': p.dx, 'dy': p.dy}).toList(),
      };
    }).toList();
    return jsonEncode(data);
  }

  List<DrawingStroke> _decodeDrawing(String data) {
    final List decoded = jsonDecode(data);
    return decoded.map((item) {
      return DrawingStroke(
        color: Color(item['color']),
        strokeWidth: (item['strokeWidth'] as num).toDouble(),
        points: (item['points'] as List)
            .map((p) => Offset(p['dx'], p['dy']))
            .toList(),
      );
    }).toList();
  }

  // ---------------- ASK TO SAVE ----------------
  Future<bool> _askToSaveBeforeExit() async {
    if (selectedSketch == null) return true;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? "حفظ التلوين؟" : "Save Coloring?"),
        content: Text(
          isArabic
              ? "هل تريد حفظ التلوين قبل الخروج؟"
              : "Do you want to save your coloring before exiting?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: Text(isArabic ? "إلغاء" : "Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'no'),
            child: Text(isArabic ? "عدم الحفظ" : "Don't Save"),
          ),
          ElevatedButton(
            onPressed: () async {
              await _saveAllDrawings();
              Navigator.pop(context, 'yes');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
            child: Text(isArabic ? "حفظ" : "Save"),
          ),
        ],
      ),
    );

    return result == 'yes' || result == 'no';
  }

  // ---------------- UI LOGIC ----------------
  void changeColor(Color color) {
    setState(() {
      selectedColor = color;
      isErasing = false;
    });
  }

  void toggleEraser() => setState(() => isErasing = !isErasing);

  Future<void> clearCanvas() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'مسح اللوحة؟' : 'Clear Canvas?'),
        content: Text(
          isArabic
              ? 'هل أنت متأكد من مسح رسوماتك؟'
              : 'Are you sure you want to clear your drawing?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: Text(isArabic ? 'مسح' : 'Clear'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      setState(() => strokes.clear());
      if (selectedSketch != null) _saveDrawing(selectedSketch!);
    }
  }

  void selectSketch(String sketch) {
    setState(() {
      selectedSketch = sketch;
      strokes = List.from(savedDrawings[sketch] ?? []);
    });
    _saveAllDrawings();
  }

  // ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _askToSaveBeforeExit,
      child: selectedSketch == null
          ? _buildSketchSelector()
          : _buildDrawingScreen(),
    );
  }

  Widget _buildSketchSelector() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/cover.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            isArabic ? 'اختر رسمة' : 'Select a Sketch',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'calibri',
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 52, 52, 52),
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: sketches.length,
          itemBuilder: (context, index) {
            final sketch = sketches[index];
            return GestureDetector(
              onTap: () {
                _saveAllDrawings();
                selectSketch(sketch);
              },
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(sketch, fit: BoxFit.contain),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDrawingScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'تلوين الصورة' : 'Color the Picture'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            bool shouldExit = await _askToSaveBeforeExit();
            if (shouldExit) {
              setState(() => selectedSketch = null);
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: clearCanvas,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return InteractiveViewer(
            transformationController: _transformController,
            panEnabled: isZoomMode, // ✅ Only allow pan in zoom mode
            scaleEnabled: isZoomMode, // ✅ Only allow pinch zoom in zoom mode
            minScale: 0.5,
            maxScale: 3.0,
            child: GestureDetector(
              // ✅ Only handle drawing when NOT in zoom mode
              onPanStart: isZoomMode
                  ? null
                  : (details) {
                      setState(() {
                        if (!isErasing) {
                          currentStroke = [details.localPosition];
                          strokes.add(
                            DrawingStroke(
                              color: selectedColor,
                              strokeWidth: brushSize,
                              points: List.from(currentStroke),
                              isUserStroke: true,
                            ),
                          );
                        } else {
                          _eraseAt(details.localPosition);
                        }
                      });
                    },
              onPanUpdate: isZoomMode
                  ? null
                  : (details) {
                      setState(() {
                        if (!isErasing) {
                          currentStroke.add(details.localPosition);
                          strokes.last.points = List.from(currentStroke);
                        } else {
                          _eraseAt(details.localPosition);
                        }
                      });
                    },
              onPanEnd: isZoomMode ? null : (_) => currentStroke = [],
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(selectedSketch!, fit: BoxFit.contain),
                  ),
                  CustomPaint(
                    painter: ColoringPainter(strokes),
                    child: Container(),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: _buildBottomControls(),
    );
  }

  void _eraseAt(Offset position) {
    final eraseRadius = eraserSize; // use slider value

    List<DrawingStroke> newStrokes = [];

    for (var stroke in strokes) {
      if (!stroke.isUserStroke) {
        newStrokes.add(stroke); // keep sketch strokes untouched
        continue;
      }

      // Split stroke into segments that are outside eraseRadius
      List<Offset> segment = [];
      for (var point in stroke.points) {
        if ((point - position).distance > eraseRadius) {
          segment.add(point);
        } else {
          if (segment.isNotEmpty) {
            newStrokes.add(
              DrawingStroke(
                color: stroke.color,
                strokeWidth: stroke.strokeWidth,
                points: List.from(segment),
                isUserStroke: true,
              ),
            );
            segment = [];
          }
        }
      }
      if (segment.isNotEmpty) {
        newStrokes.add(
          DrawingStroke(
            color: stroke.color,
            strokeWidth: stroke.strokeWidth,
            points: List.from(segment),
            isUserStroke: true,
          ),
        );
      }
    }

    strokes = newStrokes;
  }

  Widget _buildBottomControls() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final color in [
                  Colors.red,
                  Colors.green,
                  Colors.blue,
                  Colors.yellow,
                  Colors.orange,
                  Colors.brown,
                  Colors.black,
                ])
                  GestureDetector(
                    onTap: () => changeColor(color),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: CircleAvatar(
                        backgroundColor: color,
                        radius: 20,
                        child: !isErasing && selectedColor == color
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: toggleEraser,
                  child: CircleAvatar(
                    backgroundColor: isErasing
                        ? Colors.grey[800]
                        : Colors.grey[300],
                    radius: 20,
                    child: Icon(
                      Icons.cleaning_services,
                      color: isErasing ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                isZoomMode = !isZoomMode;
                isErasing = false; // disable eraser if zoom enabled
              });
            },
            child: CircleAvatar(
              backgroundColor: isZoomMode
                  ? Colors.blueAccent
                  : Colors.grey[300],
              radius: 20,
              child: Icon(
                Icons.search,
                color: isZoomMode ? Colors.white : Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 10),
          if (!isErasing)
            Column(
              children: [
                Text(isArabic ? "حجم الفرشاة" : "Brush Size"),
                Slider(
                  value: brushSize,
                  min: 2,
                  max: 30,
                  divisions: 14,
                  label: brushSize.round().toString(),
                  onChanged: (value) => setState(() => brushSize = value),
                ),
              ],
            ),
          if (isErasing)
            Column(
              children: [
                Text(isArabic ? "حجم الممحاة" : "Eraser Size"),
                Slider(
                  value: eraserSize,
                  min: 5,
                  max: 40,
                  divisions: 14,
                  label: eraserSize.round().toString(),
                  onChanged: (value) => setState(() => eraserSize = value),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ---------------- DRAWING CLASSES ----------------
class DrawingStroke {
  Color color;
  double strokeWidth;
  List<Offset> points;
  final bool isUserStroke; // user drawn

  DrawingStroke({
    required this.color,
    required this.strokeWidth,
    required this.points,
    this.isUserStroke = true,
  });
}

class ColoringPainter extends CustomPainter {
  final List<DrawingStroke> strokes;
  ColoringPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      for (int i = 0; i < stroke.points.length - 1; i++) {
        if (stroke.points[i] != Offset.zero &&
            stroke.points[i + 1] != Offset.zero) {
          canvas.drawLine(stroke.points[i], stroke.points[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant ColoringPainter oldDelegate) => true;
}

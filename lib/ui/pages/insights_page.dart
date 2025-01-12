import 'package:flutter/material.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar.large(
          title: Text('Insights'),
          floating: true,
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              _buildFocusChart(),
              const SizedBox(height: 16),
              _buildProductivityInsights(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFocusChart() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Focus Trends'),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: CustomPaint(
                painter: ChartPainter(),
                size: const Size(double.infinity, 200),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductivityInsights() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('AI Insights'),
            SizedBox(height: 16),
            InsightCard(
              icon: Icons.trending_up,
              title: 'Peak Performance',
              description: 'Your focus is highest between 9 AM and 11 AM',
            ),
            InsightCard(
              icon: Icons.warning,
              title: 'Potential Distraction',
              description: 'Social media usage increases after 2 PM',
            ),
          ],
        ),
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final points = _generatePoints(size);

    path.moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  List<Offset> _generatePoints(Size size) {
    const pointCount = 7;
    final points = <Offset>[];
    final width = size.width;
    final height = size.height;

    for (var i = 0; i < pointCount; i++) {
      final x = (width / (pointCount - 1)) * i;
      final y = height - (height * 0.2 * (i % 3 + 1));
      points.add(Offset(x, y));
    }

    return points;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class InsightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const InsightCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(icon),
      ),
      title: Text(title),
      subtitle: Text(description),
    );
  }
}
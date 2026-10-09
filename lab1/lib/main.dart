import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'lab1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Segoe UI',
      ),
      home: const _SetupToolHomePage(),
    );
  }
}

class _SetupToolHomePage extends StatefulWidget {
  const _SetupToolHomePage();

  @override
  State<_SetupToolHomePage> createState() => _SetupToolHomePageState();
}

class _SetupToolHomePageState extends State<_SetupToolHomePage>
    with TickerProviderStateMixin {
  late final AnimationController _heroController;
  late final AnimationController _counterRevealController;
  late final Animation<double> _heroFade;
  late final Animation<Offset> _heroSlide;
  late final Animation<double> _counterFade;

  int _counter = 0;

  @override
  void initState() {
    super.initState();

    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _heroFade = CurvedAnimation(parent: _heroController, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _heroController,
      curve: Curves.easeOutCubic,
    ));

    _counterRevealController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _counterFade = CurvedAnimation(
      parent: _counterRevealController,
      curve: Curves.easeIn,
    );

    _heroController.forward().whenComplete(() {
      _counterRevealController.forward();
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _counterRevealController.dispose();
    super.dispose();
  }

  void _incrementCounter() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0A0E21),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, -0.3),
            radius: 1.5,
            colors: [
              Color(0xFF1A237E),
              Color(0xFF0D1117),
              Color(0xFF000000),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? size.width * 0.1 : 24,
                vertical: 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── Branded Hero Section ──
                  FadeTransition(
                    opacity: _heroFade,
                    child: SlideTransition(
                      position: _heroSlide,
                      child: _buildHeroSection(context, isWide),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // ── Counter Demo Section ──
                  FadeTransition(
                    opacity: _counterFade,
                    child: _buildCounterSection(context, isWide),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FadeTransition(
        opacity: _counterFade,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1565C0).withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add_rounded, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isWide) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 520),
      padding: EdgeInsets.all(isWide ? 48 : 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A237E).withOpacity(0.35),
            const Color(0xFF0D47A1).withOpacity(0.15),
            const Color(0xFF000000).withOpacity(0.2),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF42A5F5).withOpacity(0.12),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D47A1).withOpacity(0.15),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Icon Badge ──
          Container(
            width: isWide ? 110 : 90,
            height: isWide ? 110 : 90,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1565C0).withOpacity(0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                  spreadRadius: 2,
                ),
              ],
              border: Border.all(
                color: const Color(0xFF42A5F5).withOpacity(0.25),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.rocket_launch_rounded,
              size: isWide ? 56 : 46,
              color: Colors.white,
            ),
          ),

          SizedBox(height: isWide ? 32 : 24),

          // ── Title ──
          Text(
            'Flutter Setup Tool Pro',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isWide ? 26 : 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 12),

          // ── Divider ──
          Container(
            width: 50,
            height: 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: const LinearGradient(
                colors: [Color(0xFF42A5F5), Color(0xFF1565C0)],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Description ──
          Text(
            'Seamlessly installed & configured',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isWide ? 16 : 14,
              color: const Color(0xFF90CAF9),
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 20),

          // ── Developer Credit ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF1A237E).withOpacity(0.4),
              border: Border.all(
                color: const Color(0xFF42A5F5).withOpacity(0.1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.engineering_rounded,
                  size: 18,
                  color: const Color(0xFF64B5F6).withOpacity(0.8),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'Eng. Mustafa Al-Qershi',
                    style: TextStyle(
                      fontSize: isWide ? 14 : 13,
                      color: const Color(0xFF90CAF9),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterSection(BuildContext context, bool isWide) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
      ),
      child: Column(
        children: [
          Text(
            'You have pushed the button this many times:',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isWide ? 15 : 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$_counter',
            style: TextStyle(
              fontSize: isWide ? 52 : 44,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }
}

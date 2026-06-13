import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Import Layer Presentation (Providers)
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/encyclopedia_provider.dart';
import 'presentation/providers/scan_provider.dart';
import 'presentation/providers/history_provider.dart';


// Import Layer Presentation (Screens)
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/petani/home_petani.dart';
import 'presentation/screens/admin/admin_dashboard.dart';

// Import Core Themes
import 'core/themes/app_theme.dart';

Future<void> main() async {
  // 1. Pastikan inisialisasi Flutter Engine selesai
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Load konfigurasi dari file .env (BASE_URL backend)
  try {
    await dotenv.load(fileName: ".env");
    print(">>> [SYSTEM] .env loaded successfully");
  } catch (e) {
    print(">>> [SYSTEM] Error loading .env file: $e");
  }

  runApp(const ChiliCareApp());
}

class ChiliCareApp extends StatelessWidget {
  const ChiliCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // 3. Setup State Management (Provider)
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ScanProvider()),
        ChangeNotifierProvider(create: (_) => EncyclopediaProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: MaterialApp(
        title: 'ChiliCare',
        debugShowCheckedModeBanner: false,
        
        // 4. Konfigurasi Tema Pop-Art / Neubrutalism secara Global
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: ChiliTheme.tomatoRed,
          
          // Font Modern (Plus Jakarta Sans)
          textTheme: GoogleFonts.plusJakartaSansTextTheme(
            Theme.of(context).textTheme,
          ),
          
          // Style Tombol Global (Bold & Boxy)
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: ChiliTheme.mintGreen,
              foregroundColor: Colors.black,
              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.black, width: 2.5),
              ),
              elevation: 0,
            ),
          ),

          // Style Input Field (Bold Borders)
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 2.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 3),
            ),
            labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),

          // Style AppBar
          appBarTheme: AppBarTheme(
            backgroundColor: ChiliTheme.tomatoRed,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            shape: const Border(
              bottom: BorderSide(color: Colors.black, width: 2.5),
            ),
          ),
        ),

        // 5. Jalur Navigasi Utama
        // Aplikasi dimulai dari SplashScreen untuk cek sesi
        home: const SplashScreen(),

        // Definisi Routes (Opsional, untuk navigasi yang lebih rapi)
        routes: {
          '/login': (context) => LoginScreen(),
          '/home-petani': (context) => const HomePetani(),
          '/dashboard-admin': (context) => const AdminDashboard(),
        },
      ),
    );
  }
}
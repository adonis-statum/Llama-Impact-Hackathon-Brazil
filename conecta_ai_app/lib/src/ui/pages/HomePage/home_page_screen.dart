import 'package:conecta_ai_app/src/ui/components/custom_colors.dart';
import 'package:conecta_ai_app/src/ui/components/custom_drawer.dart';
import 'package:conecta_ai_app/src/ui/pages/Fomulario/formulario_screen.dart';
import 'package:flutter/material.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Cor.white, size: 28),
        title: const Text(
          'Conecta AI',
          style: TextStyle(color: Cor.white),
        ),
        backgroundColor: Cor.darkBlue,
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Cor.hardBlue, // Cor inicial do gradiente
              Cor.lightBlue, // Cor final do gradiente
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.description_rounded,
                  color: Cor.darkBlue,
                  size: 80,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Construa seu currículo profissional de forma\nsimples e acessível.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Conectando você ao mercado de trabalho com apenas alguns passos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Lógica para iniciar o formulário de perguntas
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FormularioScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Cor.darkBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Criar Currículo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

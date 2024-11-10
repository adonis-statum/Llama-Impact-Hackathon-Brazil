import 'package:conecta_ai_app/src/ui/components/custom_colors.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Cor.white,
      child: ListView(
        children: const [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Cor.darkBlue,
            ),
            child: SingleChildScrollView(
              // Permite rolagem se necessário
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/logo.png'),
                    backgroundColor: Cor.mediumBlue,
                    radius: 40,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Jhonatas Teixeira',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'jhonatas@gmail.com',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text('Perfil'),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text('Configurações'),
            leading: Icon(Icons.settings),
          ),
          ListTile(
            title: Text('Sair'),
            leading: Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }
}

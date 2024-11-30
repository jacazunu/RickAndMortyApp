import 'package:flutter/material.dart';
import 'package:prueba_vacante_app/domain/entities/character.dart';

class CharacterDetailPage extends StatelessWidget {
  final Character character;

  CharacterDetailPage({required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white60,
        title: Text(character.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Para que se pueda hacer scroll si el contenido es largo
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Imagen con bordes redondeados
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    character.image,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),
                
                // Detalles del personaje con texto en un estilo más atractivo
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 4), // Sombra suave
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailText('Nombre:', character.name),
                      _buildDetailText('Estado:', character.status),
                      _buildDetailText('Especie:', character.species),
                      _buildDetailText('Género:', character.gender),
                      _buildDetailText('Ubicación Actual:', character.location),
                      _buildDetailText('Origen:', character.origin),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Botón con diseño atractivo y redondeado
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 238, 235, 235), // Fondo del botón
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Regresar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para crear los detalles del personaje en formato de texto
  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
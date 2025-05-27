import 'package:flutter/material.dart';
import '../models/group.dart';
import '../models/user.dart';
import 'group_page.dart';
import '../services/triaccount_api_service.dart';
import 'login_page.dart';
import 'add_group_page.dart';

// Página principal tras iniciar sesión, donde se gestionan los grupos del usuario.
class HomePage extends StatefulWidget {
  final User loggedUser;
  const HomePage({super.key, required this.loggedUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TriAccountService apiService = TriAccountService();
  static List<Group> userGroups = [];

  // Se obtienen los grupos del usuario.
  @override
  void initState(){
    super.initState();
    _obtainGroups();
  }

  // Obtiene los grupos desde el modelo del usuario y fuerza actualización del estado.
  void _obtainGroups() async {
    userGroups = await widget.loggedUser.getGroups();
    setState(() {
      userGroups;
    });
  }

  // Cierra sesión: llama al API, limpia los grupos y navega a la pantalla de login.
  void _handleLogout(BuildContext context) async {
    try {
      await apiService.logout();
      userGroups.clear();
      // Volver a login y limpiar la navegación
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  // Abre la pantalla para añadir un nuevo grupo y lo añade a la lista si fue creado.
  void _navigateToAddGroup() async {
    final newGroupName = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const AddGroupPage()),
    );

    if (newGroupName != null && newGroupName.isNotEmpty) {
      Group grp = await widget.loggedUser.createGroup(newGroupName);
      setState(() {
        userGroups.add(grp);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Grupo "$newGroupName" añadido')),
      );
    }
  }

  // Construye la interfaz visual del HomePage.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TRI-ACCOUNT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          // Botón en la AppBar para cerrar sesión.
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _handleLogout(context),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Mis Grupos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            // Lista que muestra cada grupo en una tarjeta.
            Expanded(
              child: ListView.builder(
                itemCount: userGroups.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      // Nombre del grupo como título principal.
                      title: Text(
                        userGroups[index].groupName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      // En el extremo derecho de cada grupo se muestra un botón para eliminarlo y un icono para navegar.
                      // Al pulsar el botón de eliminar, se muestra un cuadro de diálogo de confirmación.
                      // Si el usuario confirma, el grupo se elimina visualmente de la lista (solo en la interfaz),
                      // luego se aplica la lógica de eliminación real, y se muestra un mensaje de éxito.
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Botón de eliminación de grupo
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red[400]),
                            tooltip: 'Eliminar grupo',
                            onPressed: () {
                              showDialog(
                                context: context,
                                // Cuadro de diálogo de confirmación
                                builder: (context) => AlertDialog(
                                  title: const Text('¿Estás seguro?'),
                                  content: const Text('¿Quieres eliminar este grupo?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancelar'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                      child: const Text('Confirmar'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        // Eliminar Grupo usando métod apropiado
                                        widget.loggedUser.deleteGroup(userGroups.elementAt(index).id);
                                        userGroups.removeAt(index);

                                        setState(() {});
                                        // Aplicar lógica de eliminación
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Grupo eliminado con éxito'),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          // Icono para navegar a la página del grupo correspondiente.
                          Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[400]),
                        ],
                      ),
                      // Al pulsar sobre el grupo, se abre la pantalla con el detalle del grupo.
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GroupPage(group: userGroups[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Botón para añadir un nuevo grupo.
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddGroup,
        backgroundColor: Colors.grey[900],
        child: const Icon(Icons.add, size: 32),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

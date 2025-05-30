import 'Filter.dart';

class EmptyParticipantFilter implements Filter {
  @override
  void execute(Map<String, dynamic> request) {
    final participants = request['participants'] as Map<String, dynamic>?;
    if (participants == null || participants.isEmpty) {
      throw Exception("El gasto debe tener al menos un participante.");
    }
  }
}

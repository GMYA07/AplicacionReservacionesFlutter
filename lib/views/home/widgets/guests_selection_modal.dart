// lib/views/home/widgets/guests_selection_modal.dart

import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';

/// Clase que encapsula el resultado seleccionado de habitaciones y huéspedes
class GuestsSelectionResult {
  final int rooms;
  final int adults;
  final int children;

  const GuestsSelectionResult({
    required this.rooms,
    required this.adults,
    required this.children,
  });
}

/// Modal modular para seleccionar número de habitaciones y huéspedes
/// con la estética limpia y controles característicos de Booking.com.
class GuestsSelectionModal extends StatefulWidget {
  final int initialRooms;
  final int initialAdults;
  final int initialChildren;

  const GuestsSelectionModal({
    super.key,
    required this.initialRooms,
    required this.initialAdults,
    required this.initialChildren,
  });

  /// Método estático auxiliar para abrir el modal desde cualquier vista
  static Future<GuestsSelectionResult?> show(
    BuildContext context, {
    required int rooms,
    required int adults,
    required int children,
  }) {
    return showModalBottomSheet<GuestsSelectionResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => GuestsSelectionModal(
        initialRooms: rooms,
        initialAdults: adults,
        initialChildren: children,
      ),
    );
  }

  @override
  State<GuestsSelectionModal> createState() => _GuestsSelectionModalState();
}

class _GuestsSelectionModalState extends State<GuestsSelectionModal> {
  late int _rooms;
  late int _adults;
  late int _children;

  @override
  void initState() {
    super.initState();
    _rooms = widget.initialRooms;
    _adults = widget.initialAdults;
    _children = widget.initialChildren;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Barra de arrastre superior (Pill)
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Cabecera con título y botón de cerrar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Selecciona habitaciones y personas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textMuted),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // Fila 1: Habitaciones
          _buildCounterRow(
            label: 'Habitaciones',
            subtitle: 'Espacio exclusivo para tu estancia',
            count: _rooms,
            min: 1,
            max: 10,
            onChanged: (val) => setState(() => _rooms = val),
          ),
          const Divider(),

          // Fila 2: Adultos
          _buildCounterRow(
            label: 'Adultos',
            subtitle: '18 años o más',
            count: _adults,
            min: 1,
            max: 20,
            onChanged: (val) => setState(() => _adults = val),
          ),
          const Divider(),

          // Fila 3: Niños
          _buildCounterRow(
            label: 'Niños',
            subtitle: 'De 0 a 17 años',
            count: _children,
            min: 0,
            max: 10,
            onChanged: (val) => setState(() => _children = val),
          ),

          const SizedBox(height: 24),

          // Botón Aplicar
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
                GuestsSelectionResult(
                  rooms: _rooms,
                  adults: _adults,
                  children: _children,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Aplicar',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye cada fila con control de incremento y decremento
  Widget _buildCounterRow({
    required String label,
    required String subtitle,
    required int count,
    required int min,
    required int max,
    required ValueChanged<int> onChanged,
  }) {
    final canDecrease = count > min;
    final canIncrease = count < max;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Información del campo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // Controles + y -
          Row(
            children: [
              _buildStepperButton(
                icon: Icons.remove,
                isEnabled: canDecrease,
                onPressed: canDecrease ? () => onChanged(count - 1) : null,
              ),
              SizedBox(
                width: 38,
                child: Text(
                  '$count',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              _buildStepperButton(
                icon: Icons.add,
                isEnabled: canIncrease,
                onPressed: canIncrease ? () => onChanged(count + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Botón circular para el stepper
  Widget _buildStepperButton({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isEnabled ? AppColors.accentBlue : Colors.grey.shade300,
          width: 1.5,
        ),
        color: isEnabled ? Colors.white : Colors.grey.shade100,
      ),
      child: IconButton(
        icon: Icon(icon, size: 18),
        padding: EdgeInsets.zero,
        color: isEnabled ? AppColors.accentBlue : Colors.grey.shade400,
        onPressed: onPressed,
      ),
    );
  }
}

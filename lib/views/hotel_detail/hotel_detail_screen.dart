// lib/views/hotel_detail/hotel_detail_screen.dart

import 'package:flutter/material.dart';
import '../../models/hotel_model.dart';
import '../../utils/app_colors.dart';

/// Vista de detalle del hotel preparada y estática para la siguiente fase.
class HotelDetailScreen extends StatelessWidget {
  final HotelModel hotel;

  const HotelDetailScreen({
    super.key,
    required this.hotel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: AppBar(
        title: Text(
          hotel.name,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primaryNavy,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Foto de portada
            if (hotel.imageUrl != null && hotel.imageUrl!.isNotEmpty)
              Image.network(
                hotel.imageUrl!,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 240,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.hotel, size: 60, color: AppColors.primaryNavy),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre y Estrellas
                  Text(
                    hotel.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: List.generate(
                      hotel.stars,
                      (index) => const Icon(
                        Icons.star_rounded,
                        size: 20,
                        color: AppColors.bookingYellow,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Ubicación
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18, color: AppColors.accentBlue),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${hotel.address}, ${hotel.city}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Descripción
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hotel.description ?? 'Sin descripción disponible.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textDark,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tarjeta informativa de precio
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Precio por noche desde',
                              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                            ),
                            Text(
                              '1 habitación · 2 adultos',
                              style: TextStyle(fontSize: 12, color: AppColors.textDark),
                            ),
                          ],
                        ),
                        Text(
                          hotel.minPrice != null
                              ? '\$${hotel.minPrice!.toStringAsFixed(0)} MXN'
                              : 'Consultar',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('La selección de habitaciones vendra pronto.'),
                  backgroundColor: AppColors.primaryNavy,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Seleccionar habitación',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

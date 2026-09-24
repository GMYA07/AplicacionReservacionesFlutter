// lib/views/widgets/hotel_card.dart

import 'package:flutter/material.dart';
import '../../models/hotel_model.dart';
import '../../utils/app_colors.dart';

/// Tarjeta reutilizable de hotel inspirada en el diseño visual de Booking.com.
/// Muestra fotografía, valoración, estrellas, ubicación y precio por noche.
class HotelCard extends StatelessWidget {
  final HotelModel hotel;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool isFavorite;

  const HotelCard({
    super.key,
    required this.hotel,
    this.onTap,
    this.onFavoriteToggle,
    this.isFavorite = false,
  });

  /// Calcula una puntuación realista basada en las estrellas del hotel
  String _calculateRating(int stars) {
    switch (stars) {
      case 5:
        return '9.3';
      case 4:
        return '8.6';
      case 3:
        return '7.9';
      default:
        return '7.5';
    }
  }

  /// Calcula la etiqueta de reseña (ej. "Fantástico")
  String _calculateRatingLabel(int stars) {
    switch (stars) {
      case 5:
        return 'Excelente';
      case 4:
        return 'Muy bien';
      case 3:
        return 'Bueno';
      default:
        return 'Aceptable';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ratingScore = _calculateRating(hotel.stars);
    final ratingLabel = _calculateRatingLabel(hotel.stars);

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // 1. IMAGEN DE CABECERA CON CORAZÓN Y BADGES
              // ==========================================
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: hotel.imageUrl != null && hotel.imageUrl!.isNotEmpty
                          ? Image.network(
                              hotel.imageUrl!,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.accentBlue,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return _buildPlaceholderImage();
                              },
                            )
                          : _buildPlaceholderImage(),
                    ),
                  ),

                  // Botón de Favorito (Corazón)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onFavoriteToggle,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 20,
                            color: isFavorite ? AppColors.dangerRed : AppColors.textDark,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Badge de recomendación para hoteles de 5 estrellas
                  if (hotel.stars >= 5)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryNavy,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Destacado',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // ==========================================
              // 2. DETALLES Y VALORACIÓN
              // ==========================================
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fila: Nombre del hotel y Badge de Puntuación
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hotel.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              // Estrellas
                              Row(
                                children: List.generate(
                                  hotel.stars,
                                  (index) => const Icon(
                                    Icons.star_rounded,
                                    size: 16,
                                    color: AppColors.bookingYellow,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Badge de calificación estilo Booking (Verde)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              ratingLabel,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.ratingGreen,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: Text(
                                ratingScore,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Fila: Ubicación
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: AppColors.accentBlue,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${hotel.address}, ${hotel.city}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    // Breve descripción
                    if (hotel.description != null && hotel.description!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        hotel.description!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    const SizedBox(height: 10),
                    const Divider(height: 1),
                    const SizedBox(height: 10),

                    // Fila de Precio y Disponibilidad
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Cancelación gratis',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.ratingGreen,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '1 noche, 2 adultos',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (hotel.minPrice != null) ...[
                              Text(
                                '\$${hotel.minPrice!.toStringAsFixed(0)} MXN',
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryNavy,
                                ),
                              ),
                              const Text(
                                '+ impuestos y cargos',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ] else ...[
                              const Text(
                                'Consultar tarifa',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accentBlue,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Placeholder visual cuando la imagen no carga o no tiene conexión a internet
  Widget _buildPlaceholderImage() {
    return Container(
      color: const Color(0xFFE9EEF5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.hotel_rounded,
              size: 48,
              color: AppColors.primaryNavy,
            ),
            const SizedBox(height: 6),
            Text(
              hotel.name,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

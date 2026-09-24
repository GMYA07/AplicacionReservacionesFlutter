// lib/views/home/home_screen.dart

import 'package:flutter/material.dart';
import '../../models/hotel_model.dart';
import '../../models/user_model.dart';
import '../../services/hotel_service.dart';
import '../../utils/app_colors.dart';
import '../hotel_detail/hotel_detail_screen.dart';
import '../widgets/hotel_card.dart';
import 'widgets/guests_selection_modal.dart';
import 'widgets/user_profile_modal.dart';

/// Pantalla principal (Home) inspirada en la interfaz de Booking.com.
class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({
    super.key,
    required this.user,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Servicio para consultar y sembrar hoteles en SQLite
  final HotelService _hotelService = HotelService();

  // Controlador para el campo de búsqueda de destino
  final TextEditingController _destinationController = TextEditingController();

  // Fechas de reserva seleccionadas
  DateTimeRange? _selectedDateRange;

  // Contador de huéspedes y habitaciones
  int _rooms = 1;
  int _adults = 2;
  int _children = 0;

  // Estado de hoteles consultados desde SQLite
  List<HotelModel> _hotels = [];
  bool _isLoadingHotels = true;

  @override
  void initState() {
    super.initState();
    // Fechas por defecto: entrada mañana y salida en 3 días
    final now = DateTime.now();
    _selectedDateRange = DateTimeRange(
      start: now.add(const Duration(days: 1)),
      end: now.add(const Duration(days: 4)),
    );

    // Cargamos los hoteles desde SQLite al iniciar
    _loadHotels();
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  /// Consulta los hoteles disponibles desde la base de datos SQLite
  Future<void> _loadHotels({String? cityQuery}) async {
    setState(() {
      _isLoadingHotels = true;
    });

    try {
      final hotels = await _hotelService.getAvailableHotels(cityQuery: cityQuery);
      if (!mounted) return;
      setState(() {
        _hotels = hotels;
        _isLoadingHotels = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _hotels = [];
        _isLoadingHotels = false;
      });
    }
  }

  /// Formatea el rango de fechas para mostrarlo en el buscador
  String _formatDateRange(DateTimeRange? range) {
    if (range == null) return 'Selecciona las fechas';
    final months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    final start = range.start;
    final end = range.end;
    return '${start.day} ${months[start.month - 1]} - ${end.day} ${months[end.month - 1]}';
  }

  /// Muestra el selector nativo de rango de fechas
  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryNavy,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  /// Abre el modal modular de huéspedes y habitaciones
  Future<void> _openGuestsModal() async {
    final result = await GuestsSelectionModal.show(
      context,
      rooms: _rooms,
      adults: _adults,
      children: _children,
    );

    if (result != null) {
      setState(() {
        _rooms = result.rooms;
        _adults = result.adults;
        _children = result.children;
      });
    }
  }

  /// Abre el modal modular de perfil de usuario
  void _openUserProfileModal() {
    UserProfileModal.show(context, user: widget.user);
  }

  @override
  Widget build(BuildContext context) {
    final firstName = widget.user.name.split(' ').first;

    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.accentBlue,
          onRefresh: () => _loadHotels(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              // ==========================================
              // 1. CABECERA AZUL ESTILO BOOKING.COM
              // ==========================================
              Container(
                color: AppColors.primaryNavy,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fila superior: Logo + Nombre "Booking" e Identificador de Usuario
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Nombre y Logo de la app
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.hotel_rounded,
                                color: AppColors.primaryNavy,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Booking',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),

                        // Identificador de usuario (Avatar + Nombre interactivo)
                        InkWell(
                          onTap: _openUserProfileModal,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: AppColors.bookingYellow,
                                  child: Text(
                                    firstName.isNotEmpty
                                        ? firstName[0].toUpperCase()
                                        : 'U',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryNavy,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  firstName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Título y lema de bienvenida estilo Booking
                    const Text(
                      'Encuentra tu próximo alojamiento',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Busca ofertas en hoteles, apartamentos y mucho más',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),

              // ==========================================
              // 2. BUSCADOR ESTILO BOOKING (Borde Amarillo)
              // ==========================================
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.bookingYellow,
                      width: 4.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // 1. Campo de texto: Destino
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              color: AppColors.textDark,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _destinationController,
                                decoration: const InputDecoration(
                                  hintText: '¿A dónde vas?',
                                  hintStyle: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                ),
                                onSubmitted: (value) {
                                  _loadHotels(cityQuery: value.trim());
                                },
                              ),
                            ),
                            if (_destinationController.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _destinationController.clear();
                                  });
                                  _loadHotels();
                                },
                              ),
                          ],
                        ),
                      ),

                      const Divider(height: 1, color: AppColors.bookingYellow),

                      // 2. Selector de Fechas
                      InkWell(
                        onTap: _pickDateRange,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: AppColors.textDark,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _formatDateRange(_selectedDateRange),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Divider(height: 1, color: AppColors.bookingYellow),

                      // 3. Selector de Huéspedes y Habitaciones
                      InkWell(
                        onTap: _openGuestsModal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person_outline,
                                color: AppColors.textDark,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '$_rooms hab · ${_adults + _children} personas',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 4. Botón de búsqueda "Buscar"
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            final destination = _destinationController.text.trim();
                            _loadHotels(cityQuery: destination.isNotEmpty ? destination : null);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentBlue,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Buscar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ==========================================
              // 3. DESTINOS RÁPIDOS SUGERIDOS
              // ==========================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Destinos populares',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          'Cancún',
                          'Ciudad de México',
                          'Guadalajara',
                          'Monterrey',
                          'Playa del Carmen',
                        ].map((city) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ActionChip(
                              label: Text(city),
                              avatar: const Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: AppColors.primaryNavy,
                              ),
                              backgroundColor: Colors.white,
                              labelStyle: const TextStyle(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w500,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                  color: AppColors.borderLight,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _destinationController.text = city;
                                });
                                _loadHotels(cityQuery: city);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==========================================
              // 4. LISTADO DE TARJETAS DE HOTELES (SQLite)
              // ==========================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Alojamientos disponibles',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    if (!_isLoadingHotels && _hotels.isNotEmpty)
                      Text(
                        '${_hotels.length} encontrados',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Estado 1: Cargando datos de SQLite
              if (_isLoadingHotels)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: AppColors.accentBlue),
                        SizedBox(height: 12),
                        Text(
                          'Consultando alojamientos en la base de datos...',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
              // Estado 2: No hay hoteles en la base de datos o están desactivados
              else if (_hotels.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.hotel_class_outlined,
                          size: 56,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'No hay alojamientos disponibles',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _destinationController.text.isNotEmpty
                              ? 'No se encontraron hoteles disponibles en "${_destinationController.text}". Prueba buscando otra ciudad o destino.'
                              : 'No hay hoteles registrados o con habitaciones disponibles en la base de datos.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textMuted,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (_destinationController.text.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _destinationController.clear();
                              });
                              _loadHotels();
                            },
                            icon: const Icon(Icons.refresh, color: AppColors.accentBlue),
                            label: const Text(
                              'Ver todos los alojamientos',
                              style: TextStyle(
                                color: AppColors.accentBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                )
              // Estado 3: Lista de hoteles renderizados con HotelCard
              else
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: Column(
                    children: _hotels.map((hotel) {
                      return HotelCard(
                        hotel: hotel,
                        onTap: () {
                          // Navegación estática preparada hacia la vista de detalle
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HotelDetailScreen(hotel: hotel),
                            ),
                          );
                        },
                      );
                    }).toList(),
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

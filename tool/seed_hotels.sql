-- tool/seed_hotels.sql
-- Sentencias SQL para insertar hoteles y habitaciones de prueba

-- 1. Insertar hoteles
INSERT INTO hotels (name, description, address, city, stars, image_url) VALUES 
('Grand Fiesta Americana Coral Beach', 'Lujoso resort frente al mar con spa de clase mundial, múltiples albercas y vistas panorámicas al Caribe.', 'Blvd. Kukulcan Km. 9.5, Zona Hotelera', 'Cancún', 5, 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=800&q=80'),
('Barceló México Reforma', 'Elegante hotel céntrico ubicado sobre Paseo de la Reforma, ideal para viajes de negocios o placer.', 'Paseo de la Reforma 1, Tabacalera', 'Ciudad de México', 5, 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=800&q=80'),
('Hilton Guadalajara Midtown', 'Modernas instalaciones en la zona financiera, con piscina al aire libre en la azotea y alta gastronomía.', 'Av. Adolfo López Mateos Nte. 2405', 'Guadalajara', 4, 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?auto=format&fit=crop&w=800&q=80'),
('Live Aqua Urban Resort Monterrey', 'Experiencia sensorial exclusiva en Valle Oriente, con habitaciones de diseño y spa aromático.', 'Av. Lázaro Cárdenas 2424, Zona Loma Larga', 'Monterrey', 5, 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=800&q=80'),
('The Reef Coco Beach Resort', 'Alojamiento todo incluido en la Riviera Maya a pasos de la famosa Quinta Avenida.', 'Región 6, Manzana 7, Lote 1, Luis Donaldo Colosio', 'Playa del Carmen', 4, 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?auto=format&fit=crop&w=800&q=80');

-- 2. Insertar habitaciones para cada hotel
INSERT INTO rooms (hotel_id, room_type, price_per_night, capacity, is_available) VALUES
(1, 'Suite Vista al Mar', 2450.0, 2, 1),
(1, 'Habitación Doble Deluxe', 3100.0, 4, 1),
(2, 'Habitación Superior King', 1890.0, 2, 1),
(2, 'Habitación Doble Ejecutiva', 2250.0, 3, 1),
(3, 'Habitación Estándar Queen', 1350.0, 2, 1),
(3, 'Suite Junior', 1750.0, 3, 1),
(4, 'Habitación Aqua Deluxe', 2200.0, 2, 1),
(4, 'Master Suite Terraza', 2950.0, 2, 1),
(5, 'Habitación Superior Balcón', 1650.0, 2, 1),
(5, 'Villa Familiar Caribe', 2300.0, 4, 1);

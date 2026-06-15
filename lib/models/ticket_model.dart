class TicketModel {
  final String id;
  final String transportType;
  final String operatorName;
  final String from;
  final String to;
  final String date;
  final String departTime;
  final String arriveTime;
  final String duration;
  final String ticketClass;
  final int price;
  final int availableSeats;
  final String imageUrl;
  final int noKtp;

  TicketModel({
    required this.id,
    required this.transportType,
    required this.operatorName,
    required this.from,
    required this.to,
    required this.date,
    required this.departTime,
    required this.arriveTime,
    required this.duration,
    required this.ticketClass,
    required this.price,
    required this.availableSeats,
    this.imageUrl = '',
    this.noKtp = 0,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    final departAt = _readDateTime(json, ['waktu_pergi', 'departure_time']);
    final arriveAt = _readDateTime(json, ['waktu_tiba', 'arrival_time']);

    return TicketModel(
      id: _readString(json, ['id', 'ticket_id', 'kode']),
      transportType: _readString(json, [
        'transportType',
        'transport_type',
        'jenis_transportasi',
        'jenis',
      ]),
      operatorName: _readString(json, [
        'operatorName',
        'operator_name',
        'nama_operator',
        'nama_armada',
        'operator',
      ]),
      from: _readRoute(json, ['from', 'asal', 'kota_asal'], 'rute_asal'),
      to: _readRoute(json, ['to', 'tujuan', 'kota_tujuan'], 'rute_tujuan'),
      date: _readString(json, ['date', 'tanggal', 'tanggal_berangkat'])
          .ifEmpty(_formatDate(departAt)),
      departTime: _readString(json, [
        'departTime',
        'depart_time',
        'jam_berangkat',
      ]).ifEmpty(_formatTime(departAt)),
      arriveTime: _readString(
        json,
        ['arriveTime', 'arrive_time', 'jam_tiba'],
      ).ifEmpty(_formatTime(arriveAt)),
      duration: _readString(json, [
        'duration',
        'durasi',
        'durasi_perjalanan',
      ]),
      ticketClass: _readString(json, [
        'ticketClass',
        'ticket_class',
        'kelas',
        'kelas_tiket',
      ]),
      price: _readInt(json, ['price', 'harga']),
      availableSeats: _readInt(json, [
        'availableSeats',
        'available_seats',
        'sisa_kursi',
        'stok',
      ]),
      imageUrl: _readString(json, ['imageUrl', 'image_url', 'gambar_kendaraan']),
      noKtp: _readInt(json, ['noKtp', 'no_ktp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'jenis_transportasi': transportType,
      'nama_armada': operatorName,
      if (noKtp > 0) 'no_ktp': noKtp,
      'rute_asal': {'nama': from},
      'rute_tujuan': {'nama': to},
      'waktu_pergi': _toUnixTimestamp(date, departTime),
      'waktu_tiba': _toUnixTimestamp(date, arriveTime),
      'durasi_perjalanan': duration,
      'kelas': ticketClass,
      'harga': price,
      'sisa_kursi': availableSeats,
      if (imageUrl.isNotEmpty) 'gambar_kendaraan': imageUrl,
    };
  }

  TicketModel copyWith({
    String? id,
    String? transportType,
    String? operatorName,
    String? from,
    String? to,
    String? date,
    String? departTime,
    String? arriveTime,
    String? duration,
    String? ticketClass,
    int? price,
    int? availableSeats,
    String? imageUrl,
    int? noKtp,
  }) {
    return TicketModel(
      id: id ?? this.id,
      transportType: transportType ?? this.transportType,
      operatorName: operatorName ?? this.operatorName,
      from: from ?? this.from,
      to: to ?? this.to,
      date: date ?? this.date,
      departTime: departTime ?? this.departTime,
      arriveTime: arriveTime ?? this.arriveTime,
      duration: duration ?? this.duration,
      ticketClass: ticketClass ?? this.ticketClass,
      price: price ?? this.price,
      availableSeats: availableSeats ?? this.availableSeats,
      imageUrl: imageUrl ?? this.imageUrl,
      noKtp: noKtp ?? this.noKtp,
    );
  }

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) return value.toString();
    }
    return '';
  }

  static int _readInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static String _readRoute(
    Map<String, dynamic> json,
    List<String> directKeys,
    String routeKey,
  ) {
    final directValue = _readString(json, directKeys);
    if (directValue.isNotEmpty) return directValue;

    final route = json[routeKey];
    if (route is Map) {
      return _readString(Map<String, dynamic>.from(route), [
        'nama',
        'name',
        'nama_rute',
        'kota',
        'city',
        'terminal',
        'stasiun',
        'bandara',
        'alamat',
        'id',
      ]);
    }

    if (route != null) return route.toString();
    return '';
  }

  static DateTime? _readDateTime(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    final rawValue = _readInt(json, keys);
    if (rawValue == 0) return null;

    final milliseconds = rawValue > 9999999999 ? rawValue : rawValue * 1000;
    return DateTime.fromMillisecondsSinceEpoch(milliseconds).toLocal();
  }

  static String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return '';

    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '${dateTime.year}-$month-$day';
  }

  static String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour.$minute';
  }

  static int _toUnixTimestamp(String date, String time) {
    final dateParts = date.split('-');
    final timeParts = time.replaceAll(':', '.').split('.');

    if (dateParts.length != 3 || timeParts.length < 2) return 0;

    final year = int.tryParse(dateParts[0]);
    final month = int.tryParse(dateParts[1]);
    final day = int.tryParse(dateParts[2]);
    final hour = int.tryParse(timeParts[0]);
    final minute = int.tryParse(timeParts[1]);

    if ([year, month, day, hour, minute].contains(null)) return 0;

    final dateTime = DateTime(year!, month!, day!, hour!, minute!);
    return dateTime.millisecondsSinceEpoch ~/ 1000;
  }
}

extension _StringFallback on String {
  String ifEmpty(String fallback) {
    return isEmpty ? fallback : this;
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherModelAdapter extends TypeAdapter<WeatherModel> {
  @override
  final int typeId = 0;

  @override
  WeatherModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherModel(
      cityName: fields[0] as String,
      temperature: fields[1] as double,
      condition: fields[2] as String,
      icon: fields[3] as String,
      humidity: fields[4] as int,
      windSpeed: fields[5] as double,
      hourlyForecast: (fields[6] as List).cast<ForecastHourModel>(),
      dailyForecast: (fields[7] as List).cast<ForecastDayModel>(),
      lastUpdated: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.cityName)
      ..writeByte(1)
      ..write(obj.temperature)
      ..writeByte(2)
      ..write(obj.condition)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.humidity)
      ..writeByte(5)
      ..write(obj.windSpeed)
      ..writeByte(6)
      ..write(obj.hourlyForecast)
      ..writeByte(7)
      ..write(obj.dailyForecast)
      ..writeByte(8)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ForecastHourModelAdapter extends TypeAdapter<ForecastHourModel> {
  @override
  final int typeId = 1;

  @override
  ForecastHourModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ForecastHourModel(
      time: fields[0] as String,
      temperature: fields[1] as double,
      icon: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ForecastHourModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.temperature)
      ..writeByte(2)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForecastHourModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ForecastDayModelAdapter extends TypeAdapter<ForecastDayModel> {
  @override
  final int typeId = 2;

  @override
  ForecastDayModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ForecastDayModel(
      dayName: fields[0] as String,
      maxTemp: fields[1] as double,
      minTemp: fields[2] as double,
      condition: fields[3] as String,
      icon: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ForecastDayModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.dayName)
      ..writeByte(1)
      ..write(obj.maxTemp)
      ..writeByte(2)
      ..write(obj.minTemp)
      ..writeByte(3)
      ..write(obj.condition)
      ..writeByte(4)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForecastDayModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

enum TemperatureUnits { fahrenheit, celcius }

extension TemperatureUnitsX on TemperatureUnits {
  bool get isFahrenheit => this == TemperatureUnits.fahrenheit;
  bool get isCelcius => this == TemperatureUnits.celcius;
}

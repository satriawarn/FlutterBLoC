import 'package:flutter/material.dart';
import 'package:flutter_state_bloc/core/presentation/temperature_units.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({
    Key? key,
    required this.units,
  }) : super(key: key);

  final TemperatureUnits units;
  static Route<TemperatureUnits> route(TemperatureUnits units) {
    return MaterialPageRoute<TemperatureUnits>(
      builder: (_) => SettingPage(
        units: units,
      ),
    );
  }

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late TemperatureUnits units;

  @override
  void initState() {
    units = widget.units;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: ListView(
          children: [
            ListTile(
              title: const Text('Temperature Units'),
              isThreeLine: true,
              subtitle: const Text(
                'Use metric measurements for temperature units.',
              ),
              trailing: Switch(
                value: units.isCelcius,
                onChanged: (_) {
                  if (units.isCelcius) {
                    setState(() {
                      units = TemperatureUnits.fahrenheit;
                    });
                  } else {
                    setState(() {
                      units = TemperatureUnits.celcius;
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
      onWillPop: () async {
        Navigator.of(context).pop(units);
        return false;
      },
    );
  }
}

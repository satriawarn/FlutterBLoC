import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_state_bloc/core/network/network_status.dart';
import 'package:flutter_state_bloc/features/weather/domain/entities/weather.dart';
import 'package:flutter_state_bloc/features/weather/domain/repositories/weather_repository.dart';
import 'package:flutter_state_bloc/features/weather/domain/usecases/get_forecast_by_name.dart';
import 'package:flutter_state_bloc/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:flutter_state_bloc/features/weather/presentation/pages/searh_page.dart';
import 'package:flutter_state_bloc/features/weather/presentation/pages/setting_page.dart';
import 'package:flutter_state_bloc/features/weather/presentation/widgets/weather_empty.dart';
import 'package:flutter_state_bloc/features/weather/presentation/widgets/weather_error.dart';
import 'package:flutter_state_bloc/features/weather/presentation/widgets/weather_loading.dart';
import 'package:flutter_state_bloc/features/weather/presentation/widgets/weather_populated.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherRepo = context.read<WeatherRepository>();
    return BlocProvider(
      create: (context) => WeatherBloc(
        getForecastByName: GetForecastByName(
          weatherRepository: weatherRepo,
        ),
      ),
      child: const WeatherView(),
    );
  }
}

class WeatherView extends StatefulWidget {
  const WeatherView({Key? key}) : super(key: key);

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  late WeatherBloc _weatherBloc;

  @override
  void initState() {
    _weatherBloc = context.read<WeatherBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Weather'),
        actions: [
          IconButton(
            onPressed: () async {
              final units = await Navigator.of(context)
                  .push(SettingPage.route(_weatherBloc.state.units));
              if (units != null) {
                _weatherBloc.add(WeatherUnitChanged(units: units));
              }
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            switch (state.networkStatus) {
              case NetworkStatus.init:
                return const WeatherEmpty();
              case NetworkStatus.loading:
                return const WeatherLoading();
              case NetworkStatus.success:
                return WeatherPopulated(
                  weather: state.weather ??
                      Weather(
                        condition: WeatherCondition.clear,
                        lastUpdated: DateTime(1),
                        location: 'Unknown',
                        temperature: 0.0,
                      ),
                  units: state.units,
                );
              case NetworkStatus.failure:
              default:
                return const WeatherError();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final city = await Navigator.of(context).push(SearchPage.route());
          if (city != null) {
            _weatherBloc.add(WeatherSearched(keyword: city));
          }
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}

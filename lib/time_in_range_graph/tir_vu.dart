import 'package:flutter/material.dart';
import 'package:learning/time_in_range_graph/tir_vm.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
class TIRVU extends StackedView<TIRVM> {
  const TIRVU({super.key});

  @override
  Widget builder(BuildContext context, TIRVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: const Text('Time Range Graph')),
      body: Center(
        child: SfCartesianChart(
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          primaryXAxis: const CategoryAxis(isVisible: false),
          primaryYAxis: const NumericAxis(isVisible: false, minimum: 0, maximum: 100),
          plotAreaBorderWidth: 0,
          series: <CartesianSeries>[
            StackedColumn100Series<RegionData, String>(
              dataSource: viewModel.regionPercentages.where((e) => e.region == 'Below Range').toList(),
              xValueMapper: (_, _) => 'TIR',
              yValueMapper: (RegionData data, _) => data.percentage,
              name: 'Below Range',
              color: Colors.red,
              dataLabelMapper: (RegionData data, _) => '${data.percentage.toStringAsFixed(1)}%',
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            StackedColumn100Series<RegionData, String>(
              dataSource: viewModel.regionPercentages.where((e) => e.region == 'Target Range').toList(),
              xValueMapper: (_, _) => 'TIR',
              yValueMapper: (RegionData data, _) => data.percentage,
              name: 'Target Range',
              color: Colors.green,
              dataLabelMapper: (RegionData data, _) => '${data.percentage.toStringAsFixed(1)}%',
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            StackedColumn100Series<RegionData, String>(
              dataSource: viewModel.regionPercentages.where((e) => e.region == 'Above Range').toList(),
              xValueMapper: (_, _) => 'TIR',
              yValueMapper: (RegionData data, _) => data.percentage,
              name: 'Above Range',
              color: Colors.orange,
              dataLabelMapper: (RegionData data, _) => '${data.percentage.toStringAsFixed(1)}%',
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  TIRVM viewModelBuilder(BuildContext context) {
    return TIRVM();
  }
}

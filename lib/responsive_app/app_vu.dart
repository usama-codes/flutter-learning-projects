import 'package:flutter/material.dart';
import 'package:learning/responsive_app/app_vm.dart';
import 'package:stacked/stacked.dart';

class AppVU extends StackedView<AppVM> {
  const AppVU({super.key});

  @override
  Widget builder(BuildContext context, AppVM viewModel, Widget? child) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final w = constraints.maxWidth;
          const mobileWidth = 700.0;
          const maxTabletWidth = 1100.0;

          final isMobile = w < mobileWidth;
          final isTablet = w >= mobileWidth && w < maxTabletWidth;
          final topInset = MediaQuery.paddingOf(context).top;

          final horizontalPadding = isMobile ? 16.0 : 25.0;
          final topPadding = isMobile ? (topInset + 16.0) : 50.0;
          final titleSize = isMobile ? 22.0 : 30.0;
          final subtitleSize = isMobile ? 14.0 : 18.0;
          final imageWidth = isMobile
              ? w - (horizontalPadding * 2)
              : (isTablet ? 360.0 : 500.0);
          final imageHeight = isMobile ? 180.0 : 200.0;
          final bulbSize = isMobile ? 72.0 : 100.0;
          final bulbBoxHeight = isMobile ? 100.0 : 140.0;
          final fieldsSpacing = isMobile ? 12.0 : 20.0;

          return Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  topPadding,
                  horizontalPadding,
                  0,
                ),
                child: Column(
                  spacing: 20,
                  children: [
                    if (isMobile)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(
                                "https://strapi.dhiwise.com/uploads/crafting_a_captivating_flutter_splash_screen_igniting_visual_appealog_image_6535f1634dc09_80e4a43a6c.webp",
                                fit: BoxFit.cover,
                                height: imageHeight,
                                width: imageWidth,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "MASTER FLUTTER ON WEB",
                                style: TextStyle(
                                  fontSize: titleSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "- Advance Nested Layout",
                                style: TextStyle(fontSize: subtitleSize),
                              ),
                              Text(
                                "- Production Practices for web",
                                style: TextStyle(fontSize: subtitleSize),
                              ),
                              Text(
                                "- Complete guide on building forms",
                                style: TextStyle(fontSize: subtitleSize),
                              ),
                              Text(
                                "- Build a real-world example with Stacked",
                                style: TextStyle(fontSize: subtitleSize),
                              ),
                            ],
                          ),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "MASTER FLUTTER ON WEB",
                                  style: TextStyle(
                                    fontSize: titleSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "- Advance Nested Layout",
                                  style: TextStyle(fontSize: subtitleSize),
                                ),
                                Text(
                                  "- Production Practices for web",
                                  style: TextStyle(fontSize: subtitleSize),
                                ),
                                Text(
                                  "- Complete guide on building forms",
                                  style: TextStyle(fontSize: subtitleSize),
                                ),
                                Text(
                                  "- Build a real-world example with Stacked",
                                  style: TextStyle(fontSize: subtitleSize),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.transparent,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.network(
                                  "https://strapi.dhiwise.com/uploads/crafting_a_captivating_flutter_splash_screen_igniting_visual_appealog_image_6535f1634dc09_80e4a43a6c.webp",
                                  fit: BoxFit.cover,
                                  height: imageHeight,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: bulbBoxHeight,
                      child: Center(
                        child: IconButton(
                          onPressed: () => viewModel.showFields(),
                          icon: viewModel.isLightOn
                              ? Icon(
                                  Icons.lightbulb,
                                  color: Colors.yellow,
                                  size: bulbSize,
                                )
                              : Icon(Icons.lightbulb, size: bulbSize),
                        ),
                      ),
                    ),
                    if (viewModel.isLightOn)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (isMobile)
                            Column(
                              children: [
                                TextFormField(
                                  controller: viewModel.nameController,
                                  decoration: InputDecoration(
                                    labelText: "Write Name",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: fieldsSpacing),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: viewModel.ageController,
                                  decoration: InputDecoration(
                                    labelText: "Write age",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            )
                          else
                            Row(
                              spacing: fieldsSpacing,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: viewModel.nameController,
                                    decoration: InputDecoration(
                                      labelText: "Write Name",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: viewModel.ageController,
                                    decoration: InputDecoration(
                                      labelText: "Write age",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: isMobile ? 2 : 6),
                          if (isMobile)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Please fill the field",
                                  style: viewModel.isNameEmpty
                                      ? const TextStyle(color: Colors.red)
                                      : const TextStyle(
                                          color: Colors.transparent,
                                        ),
                                ),
                                Text(
                                  "Please fill the field",
                                  style: viewModel.isAgeEmpty
                                      ? const TextStyle(color: Colors.red)
                                      : const TextStyle(
                                          color: Colors.transparent,
                                        ),
                                ),
                              ],
                            )
                          else
                            Row(
                              spacing: fieldsSpacing,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Please fill the field",
                                    style: viewModel.isNameEmpty
                                        ? const TextStyle(color: Colors.red)
                                        : const TextStyle(
                                            color: Colors.transparent,
                                          ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Please fill the field",
                                    style: viewModel.isAgeEmpty
                                        ? const TextStyle(color: Colors.red)
                                        : const TextStyle(
                                            color: Colors.transparent,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: isMobile ? 0 : 12),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: isMobile ? 2 : 8.0,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: viewModel.save,
                                style: TextButton.styleFrom(
                                  minimumSize: const Size.fromHeight(44),
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text("Save"),
                              ),
                            ),
                          ),
                          SizedBox(height: 6),
                          if (viewModel.people.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: viewModel.people.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xFFD9D3DC),
                                      width: 1,
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    leading: Text(
                                      viewModel.people.keys.elementAt(index),
                                      style: TextStyle(
                                        fontSize: isMobile ? 14 : 12,
                                      ),
                                    ),
                                    trailing: Text(
                                      '${viewModel.people.values.elementAt(index)}',
                                      style: TextStyle(
                                        fontSize: isMobile ? 14 : 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  AppVM viewModelBuilder(BuildContext context) {
    return AppVM();
  }
}

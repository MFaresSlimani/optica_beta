
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheel_picker/wheel_picker.dart';


class GlassesController extends GetxController {
  RxString selectedType = 'Organique'.obs;
  RxDouble cylValue = 0.0.obs;
  RxDouble sphValue = 0.0.obs;

  void selectType(String type) {
    selectedType.value = type;
  }

  void incrementCyl() => cylValue.value += 0.5;

  void decrementCyl() => cylValue.value -= 0.5;

  void incrementSph() => sphValue.value += 0.5;

  void decrementSph() => sphValue.value -= 0.5;

  RxList glassesList = [].obs;

  void addGlassesToList() {
    final selectedType = this.selectedType.value;
    final cylValue = this.cylValue.value.toStringAsFixed(2);
    final sphValue = this.sphValue.value.toStringAsFixed(2);

    final glassesPair = '$selectedType, CYL: $cylValue, SPH: $sphValue';
    glassesList.add(glassesPair);
  }

  void removeGlassesFromList(int index) {
    glassesList.removeAt(index);
  }
}


class GlassesScreen extends StatelessWidget {
  final glassesController = Get.put(GlassesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50], // Beige background
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Type des Verres',
              textAlign: TextAlign.center,
            ),
            const Divider(),
            const SizedBox(height: 20),
            SizedBox(
              height: 70,
              child: ListViewWheel(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ValueBox(
                  title: 'CYL',
                  value: glassesController.cylValue,
                  onIncrement: () => glassesController.incrementCyl(),
                  onDecrement: () => glassesController.decrementCyl(),
                ),
                ValueBox(
                  title: 'SPH',
                  value: glassesController.sphValue,
                  onIncrement: () => glassesController.incrementSph(),
                  onDecrement: () => glassesController.decrementSph(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Selected Parameters:',
              style: GoogleFonts.abel(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Obx(
                  () => Text(
                '${glassesController.selectedType}, CYL: ${glassesController.cylValue.toStringAsFixed(2)}, SPH: ${glassesController.sphValue.toStringAsFixed(2)}',
                style: GoogleFonts.abel(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                glassesController.addGlassesToList();
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromHeight(50), // set a larger value for a taller button
                backgroundColor: Colors.brown, // set the background color to brown
              ),
              child: Text(
                'Add Glasses to List',
                style: GoogleFonts.abel(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // set the text color to white
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Box to display the list of glasses
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              height: 300, // Fixed height for the list view
              child: Obx(
                    () => ListView.builder(
                  itemCount: glassesController.glassesList.length,
                  itemBuilder: (context, index) {
                    final glassesPair = glassesController.glassesList[index];
                    return ListTile(
                      title: Text(glassesPair),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          glassesController.removeGlassesFromList(index);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ListViewWheel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8),
      children: [
        // Implement the list of glasses types here
        // Example:
        WheelItem(title: 'Reposantes'),
        const SizedBox(width: 10),
        WheelItem(title: 'Blue Bloque'),
        const SizedBox(width: 10),
        WheelItem(title: 'Medical'),
        const SizedBox(width: 10),
        WheelItem(title: 'Organique'),
        const SizedBox(width: 10),
      ],
    );
  }
}

class WheelItem extends StatelessWidget {
  final String title;

  WheelItem({required this.title});

  @override
  Widget build(BuildContext context) {
    final GlassesController glassesController = Get.find();

    return GestureDetector(
      onTap: () {
        glassesController.selectType(title);
      },
      child: Obx(
            () => Container(
          width: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: glassesController.selectedType.value == title
                ? Colors.brown // Change color when selected
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: GoogleFonts.abel(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: glassesController.selectedType.value == title
                  ? Colors.white // Change text color when selected
                  : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}



class ValueBox extends StatelessWidget {
  final String title;
  final RxDouble value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  ValueBox({
    required this.title,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.abel(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: WheelPicker(builder: (context, index) => Text(
            value.value.toStringAsFixed(2),
            style: GoogleFonts.abel(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          )),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CalibrateScreen extends StatefulWidget {
  const CalibrateScreen({super.key});
  @override
  State<CalibrateScreen> createState() => _CalibrateScreen();
}

class _CalibrateScreen extends State<CalibrateScreen> {
  int frequency = 5;
  List<TimeOfDay> scheduledTimes = [];
  List<String> toneList = ["Witty", "Professional", "Sarcastic", "Casual"];
  List<String> selectedToneList = [];

  final TextEditingController topicController = TextEditingController();
  final TextEditingController mustIncludeController = TextEditingController();
  final TextEditingController avoidController = TextEditingController();

  final FocusNode topicFocusNode = FocusNode();
  final FocusNode mustFocusNode = FocusNode();
  final FocusNode avoidFocusNode = FocusNode();

  String topic = "";
  String mustInclude = "";
  String avoid = "";

  @override
  void initState() {
    super.initState();
    topicFocusNode.addListener(() {
      if (!topicFocusNode.hasFocus) handleFieldSave(topicController, "topic");
    });
    mustFocusNode.addListener(() {
      if (!mustFocusNode.hasFocus)
        handleFieldSave(mustIncludeController, "must");
    });
    avoidFocusNode.addListener(() {
      if (!avoidFocusNode.hasFocus) handleFieldSave(avoidController, "avoid");
    });
  }

  @override
  void dispose() {
    topicController.dispose();
    mustIncludeController.dispose();
    avoidController.dispose();
    topicFocusNode.dispose();
    mustFocusNode.dispose();
    avoidFocusNode.dispose();
    super.dispose();
  }

  void _pickTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: now);
    if (!mounted || picked == null) return;

    if (scheduledTimes.length >= frequency) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Maximum tasks scheduled.")));
      return;
    }

    bool isValidTime =
        picked.hour > now.hour ||
        (picked.hour == now.hour && picked.minute > now.minute);

    if (!isValidTime) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please select a future time.")));
      return;
    }

    if (!scheduledTimes.contains(picked)) {
      setState(() => scheduledTimes.add(picked));
    }
  }

  void handleFieldSave(TextEditingController controller, String field) {
    String input = controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      if (field == "topic") topic = input;
      if (field == "must") mustInclude = input;
      if (field == "avoid") avoid = input;
    });
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  bool allFieldsFilled() {
    return topic.isNotEmpty &&
        mustInclude.isNotEmpty &&
        avoid.isNotEmpty &&
        scheduledTimes.isNotEmpty &&
        selectedToneList.isNotEmpty;
  }

  String buildPrompt() {
    final times = scheduledTimes.map(_formatTime).join(", ");
    final tone = selectedToneList.join(", ");
    return "Generate tweets $frequency times a day at $times about $topic "
        "with a $tone tone, using keywords/hashtags $mustInclude. "
        "Avoid content related to $avoid.";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Calibrate Posting"),
          elevation: 4,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Center(
                //   child: Text(
                //     "Calibrate Posting",
                //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                //   ),
                // ),
                _postFrequency(),
                _scheduleTimes(),
                _labelInput(
                  "Post Topic",
                  "e.g. Talk about space tech and AI",
                  LucideIcons.brain,
                  topicController,
                  "topic",
                  topicFocusNode,
                ),
                _toneWidget(),
                _labelInput(
                  "Must Include",
                  "#AI, #ChatGPT",
                  LucideIcons.hash,
                  mustIncludeController,
                  "must",
                  mustFocusNode,
                ),
                _labelInput(
                  "Avoid These",
                  "e.g. politics, controversy",
                  LucideIcons.alertTriangle,
                  avoidController,
                  "avoid",
                  avoidFocusNode,
                ),
                if (allFieldsFilled())
                  _previewSection()
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      "⚠️ Fill in all fields and select times and tone to see preview.",
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                _generateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _postFrequency() {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Post Frequency",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Posts per day"), Text("$frequency")],
          ),
          Slider(
            value: frequency.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            label: "$frequency",
            activeColor: Colors.blue,
            onChanged: (value) => setState(() => frequency = value.toInt()),
          ),
        ],
      ),
    );
  }

  Widget _scheduleTimes() {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Schedule Times",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: scheduledTimes
                .map(
                  (time) => Chip(
                    label: Text(_formatTime(time)),
                    onDeleted: () =>
                        setState(() => scheduledTimes.remove(time)),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 10),
          TextButton.icon(
            onPressed: _pickTime,
            icon: Icon(FeatherIcons.clock),
            label: Text("Add Time"),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toneWidget() {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tone",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: toneList.map((tone) {
              final isSelected = selectedToneList.contains(tone);
              return FilterChip(
                label: Text(
                  tone,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedToneList.add(tone);
                    } else {
                      selectedToneList.remove(tone);
                    }
                  });
                },
                checkmarkColor: Colors.white,
                selectedColor: Colors.blue,
                backgroundColor: Colors.grey.shade200,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _labelInput(
    String label,
    String hint,
    IconData icon,
    TextEditingController controller,
    String field,
    FocusNode focusNode,
  ) {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: hint,
              suffixIcon: IconButton(
                icon: Icon(icon),
                onPressed: () => handleFieldSave(controller, field),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewSection() {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "AI Prompt Preview",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(buildPrompt(), style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _generateButton() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: Icon(LucideIcons.sparkles),
          label: Text("Save & Generate"),
          onPressed: allFieldsFilled()
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("AI Prompt Generated ✅")),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade400,
            disabledForegroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _sectionContainer({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(24),
      width: double.infinity,
      child: child,
    );
  }
}

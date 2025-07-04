import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedModel = 'GPT-3.5 Turbo';
  final List<String> models = ['GPT-3.5 Turbo', 'Grok'];
  bool darkMode = false;

  final TextEditingController gptController = TextEditingController();
  final TextEditingController grokController = TextEditingController();

  @override
  void dispose() {
    gptController.dispose();
    grokController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          width > 500 ? width * 0.2 : 20,
          16,
          width > 500 ? width * 0.2 : 20,
          16 +
              MediaQuery.of(context).padding.bottom +
              kBottomNavigationBarHeight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI Model',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Model', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedModel,
                  items: models
                      .map(
                        (model) => DropdownMenuItem(
                          value: model,
                          child: Text(
                            model,
                            style: const TextStyle(color: Color(0xFF1A73E8)),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedModel = val!;
                    });
                  },
                  underline: const SizedBox(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (selectedModel == 'GPT-3.5 Turbo')
              _apiKeyField('GPT API Key', gptController)
            else
              _apiKeyField('Grok API Key', grokController),
            const SizedBox(height: 24),
            const Text(
              'Twitter',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            _settingsTile(
              'Disconnect Twitter',
              Icons.arrow_forward_ios,
              onTap: () {},
            ),
            const SizedBox(height: 24),
            const Text(
              'App',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            _switchTile('Dark Mode', darkMode, (val) {
              setState(() {
                darkMode = val;
              });
            }),
            _settingsTile(
              'Clear Tweet History',
              Icons.arrow_forward_ios,
              onTap: () {},
            ),
            _settingsTile(
              'Privacy Policy',
              Icons.arrow_forward_ios,
              onTap: () {},
            ),
            const SizedBox(height: 24),
            _upgradeSection(width),
            const SizedBox(height: 24),
            const Text(
              'Info',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Version', style: TextStyle(fontSize: 16)),
                Text('1.0.0', style: TextStyle(fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _apiKeyField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 15)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                obscureText: true,
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Enter your secret key',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFDFE3E8)),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: () {
                      // TODO: Copy to clipboard
                    },
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Enter your secret key',
          style: TextStyle(color: Color(0xFF1A73E8), fontSize: 13),
        ),
      ],
    );
  }

  Widget _settingsTile(String label, IconData icon, {VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontSize: 16)),
      trailing: Icon(icon, size: 18, color: Colors.grey[500]),
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _switchTile(String label, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontSize: 16)),
      trailing: Switch(value: value, onChanged: onChanged),
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _upgradeSection(double width) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upgrade to Pro',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 4),
          const Text(
            'Unlock unlimited tweets.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Upgrade to Pro to unlock unlimited tweets and more.',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/upgrade_pro.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A73E8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Upgrade',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

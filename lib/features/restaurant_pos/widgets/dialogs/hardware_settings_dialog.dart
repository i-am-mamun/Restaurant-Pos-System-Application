import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────
// HARDWARE SETTINGS DIALOG
// POS Hardware integration UI:
//  🖨️ Thermal Receipt Printer (Bluetooth / USB / Network)
//  💵 Cash Drawer             (USB / RJ11)
//  🔍 Barcode Scanner         (USB / Bluetooth / Camera)
//  🍳 Kitchen Printer         (Network IP)
//  💳 Card Terminal           (Bluetooth / USB / Network)
//  📺 Customer Display        (USB / HDMI / Network)
// ─────────────────────────────────────────────────────────────────

class HardwareSettingsDialog extends StatefulWidget {
  const HardwareSettingsDialog({super.key});

  @override
  State<HardwareSettingsDialog> createState() => _HardwareSettingsDialogState();
}

class _HardwareSettingsDialogState extends State<HardwareSettingsDialog> {
  static const primaryOrange = Color(0xFFFF6D00);

  // Thermal Printer
  bool _printerEnabled = false;
  String _printerConnection = 'Bluetooth';
  String _printerStatus = 'Not Connected';

  // Cash Drawer
  bool _drawerEnabled = false;
  String _drawerConnection = 'USB';

  // Barcode Scanner
  bool _scannerEnabled = false;
  String _scannerConnection = 'USB';

  // Kitchen Printer
  bool _kitchenEnabled = false;
  String _kitchenIp = '192.168.1.100';

  // Card Terminal
  bool _cardEnabled = false;
  String _cardConnection = 'Bluetooth';

  // Customer Display
  bool _displayEnabled = false;
  String _displayConnection = 'USB';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.settings_input_composite_rounded, color: primaryOrange),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Hardware Settings',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 480,
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),

              // 1. Thermal Receipt Printer
              _HardwareTile(
                icon: Icons.print_rounded,
                label: 'Thermal Receipt Printer',
                badge: '🖨️',
                statusText: _printerEnabled ? _printerStatus : 'Disabled',
                statusColor: _printerEnabled
                    ? (_printerStatus == 'Connected' ? Colors.green : Colors.orange)
                    : Colors.grey,
                enabled: _printerEnabled,
                onToggle: (v) => setState(() => _printerEnabled = v),
                connectionOptions: const ['Bluetooth', 'USB', 'Network'],
                selectedConnection: _printerConnection,
                onConnectionChanged: (v) => setState(() => _printerConnection = v!),
                onTest: () {
                  setState(() => _printerStatus = 'Connected');
                  _snack(context, '🖨️ Test print sent to thermal printer');
                },
              ),
              const Divider(height: 28),

              // 2. Cash Drawer
              _HardwareTile(
                icon: Icons.point_of_sale_rounded,
                label: 'Cash Drawer',
                badge: '💵',
                statusText: _drawerEnabled ? 'Ready to trigger' : 'Disabled',
                statusColor: _drawerEnabled ? Colors.green : Colors.grey,
                enabled: _drawerEnabled,
                onToggle: (v) => setState(() => _drawerEnabled = v),
                connectionOptions: const ['USB', 'RJ11 (via Printer)'],
                selectedConnection: _drawerConnection,
                onConnectionChanged: (v) => setState(() => _drawerConnection = v!),
                onTest: () => _snack(context, '💵 Cash drawer open signal sent'),
              ),
              const Divider(height: 28),

              // 3. Barcode Scanner
              _HardwareTile(
                icon: Icons.qr_code_scanner_rounded,
                label: 'Barcode Scanner',
                badge: '🔍',
                statusText: _scannerEnabled ? 'Listening for scans' : 'Disabled',
                statusColor: _scannerEnabled ? Colors.green : Colors.grey,
                enabled: _scannerEnabled,
                onToggle: (v) => setState(() => _scannerEnabled = v),
                connectionOptions: const ['USB', 'Bluetooth', 'Camera'],
                selectedConnection: _scannerConnection,
                onConnectionChanged: (v) => setState(() => _scannerConnection = v!),
                onTest: () => _snack(context, '🔍 Scan a barcode to test scanner'),
              ),
              const Divider(height: 28),

              // 4. Kitchen Printer (Network IP)
              _KitchenPrinterTile(
                enabled: _kitchenEnabled,
                ipAddress: _kitchenIp,
                onToggle: (v) => setState(() => _kitchenEnabled = v),
                onIpChanged: (v) => setState(() => _kitchenIp = v),
                onTest: () => _snack(context, '🍳 Test print sent to kitchen printer'),
              ),
              const Divider(height: 28),

              // 5. Card Terminal
              _HardwareTile(
                icon: Icons.credit_card_rounded,
                label: 'Card Terminal',
                badge: '💳',
                statusText: _cardEnabled ? 'Ready for payment' : 'Disabled',
                statusColor: _cardEnabled ? Colors.green : Colors.grey,
                enabled: _cardEnabled,
                onToggle: (v) => setState(() => _cardEnabled = v),
                connectionOptions: const ['Bluetooth', 'USB', 'Network'],
                selectedConnection: _cardConnection,
                onConnectionChanged: (v) => setState(() => _cardConnection = v!),
                onTest: () => _snack(context, '💳 Card terminal ping sent'),
              ),
              const Divider(height: 28),

              // 6. Customer Display
              _HardwareTile(
                icon: Icons.tv_rounded,
                label: 'Customer Display',
                badge: '📺',
                statusText: _displayEnabled ? 'Showing customer view' : 'Disabled',
                statusColor: _displayEnabled ? Colors.green : Colors.grey,
                enabled: _displayEnabled,
                onToggle: (v) => setState(() => _displayEnabled = v),
                connectionOptions: const ['USB', 'HDMI', 'Network'],
                selectedConnection: _displayConnection,
                onConnectionChanged: (v) => setState(() => _displayConnection = v!),
                onTest: () => _snack(context, '📺 Customer display test sent'),
              ),

              const SizedBox(height: 16),

              // Info note
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, size: 18, color: Colors.blue.shade700),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Full hardware activation requires SDK/driver integration. '
                        'UI is ready — connect ESC/POS, Bluetooth or USB packages in the backend to activate.',
                        style: TextStyle(fontSize: 11, color: Colors.blue.shade800),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            _snack(context, '✅ Hardware settings saved');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Icon(Icons.save_rounded, size: 18),
          label: const Text('Save Settings'),
        ),
      ],
    );
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: primaryOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ── Generic Hardware Tile ──────────────────────────────────────
class _HardwareTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String badge;
  final String statusText;
  final Color statusColor;
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final List<String> connectionOptions;
  final String selectedConnection;
  final ValueChanged<String?> onConnectionChanged;
  final VoidCallback onTest;

  static const primaryOrange = Color(0xFFFF6D00);

  const _HardwareTile({
    required this.icon,
    required this.label,
    required this.badge,
    required this.statusText,
    required this.statusColor,
    required this.enabled,
    required this.onToggle,
    required this.connectionOptions,
    required this.selectedConnection,
    required this.onConnectionChanged,
    required this.onTest,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: enabled ? primaryOrange.withOpacity(0.1) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 20, color: enabled ? primaryOrange : Colors.grey.shade400),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$badge  $label',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 5),
                      Text(statusText, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
            ),
            Switch(value: enabled, onChanged: onToggle, activeColor: primaryOrange),
          ],
        ),
        if (enabled) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedConnection,
                  isDense: true,
                  decoration: InputDecoration(
                    labelText: 'Connection type',
                    labelStyle: const TextStyle(fontSize: 12),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: primaryOrange),
                    ),
                  ),
                  items: connectionOptions
                      .map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontSize: 13))))
                      .toList(),
                  onChanged: onConnectionChanged,
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onTest,
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryOrange,
                  side: const BorderSide(color: primaryOrange),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                icon: const Icon(Icons.cable_rounded, size: 15),
                label: const Text('Test', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// ── Kitchen Printer Tile (Network IP input) ────────────────────
class _KitchenPrinterTile extends StatelessWidget {
  final bool enabled;
  final String ipAddress;
  final ValueChanged<bool> onToggle;
  final ValueChanged<String> onIpChanged;
  final VoidCallback onTest;

  static const primaryOrange = Color(0xFFFF6D00);

  const _KitchenPrinterTile({
    required this.enabled,
    required this.ipAddress,
    required this.onToggle,
    required this.onIpChanged,
    required this.onTest,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: enabled ? primaryOrange.withOpacity(0.1) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(Icons.kitchen_rounded, size: 20, color: enabled ? primaryOrange : Colors.grey.shade400),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🍳  Kitchen Printer', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: enabled ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        enabled ? 'Network · $ipAddress' : 'Disabled',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Switch(value: enabled, onChanged: onToggle, activeColor: primaryOrange),
          ],
        ),
        if (enabled) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: ipAddress,
                  keyboardType: TextInputType.number,
                  onChanged: onIpChanged,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Printer IP Address',
                    labelStyle: const TextStyle(fontSize: 12),
                    hintText: '192.168.1.100',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: primaryOrange),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onTest,
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryOrange,
                  side: const BorderSide(color: primaryOrange),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                icon: const Icon(Icons.cable_rounded, size: 15),
                label: const Text('Test', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

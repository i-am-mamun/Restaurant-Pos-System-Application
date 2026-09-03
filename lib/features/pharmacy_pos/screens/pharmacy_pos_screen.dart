import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_extensions.dart';
import '../providers/pharmacy_provider.dart';

import '../widgets/pharmacy_header.dart';
import '../widgets/category_selector.dart';
import '../widgets/medicine_grid.dart';
import '../widgets/dashboard_alerts.dart';
import '../widgets/quick_actions_bar.dart';
import '../widgets/pharmacy_cart_panel.dart';
import '../widgets/pharmacy_footer.dart';

class PharmacyPOSScreen extends StatefulWidget {
  const PharmacyPOSScreen({super.key});

  @override
  State<PharmacyPOSScreen> createState() => _PharmacyPOSScreenState();
}

class _PharmacyPOSScreenState extends State<PharmacyPOSScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PharmacyProvider(),
      child: Scaffold(
        backgroundColor: context.scaffoldBg,
        body: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left Side: Products & Actions
                  Expanded(
                    flex: 7,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(8, 6, 4, 6),
                      decoration: BoxDecoration(
                        color: context.isDark ? context.cardBg : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          if (!context.isDark)
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: const Column(
                        children: [
                          PharmacyHeader(),
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(height: 6),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                                  child: CategorySelector(),
                                ),
                                SizedBox(height: 8),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                                    child: MedicineGrid(),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                                  child: DashboardAlerts(),
                                ),
                                SizedBox(height: 8),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                                  child: QuickActionsBar(),
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Right Side: Cart Panel
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(4, 6, 8, 6),
                      child: const PharmacyCartPanel(),
                    ),
                  ),
                ],
              ),
            ),
            const PharmacyFooter(),
          ],
        ),
      ),
    );
  }
}

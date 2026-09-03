import 'package:flutter/material.dart';
import '../../../core/theme/theme_extensions.dart';

class PharmacyHeader extends StatelessWidget {
  const PharmacyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF009688), // Teal color from image
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 28, weight: 800),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'MediCare',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: context.isDark ? Colors.white : const Color(0xFF009688),
                    ),
                  ),
                  Text(
                    'Pharmacy',
                    style: TextStyle(
                      fontSize: 12,
                      color: context.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(width: 64),
          
          // Search Bar
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: context.isDark ? context.scaffoldBg : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(
                  color: context.isDark ? context.dividerColor : Colors.grey.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, color: context.textSecondary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search medicine by name, brand or barcode...',
                        hintStyle: TextStyle(
                          color: context.textHint,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  Icon(Icons.qr_code_scanner_rounded, color: context.textSecondary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solut/pages/home/widgets/home_screen.dart';

import '../../shared/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.mutedTeal,
        body: HomeScreen()
    );
    }
}
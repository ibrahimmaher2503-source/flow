import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Cairo',
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        // ─────────────────────────────────────────────────────────────────────
        // PRIMARY
        // ─────────────────────────────────────────────────────────────────────
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightOnPrimary,
        primaryContainer: AppColors.lightPrimaryContainer,
        onPrimaryContainer: AppColors.lightOnPrimaryContainer,

        // ─────────────────────────────────────────────────────────────────────
        // SECONDARY
        // ─────────────────────────────────────────────────────────────────────
        secondary: AppColors.lightSecondary,
        onSecondary: AppColors.lightOnSecondary,
        secondaryContainer: AppColors.lightSecondaryContainer,
        onSecondaryContainer: AppColors.lightOnSecondaryContainer,

        // ─────────────────────────────────────────────────────────────────────
        // TERTIARY
        // ─────────────────────────────────────────────────────────────────────
        tertiary: AppColors.lightAccent,
        onTertiary: AppColors.lightOnAccent,
        tertiaryContainer: AppColors.lightAccentContainer,
        onTertiaryContainer: AppColors.lightOnAccentContainer,

        // ─────────────────────────────────────────────────────────────────────
        // SURFACE CONTAINERS
        // ─────────────────────────────────────────────────────────────────────
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,
        onSurfaceVariant: AppColors.lightTextSecondary,
        surfaceContainerLowest: AppColors.lightSurfaceContainerLowest,
        surfaceContainerLow: AppColors.lightSurfaceContainerLow,
        surfaceContainer: AppColors.lightSurfaceContainer,
        surfaceContainerHigh: AppColors.lightSurfaceContainerHigh,
        surfaceContainerHighest: AppColors.lightSurfaceContainerHighest,
        surfaceDim: AppColors.lightBackgroundSecondary,
        surfaceBright: AppColors.lightSurface,

        // ─────────────────────────────────────────────────────────────────────
        // ERROR
        // ─────────────────────────────────────────────────────────────────────
        error: AppColors.lightDanger,
        onError: AppColors.lightOnDanger,
        errorContainer: AppColors.lightDangerContainer,
        onErrorContainer: AppColors.lightOnDangerContainer,

        // ─────────────────────────────────────────────────────────────────────
        // OUTLINE & UTILITY
        // ─────────────────────────────────────────────────────────────────────
        outline: AppColors.lightBorder,
        outlineVariant: AppColors.lightBorderVariant,
        shadow: AppColors.lightShadow,
        scrim: AppColors.lightShadowStrong,
        inverseSurface: AppColors.lightTextPrimary,
        onInverseSurface: AppColors.lightSurface,
        inversePrimary: AppColors.lightPrimaryContainer,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.lightTextPrimary,
          letterSpacing: 0,
        ),
        iconTheme: IconThemeData(
          color: AppColors.lightTextSecondary,
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: AppColors.lightTextSecondary,
          size: 24,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.lightSurfaceContainerLow,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightSurfaceContainerLow,
        selectedItemColor: AppColors.lightPrimary,
        unselectedItemColor: AppColors.lightTextMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurfaceContainerLow,
        indicatorColor: AppColors.lightPrimaryContainer,
        elevation: 0,
        height: 80,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.lightPrimary,
            );
          }
          return const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.lightTextMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.lightPrimary,
              size: 24,
            );
          }
          return const IconThemeData(
            color: AppColors.lightTextMuted,
            size: 24,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: AppColors.lightShadowMedium,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppColors.lightBorderVariant,
            width: 0.5,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightPrimaryContainer,
        foregroundColor: AppColors.lightOnPrimaryContainer,
        elevation: 3,
        focusElevation: 4,
        hoverElevation: 4,
        highlightElevation: 2,
        splashColor: AppColors.lightPrimary.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.lightBorderVariant,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.lightPrimary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.lightDanger,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.lightDanger,
            width: 2,
          ),
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.lightTextMuted,
          fontSize: 16,
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.lightTextSecondary,
          fontSize: 16,
        ),
        floatingLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.lightPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        isDense: false,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightSurfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 6,
        shadowColor: AppColors.lightShadowStrong,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        titleTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextPrimary,
          letterSpacing: 0,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextSecondary,
          height: 1.43,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightSurfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        modalElevation: 1,
        shadowColor: AppColors.lightShadowMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        dragHandleColor: AppColors.lightBorderVariant,
        dragHandleSize: Size(32, 4),
        showDragHandle: true,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightTextPrimary,
        contentTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.lightSurface,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        actionTextColor: AppColors.lightPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSurfaceContainerLow,
        selectedColor: AppColors.lightPrimaryContainer,
        disabledColor: AppColors.lightSurfaceContainerHighest,
        surfaceTintColor: Colors.transparent,
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.lightTextSecondary,
          letterSpacing: 0.1,
        ),
        secondaryLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.lightOnPrimaryContainer,
          letterSpacing: 0.1,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.lightBorderVariant),
        ),
        showCheckmark: true,
        checkmarkColor: AppColors.lightOnPrimaryContainer,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.lightTextSecondary,
        size: 24,
      ),
      primaryIconTheme: const IconThemeData(
        color: AppColors.lightPrimary,
        size: 24,
      ),
      // ─────────────────────────────────────────────────────────────────────────
      // M3 TYPOGRAPHY SCALE
      // ─────────────────────────────────────────────────────────────────────────
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextPrimary,
          letterSpacing: -0.25,
          height: 1.12,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextPrimary,
          letterSpacing: 0,
          height: 1.16,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextPrimary,
          letterSpacing: 0,
          height: 1.22,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 32,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextPrimary,
          letterSpacing: 0,
          height: 1.25,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextPrimary,
          letterSpacing: 0,
          height: 1.29,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextPrimary,
          letterSpacing: 0,
          height: 1.33,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextPrimary,
          letterSpacing: 0,
          height: 1.27,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.lightTextPrimary,
          letterSpacing: 0.15,
          height: 1.5,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.lightTextPrimary,
          letterSpacing: 0.1,
          height: 1.43,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextPrimary,
          letterSpacing: 0.5,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextSecondary,
          letterSpacing: 0.25,
          height: 1.43,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextMuted,
          letterSpacing: 0.4,
          height: 1.33,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.lightTextPrimary,
          letterSpacing: 0.1,
          height: 1.43,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.lightTextSecondary,
          letterSpacing: 0.5,
          height: 1.33,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.lightTextMuted,
          letterSpacing: 0.5,
          height: 1.45,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightOnPrimary,
          disabledBackgroundColor: AppColors.lightSurfaceContainerHighest,
          disabledForegroundColor: AppColors.lightTextDisabled,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          minimumSize: const Size(48, 40),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightSurfaceContainerLow,
          foregroundColor: AppColors.lightPrimary,
          disabledBackgroundColor: AppColors.lightSurfaceContainerHighest,
          disabledForegroundColor: AppColors.lightTextDisabled,
          elevation: 1,
          shadowColor: AppColors.lightShadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          minimumSize: const Size(48, 40),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightPrimary,
          disabledForegroundColor: AppColors.lightTextDisabled,
          side: const BorderSide(color: AppColors.lightBorderVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          minimumSize: const Size(48, 40),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.lightSurfaceContainerHighest;
          }
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightOnPrimary;
          }
          return AppColors.lightBorderVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.lightSurfaceContainerHighest;
          }
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightPrimary;
          }
          return AppColors.lightSurfaceContainerHighest;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return AppColors.lightBorderVariant;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.lightSurfaceContainerHighest;
          }
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightPrimary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.lightOnPrimary),
        side: const BorderSide(color: AppColors.lightBorder, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.lightSurfaceContainerHighest;
          }
          if (states.contains(WidgetState.selected)) {
            return AppColors.lightPrimary;
          }
          return AppColors.lightBorder;
        }),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.lightPrimary,
        linearTrackColor: AppColors.lightPrimaryContainer,
        circularTrackColor: AppColors.lightPrimaryContainer,
        linearMinHeight: 4,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.lightPrimary,
        inactiveTrackColor: AppColors.lightPrimaryContainer,
        thumbColor: AppColors.lightPrimary,
        overlayColor: AppColors.lightPrimary.withValues(alpha: 0.08),
        valueIndicatorColor: AppColors.lightPrimary,
        valueIndicatorTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.lightOnPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.lightPrimary,
        unselectedLabelColor: AppColors.lightTextSecondary,
        indicatorColor: AppColors.lightPrimary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: AppColors.lightBorderVariant,
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          return AppColors.lightPrimary.withValues(alpha: 0.08);
        }),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minVerticalPadding: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextPrimary,
          letterSpacing: 0.5,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextSecondary,
          letterSpacing: 0.25,
        ),
        leadingAndTrailingTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.lightTextSecondary,
        ),
        iconColor: AppColors.lightTextSecondary,
        textColor: AppColors.lightTextPrimary,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.lightPrimaryContainer;
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.lightOnPrimaryContainer;
            }
            return AppColors.lightTextPrimary;
          }),
          side: WidgetStateProperty.all(
            const BorderSide(color: AppColors.lightBorderVariant),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          textStyle: WidgetStateProperty.all(const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          )),
        ),
      ),
      searchBarTheme: SearchBarThemeData(
        backgroundColor:
        WidgetStateProperty.all(AppColors.lightSurfaceContainerHigh),
        surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        hintStyle: WidgetStateProperty.all(const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextMuted,
        )),
        textStyle: WidgetStateProperty.all(const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextPrimary,
        )),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.lightTextPrimary,
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.lightSurface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        waitDuration: const Duration(milliseconds: 500),
      ),
      badgeTheme: const BadgeThemeData(
        backgroundColor: AppColors.lightDanger,
        textColor: AppColors.lightOnDanger,
        smallSize: 6,
        largeSize: 16,
        textStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.lightSurfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        shadowColor: AppColors.lightShadowMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextPrimary,
        ),
        labelTextStyle: WidgetStateProperty.all(const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.lightTextPrimary,
        )),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.lightSurfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Cairo',
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.dark(
        // ─────────────────────────────────────────────────────────────────────
        // PRIMARY
        // ─────────────────────────────────────────────────────────────────────
        primary: AppColors.primary,
        onPrimary: const Color(0xFF120F26),
        primaryContainer: const Color(0xFF2A244C),
        onPrimaryContainer: const Color(0xFFE7E1F4),

        // ─────────────────────────────────────────────────────────────────────
        // SECONDARY
        // ─────────────────────────────────────────────────────────────────────
        secondary: AppColors.secondary,
        onSecondary: const Color(0xFF00201D),
        secondaryContainer: const Color(0xFF005048),
        onSecondaryContainer: const Color(0xFF74F8E8),

        // ─────────────────────────────────────────────────────────────────────
        // TERTIARY
        // ─────────────────────────────────────────────────────────────────────
        tertiary: AppColors.accent,
        onTertiary: const Color(0xFF422C00),
        tertiaryContainer: const Color(0xFF5F4100),
        onTertiaryContainer: const Color(0xFFFFDDB3),

        // ─────────────────────────────────────────────────────────────────────
        // SURFACE CONTAINERS (Dark palette)
        // ─────────────────────────────────────────────────────────────────────
        surface: AppColors.surface,
        onSurface: Colors.white,
        onSurfaceVariant: AppColors.textSecondary,
        surfaceContainerLowest: const Color(0xFF120F26),
        surfaceContainerLow: const Color(0xFF17132E),
        surfaceContainer: const Color(0xFF1A1531),
        surfaceContainerHigh: const Color(0xFF1F1A38),
        surfaceContainerHighest: const Color(0xFF231D43),
        surfaceDim: const Color(0xFF120F26),
        surfaceBright: const Color(0xFF2A244C),

        // ─────────────────────────────────────────────────────────────────────
        // ERROR
        // ─────────────────────────────────────────────────────────────────────
        error: AppColors.danger,
        onError: const Color(0xFF690005),
        errorContainer: const Color(0xFF93000A),
        onErrorContainer: const Color(0xFFFFDAD6),

        // ─────────────────────────────────────────────────────────────────────
        // OUTLINE & UTILITY
        // ─────────────────────────────────────────────────────────────────────
        outline: AppColors.textMuted,
        outlineVariant: const Color(0xFF443D69),
        shadow: Colors.black,
        scrim: Colors.black,
        inverseSurface: const Color(0xFFE7E1F4),
        onInverseSurface: const Color(0xFF120F26),
        inversePrimary: const Color(0xFF2A244C),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0,
        ),
        iconTheme: IconThemeData(
          color: Color(0xFF9991C1),
          size: 24,
        ),
        actionsIconTheme: IconThemeData(
          color: Color(0xFF9991C1),
          size: 24,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Color(0xFF17132E),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF17132E),
        selectedItemColor: Color(0xFF9991C1),
        unselectedItemColor: Color(0xFF696383),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF17132E),
        indicatorColor: const Color(0xFF2A244C),
        elevation: 0,
        height: 80,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9991C1),
            );
          }
          return const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF696383),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: Color(0xFF9991C1),
              size: 24,
            );
          }
          return const IconThemeData(
            color: Color(0xFF696383),
            size: 24,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1A1531),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.06),
            width: 0.5,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF2A244C),
        foregroundColor: const Color(0xFFE7E1F4),
        elevation: 3,
        focusElevation: 4,
        hoverElevation: 4,
        highlightElevation: 2,
        splashColor: AppColors.primary.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF231D43),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF9991C1),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFEF4444),
            width: 2,
          ),
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: Color(0xFF696383),
          fontSize: 16,
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: Color(0xFF9991C1),
          fontSize: 16,
        ),
        floatingLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: Color(0xFF9991C1),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        isDense: false,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF1F1A38),
        surfaceTintColor: Colors.transparent,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        titleTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          letterSpacing: 0,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF9991C1),
          height: 1.43,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: const Color(0xFF17132E),
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        modalElevation: 1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        dragHandleColor: const Color(0xFF443D69),
        dragHandleSize: const Size(32, 4),
        showDragHandle: true,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFFE7E1F4),
        contentTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: Color(0xFF120F26),
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        actionTextColor: const Color(0xFF2A244C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF1A1531),
        selectedColor: const Color(0xFF2A244C),
        disabledColor: const Color(0xFF231D43),
        surfaceTintColor: Colors.transparent,
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF9991C1),
          letterSpacing: 0.1,
        ),
        secondaryLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFFE7E1F4),
          letterSpacing: 0.1,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFF443D69)),
        ),
        showCheckmark: true,
        checkmarkColor: const Color(0xFFE7E1F4),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF443D69),
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFF9991C1),
        size: 24,
      ),
      primaryIconTheme: const IconThemeData(
        color: Color(0xFF9991C1),
        size: 24,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          letterSpacing: -0.25,
          height: 1.12,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          letterSpacing: 0,
          height: 1.16,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          letterSpacing: 0,
          height: 1.22,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 32,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          letterSpacing: 0,
          height: 1.25,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          letterSpacing: 0,
          height: 1.29,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          letterSpacing: 0,
          height: 1.33,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          letterSpacing: 0,
          height: 1.27,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          letterSpacing: 0.15,
          height: 1.5,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          letterSpacing: 0.1,
          height: 1.43,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          letterSpacing: 0.5,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF9991C1),
          letterSpacing: 0.25,
          height: 1.43,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xFF696383),
          letterSpacing: 0.4,
          height: 1.33,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          letterSpacing: 0.1,
          height: 1.43,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF9991C1),
          letterSpacing: 0.5,
          height: 1.33,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Color(0xFF696383),
          letterSpacing: 0.5,
          height: 1.45,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF9991C1),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF9991C1),
          foregroundColor: const Color(0xFF120F26),
          disabledBackgroundColor: const Color(0xFF231D43),
          disabledForegroundColor: const Color(0xFF696383),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          minimumSize: const Size(48, 40),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1F1A38),
          foregroundColor: const Color(0xFF9991C1),
          disabledBackgroundColor: const Color(0xFF231D43),
          disabledForegroundColor: const Color(0xFF696383),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          minimumSize: const Size(48, 40),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF9991C1),
          disabledForegroundColor: const Color(0xFF696383),
          side: const BorderSide(color: Color(0xFF443D69)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          minimumSize: const Size(48, 40),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return const Color(0xFF231D43);
          }
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF120F26);
          }
          return const Color(0xFF443D69);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return const Color(0xFF231D43);
          }
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF9991C1);
          }
          return const Color(0xFF231D43);
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return const Color(0xFF443D69);
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return const Color(0xFF231D43);
          }
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF9991C1);
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(const Color(0xFF120F26)),
        side: const BorderSide(color: Color(0xFF696383), width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return const Color(0xFF231D43);
          }
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF9991C1);
          }
          return const Color(0xFF696383);
        }),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFF9991C1),
        linearTrackColor: Color(0xFF2A244C),
        circularTrackColor: Color(0xFF2A244C),
        linearMinHeight: 4,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: const Color(0xFF9991C1),
        inactiveTrackColor: const Color(0xFF2A244C),
        thumbColor: const Color(0xFF9991C1),
        overlayColor: const Color(0xFF9991C1).withValues(alpha: 0.08),
        valueIndicatorColor: const Color(0xFF9991C1),
        valueIndicatorTextStyle: const TextStyle(
          fontFamily: 'Cairo',
          color: Color(0xFF120F26),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: const Color(0xFF9991C1),
        unselectedLabelColor: const Color(0xFF696383),
        indicatorColor: const Color(0xFF9991C1),
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: const Color(0xFF443D69),
        labelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          return const Color(0xFF9991C1).withValues(alpha: 0.08);
        }),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        minVerticalPadding: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF9991C1),
          letterSpacing: 0.25,
        ),
        leadingAndTrailingTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF9991C1),
        ),
        iconColor: Color(0xFF9991C1),
        textColor: Colors.white,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFF2A244C);
            }
            return Colors.transparent;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFFE7E1F4);
            }
            return Colors.white;
          }),
          side: WidgetStateProperty.all(
            const BorderSide(color: Color(0xFF443D69)),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          textStyle: WidgetStateProperty.all(const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          )),
        ),
      ),
      searchBarTheme: SearchBarThemeData(
        backgroundColor:
        WidgetStateProperty.all(const Color(0xFF1F1A38)),
        surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        hintStyle: WidgetStateProperty.all(const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF696383),
        )),
        textStyle: WidgetStateProperty.all(const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        )),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: const Color(0xFFE7E1F4),
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xFF120F26),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        waitDuration: const Duration(milliseconds: 500),
      ),
      badgeTheme: const BadgeThemeData(
        backgroundColor: Color(0xFFEF4444),
        textColor: Colors.white,
        smallSize: 6,
        largeSize: 16,
        textStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: const Color(0xFF1F1A38),
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        labelTextStyle: WidgetStateProperty.all(const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        )),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(0xFF17132E),
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }
}
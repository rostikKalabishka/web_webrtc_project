import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  String? usernameValidator(String? val) {
    if (val!.isEmpty) {
      return 'Please fill in this field';
    }

    return null;
  }

  String? emailValidator(String? val) {
    if (val!.isEmpty) {
      return 'Please fill in this field';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{1,}$').hasMatch(val)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? onlyNumber(String? val) {
    if (val!.isEmpty) {
      return 'Please fill in this field';
    } else if (!RegExp(r'^[0-9]$').hasMatch(val)) {
      return 'Please enter only number';
    }
    return null;
  }

  String? passwordValidator(String? val) {
    if (val!.isEmpty) {
      return 'Please fill in this field';
    } else if (val.length < 8) {
      return 'Your password is less than 8 characters long';
    }
    return null;
  }

  String? confirmPasswordValidator(
      String confirmPassword, String mainPassword) {
    if (confirmPassword.isEmpty) {
      return 'Please fill in this field';
    } else if (confirmPassword != mainPassword) {
      return 'The password does not match';
    }
    return null;
  }

  void errorSnackBar(BuildContext context, ThemeData theme, String? errorMsg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: theme.cardColor,
        content: Center(
          child: Text(
            errorMsg ?? 'Unknown error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  String calculateTimeAgo(DateTime createTimeRoom) {
    Duration difference = DateTime.now().difference(createTimeRoom);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}  minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return DateFormat.yMMMd().format(createTimeRoom);
    }
  }
}

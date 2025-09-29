String? emailValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your email address';
  }
  // Check if the entered email has the right format
  if (!RegExp(r'\S+@\S+').hasMatch(value)) {
    return 'Please enter a valid email address';
  }
  // Return null if the entered email is valid
  return null;
}

String? passwordValidator(String? value,) {
  if (value == null || value.length < 5) {
    return 'Password must be at least 5 characters long';
  } else {
    return null;
  }
}

String? nameValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your first name';
  }
  if (value.length == 1) {
    return 'First name can\'t be a single character';
  }
  return null;
}

String? validatePhoneNumber(String value) {
  if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value)) {
    return 'Enter a valid phone number';
  }


  else {
    return null;
  }
}

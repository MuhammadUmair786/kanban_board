String convertToFullOpacityHex(String hexColor) {
  if (hexColor.length != 6) {
    return 'Invalid hex color code';
  }
  return '0xff$hexColor';
}

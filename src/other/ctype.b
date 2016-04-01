/* ctype.b - character types */

isalpha(c) {
  return((c >= 'a' & c <= 'z') | (c >= 'A' & c <= 'Z'));
}

isdigit(c) {
  return(c >= '0' & c <= '9');
}

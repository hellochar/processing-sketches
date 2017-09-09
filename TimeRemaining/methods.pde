long[] levels = {1, 1000, 60, 60, 24, 31};
long[] levelsCorrected;
{
  levelsCorrected = new long[levels.length];
  long factor = 1;
  for(int i = 0; i < levels.length; i++) {
    levelsCorrected[i] = (factor *= levels[i]);
  }
}

int tiu(long millis, int index) {//0 = millis, 1 = seconds, 2 = minutes, 3 = hours, 4 = minutes, 5 = days
  return (int)((millis / levelsCorrected[index]) % levels[index+1]);
}

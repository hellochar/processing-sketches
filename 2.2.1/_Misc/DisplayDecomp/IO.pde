//Outputs the aggregate as CSV in the following format
/**
*BEGIN OF FILE*
value0, value1, value2, value3 //for 0th index
value0, value1, value2, value3 //for 1st index
...
...
*END OF FILE*
values are represented as [8bits-alpha][8bits-red][8bits-green][8bits-blue]
*/
boolean outputAsCsv(String name, List<int[]> aggregate) {
  PrintWriter out = createWriter(name);
  if(out != null) {
    for(int[] arr : aggregate) {
      String output = arr[0] + ", "+arr[1]+", "+arr[2]+", "+arr[3];
      out.println(output);
    }
    out.flush();
    out.close();
    return true;
  }
  else {
    return false;
  }
}

List<int[]> readFromCsv(String name) {
  String[] bytes = loadStrings(name);
  List<int[]> ret = new ArrayList(bytes.length);
  for(String s : bytes) {
    String[] splitted = s.split(", ");
    ret.add(new int[] {Integer.parseInt(splitted[0]), 
                       Integer.parseInt(splitted[1]), 
                       Integer.parseInt(splitted[2]), 
                       Integer.parseInt(splitted[3])} );
  }
  return ret;
}

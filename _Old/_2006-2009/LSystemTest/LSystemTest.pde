String w = "X";
String rules = "(X=X+F),(F=-X+X)";
String seedRules;
String[] seedConversions;
String[] genRules;
String[] genConversions;

int seedRuleLength;
int genRuleLength;

String current;
void setup() {
  current = w;
  setupRules();
}
int n = 0;

void draw() {
  current = findGenRule(current);
  println("\n"+current+"\nSeeds: ");
  for(int a = 0; a < seedRuleLength; a++) {
  print(seedRules.substring(a, a+1)+"\t\t\t");
  println(seedConversions[a]);
  }
  println("Gens: ");
  for(int a = 0; a < genRuleLength; a++) {
  print(genRules[a]+"\t\t\t");
  println(genConversions[a]);
  }
  
  println("----------"+(n++)+"----------\n\n");
  
  noLoop();
}

void mousePressed() {
  redraw();
}

void setupRules() {
  
  //create the seed rules
  int[] locs = locationsOf(rules, "=");
  seedRuleLength = 0;
  seedRules = "";
  seedConversions = new String[500];
  for(int a = 0; a < locs.length; a++) //add the initial seed rules
    addSeedRule(rules.substring(locs[a]-1, locs[a]), rules.substring(locs[a]+1, rules.indexOf(")", locs[a])));
    
  //initialize the gen rules
  genRules = new String[500];
  genConversions = new String[500];
  genRuleLength = 0;
}

int seedRuleLocation(String symbol) {
  return seedRules.indexOf(symbol);
}

void addSeedRule(String symbol, String rule) {
  println("adding SEED rule "+rule+" for symbol "+symbol);
  if(seedRuleLocation(symbol) == -1) {
    seedRules += symbol;
    seedConversions[seedRuleLength++] = rule;
  }//end of addSeedRule
}

String findSeedRule(String symbol) {
  print("Finding seed rule for "+symbol+"\t");
  if(symbol.length() > 1) return symbol;
  //look through the seed rules and find the one that goes with the symbol
  if(seedRuleLocation(symbol) != -1) return seedConversions[seedRuleLocation(symbol)];
  
  //create a seed rule for the symbol
  addSeedRule(symbol, symbol);
  return symbol;                    }//end of findSeedRule



int genRuleLocation(String symbol) {
  for(int ruleEnum = genRuleLength-1; ruleEnum >= 0; ruleEnum--)
    if(symbol.equals(genRules[ruleEnum])) return ruleEnum;
  return -1;
}

//add the rule for the symbol
void addGenRule(String symbol, String rule) {
  println("adding GENERATED rule "+rule+" for symbol "+symbol);
  if(genRuleLocation(symbol) == -1) {
    genRules[genRuleLength] = symbol;
    genConversions[genRuleLength++] = rule;
  }
}//end of addGenRule


String findGenRule(String symbol) {
  print("Finding gen rule for "+symbol+"\t");
  if(symbol.length() <= 1) return findSeedRule(symbol);
  //look through the generated rules and find the one that goes with the symbol. Because gen rules may overlap each other, find the bigger
  //one first - the ones that were more recently generated.
  int genRuleLoc = genRuleLoc = genRuleLocation(symbol);
  if(genRuleLoc != -1)
    return genConversions[genRuleLoc];
    
  //create a gen rule for the symbol
  String genRule = "";
  
  /* TODO - create the gen rule for the symbol. To do this, find all lesser gen symbols embedded into this one, convert them accordingly,
     and then re-assemble them into the finished rule. If you cannot find any lesser gen rules, then parse it into strings of 8 characters
     each and create rules for each one.
  */
  
  String symbolCopy = new String(symbol);
  int[] locs;
  StringLoc[] inners = new StringLoc[0];  
  String genRuleTemp;
  String tempSpace;
  boolean found;
  //Go through each gen symbol, catalogue where you found them, remove the lesser gen symbol from the main gen symbol, and create a StringLoc
  //for it.
  int genRuleTempLength;
  for(int ruleEnum = genRuleLength-1; ruleEnum >= 0; ruleEnum--) {    
    genRuleTemp = genRules[ruleEnum];
    genRuleTempLength = genRuleTemp.length();
    
    //find the locations of the current lesser gen symbol
    locs = locationsOf(symbolCopy, genRuleTemp);
    
    if(locs.length > 0) { //to save time, only go through each location if there actually are locations
      println("\nInner rule LOCATIONS of "+genRuleTemp+" inside "+symbolCopy+"!");
      println(locs);
      //go through each location and create a StringLoc for it.
      for(int innerRuleEnum = 0; innerRuleEnum < locs.length; innerRuleEnum++) {
        println("...APPENDING "+symbolCopy.substring(locs[innerRuleEnum], locs[innerRuleEnum]+genRuleTempLength)+" to inners at "+locs[innerRuleEnum]+"!\t");
        inners = (StringLoc[])append(inners, new StringLoc(symbolCopy.substring(locs[innerRuleEnum], locs[innerRuleEnum]+genRuleTempLength), locs[innerRuleEnum]));
      }
    
      tempSpace = "";
    
      for(int a = 0; a < genRuleTempLength; a++)
        tempSpace += " ";
    
      //replace all inner symbols with spaces equal to how long the inner symbol is.
      for(int a = 0; a < locs.length; a++)
        symbolCopy = symbolCopy.substring(0, locs[a]).concat(tempSpace).concat(symbolCopy.substring(locs[a]+genRuleTempLength, symbolCopy.length()));
      println("new SymbolCopy with inner "+genRuleTemp+"s removed!"+symbolCopy+"!");
    }else print("\ndid not find any locations for "+genRuleTemp+"!");
  }
  
  println("FINISHED finding inners!");
  
  /* We now have the StringLocs for each inner symbol and possibly left overs of rules that have yet to be created. Create rules for all
     leftovers. Then sort all the StringLocs by order of their location (where they were found), compile them all together into a single
     string (which is the rule for the symbol), add it to the list of generated rules, and finally return. IF there are no StringLocs, then
     separate the string into 8 characters and create seed rules for them all. (since you can be gaurenteed there are no generated rules in
     them).
  */
  
  //If there are no StringLocs, then just fuck it all. and by that i mean insert a white space into every 8th character. 
  if(inners.length == 0) {
    println("NO INNERS in "+symbol+"!");
    int blocks = symbolCopy.length()/8; //tells us the number of separators to put in
    int offset = 0; //we have to compensate for the added spaces
    for(int a = 0; a < blocks; a++) {
      symbolCopy = insert(symbolCopy, " ", a*8+offset++);
    }
  }
  
  println("symbolCopy with whitespace:"+symbolCopy+"!");
  //First, remove all trailing whitespace to make sure the counter updates correctly
  if(symbolCopy.endsWith(" ")) {
    int index = symbolCopy.length();
  
    //find how much trailing whitespace there is
    do {
      index--;
    }while(symbolCopy.charAt(index) == ' ');
    //remove the trailing whitespace
    symbolCopy = symbolCopy.substring(0, index+1);
  }
  
  println("FINISHED making touchups to symbolCopy! It is now:"+symbolCopy+"!");

  //get all the leftovers and find rules for them
  //get all the leftovers
  StringLoc[] leftOvers = new StringLoc[0];
  String tempStringLoc;
  int lDif = 0; //this is a counter keeping track of how many white spaces have been removed
  int index = symbolCopy.indexOf(" ");
  while(index > 0) {
    int l = symbolCopy.length();
    symbolCopy = symbolCopy.trim(); //remove all leading and trailing whitespace
    lDif += l-symbolCopy.length(); //update the counter
    tempStringLoc = symbolCopy.substring(0, index); //find the first leftover in the string
    leftOvers = (StringLoc[])append(leftOvers, new StringLoc(tempStringLoc, lDif));
    lDif += tempStringLoc.length(); //re-update the counter
    symbolCopy = symbolCopy.substring(index);
    index = symbolCopy.indexOf(" ");
  }
  symbolCopy = symbolCopy.trim();
  println("symbolCopy:"+symbolCopy);
  leftOvers = (StringLoc[])append(leftOvers, new StringLoc(symbolCopy, lDif));

  println("leftovers:");
  for(int a = 0; a < leftOvers.length; a++)
    println("["+a+"]"+":"+leftOvers[a].data);
  
  //we now have all the leftovers, and now we must change them into rules, add the rules, and finally append it onto the list of inners
  for(int a = 0; a < leftOvers.length; a++) {
    tempStringLoc = leftOvers[a].data;
    String stringLocConversion = "";
    for(int b = 0; b < tempStringLoc.length(); b++)
      stringLocConversion += findSeedRule(tempStringLoc.substring(b, b+1));
    addGenRule(tempStringLoc, stringLocConversion);
    inners = (StringLoc[])append(inners, new StringLoc(stringLocConversion, leftOvers[a].location));
  }
  
  //sort the StringLocs by location
  for(int a = 0; a < inners.length; a++)
    for(int b = inners.length-1; b > a; b--)
      if(inners[b].location < inners[b-1].location) {
        StringLoc temp = inners[b];
        inners[b] = inners[b-1];
        inners[b-1] = temp;
      }
  
  //combine all the StringLocs together
  for(int a = 0; a < inners.length; a++)
    genRule += inners[a].data;
  
  //add the rule
  addGenRule(symbol, genRule);
  return genRule;
}//end of findGenRule



int[] locationsOf(String which, String occ) {
  int[] locs = new int[occurencesOf(which, occ)];
  int index = which.indexOf(occ);
  for(int a = 0; a < locs.length; a++) {
    if(index == -1) break;
    locs[a] = index;
    index = which.indexOf(occ, index+1);
  }
  return locs;                               }

int occurencesOf(String which, String occ) {
  int n = 0;
  int a = which.indexOf(occ);
  while(a != -1) {
    n++;
    a = which.indexOf(occ, a+1);
  }
  return n;
}


String insert(String which, String replace, int loc) {
  if(loc <= 0) return replace.concat(which);
  else if(loc >= which.length()) return which.concat(replace);
  else return which.substring(0, loc).concat(replace).concat(which.substring(loc, which.length()));
}

class StringLoc {
  String data;
  int location;
  
  StringLoc(String d, int loc) {
    data = d;
    location = loc;
  }
  
}

final int black = #000000, //black = blank
brick = #BFBEB1, //brick = brick
fire = #FF0000, //fire = fire
water = #0000FF, //water = water
plant = #22FF33, //plant = plant
steam = #95EAEA, //steam = steam
fodder = #866213, //fodder = fodder
sand = #FFFF00, //sand = sand
glass = #D3CBCB, //glass = glass
ice = #FFFFFF, //ice = ice
uber = #8B27AA, //uber = uber
torch = #71130E, //torch = torch
waterfall = #5572E3, //waterfall = waterfall
mud = #996633, //mud = mud
dirt = #CC9900; //dirt = dirt


int[] elementsIndex = { 
  //0    1     2      3      4      5       6     7      8    9     10     11         12   13 
  brick, fire, water, plant, steam, fodder, sand, glass, ice, uber, torch, waterfall, mud, dirt
};

int neut = -27345;
int swap = -2454;
int[][] convTable =  {
//---------brick-------fire-------water-------plant-------steam-------fodder-------sand-------glass-------ice-------uber-------torch-------waterfall-------mud-------dirt
/*brick*/ {neut,       brick,     brick,      brick,      brick,      brick,       brick,     neut,       brick,    neut,      neut,       neut,           neut,     neut},
/*fire*/  {brick,      neut,      black,      fire,       black,      fire,       glass,     glass,      water,    neut,      neut,       neut,           dirt,     neut},
/*water*/ {brick,      steam,     neut,       plant,      neut,       neut,        sand,      neut,       neut,     water,     torch,      neut,           neut,     mud},
/*plant*/ {brick,      fire,      plant,      neut,       neut,       neut,        neut,      neut,       neut,     plant,     neut,       plant,          neut,     neut},
/*steam*/ {brick,      black,     neut,       neut,       neut,       neut,        neut,      neut,       water,    neut,      torch,      waterfall,      neut,     neut},
/*fodder*/{brick,      neut,      neut,       neut,       neut,       neut,        neut,      neut,       neut,     neut,      neut,       neut,           neut,     neut},
/*sand*/  {brick,      glass,     neut,       neut,       neut,       neut,        neut,      neut,       neut,     neut,      neut,       neut,           neut,     neut},
/*glass*/ {neut,       glass,     neut,       neut,       neut,       neut,        neut,      glass,      glass,    glass,     glass,      neut,           neut,     neut},
/*ice*/   {brick,      water,     neut,       neut,       water,      neut,        neut,      neut,       neut,     neut,      torch,      water,          waterfall,neut},
/*uber*/  {neut,       neut,      water,      plant,      neut,       neut,        neut,      neut,       neut,     neut,      neut,       neut,           neut,     neut},
/*torch*/ {neut,       neut,      fire,       neut,       torch,      neut,        torch,     torch,      torch,    neut,      torch,      neut,           dirt,     neut},
/*wfall*/ {neut,       neut,      neut,       plant,      waterfall,  neut,        waterfall, waterfall,  waterfall,neut,      waterfall,  neut,           waterfall,mud},
/*mud*/   {neut,       dirt,      neut,       neut,       neut,       neut,        neut,      neut,       waterfall,neut,      dirt,       waterfall,      neut,     neut},
/*dirt*/  {neut,       neut,      mud,        neut,       neut,       neut,        neut,      neut,       neut,     neut,      neut,       mud,            neut,     neut}
};


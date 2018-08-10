size(512, 512, P2D);
smooth(8);
background(#E1E8ED);
stroke(#202B33);
noFill();
//rect(0, 0, width, 20);
//rect(0, 0, 20, height);
strokeCap(RECT);
strokeWeight(5);
line(0, height/2, width/2 - 5, height/2);
line(width/2 + 5, height/2, width, height/2);

strokeWeight(30);
line(0, height/2, 5, height/2);
line(width, height/2, width-5, height/2);

strokeWeight(15);
line(width/2 - 2.5, height/2, width/2 - 7.5, height/2);
line(width/2 + 2.5, height/2, width/2 + 7.5, height/2);

strokeWeight(10);
line(0, height/2, 15, height/2);
line(width, height/2, width - 15, height/2);
///**
// * Gets a weighted average of the difference in the hues, saturations, and brightnesses.
// * TODO: TEST THIS SHIT.
// */
//double getSimilarity(int color, int target) {
//  float ch = hue(color),
//        cs = saturation(color),
//        cb = brightness(color),
//        
//        th = hue(target),
//        ts = saturation(target),
//        tb = brightness(target),
//        
//        th = distance(ch, th, 255)/128, // [0, 128] -> [0, 1]
//        ts = abs(cs - ts)/255, // [0, 255] -> [0, 1]
//        tb = abs(cb - tb)/255; // [0, 255] -> [0, 1]
//        
//  float hueWeight = 3,
//        satWeight = 1,
//        briWeight = 1,
//        denom = hueWeight+satWeight+briWeight;
//  return (th*hueWeight+ts*satWeight+tb*briWeight) / denom;
//}

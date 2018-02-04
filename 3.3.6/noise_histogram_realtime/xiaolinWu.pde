void plot(int x, int y, float c, float r, float g, float b) {
    int index = y * width + x;
    if (index >= 0 && index < countR.length) {
        countR[index] += r * c;
        countG[index] += g * c;
        countB[index] += b * c;
    }
}

float fpart(float x) {
    return x - floor(x);
}

float rfpart(float x) {
    return 1 - fpart(x);
}

void lineCountXiaolinWu(float x0, float y0, float x1, float y1, float r, float g, float b) {
    boolean steep = abs(y1 - y0) > abs(x1 - x0);

    if (steep) {
        // swap x0 and y0
        float tmp = x0;
        x0 = y0;
        y0 = tmp;

        // swap x1 and y1
        tmp = x1;
        x1 = y1;
        y1 = tmp;
    }
    if (x0 > x1) {
        // swap x0 and x1
        float tmp = x0;
        x0 = x1;
        x1 = tmp;

        // swap y0 and y1
        tmp = y0;
        y0 = y1;
        y1 = tmp;
    }

    float dx = x1 - x0;
    float dy = y1 - y0;
    float gradient = dy / dx;
    if (dx == 0) {
        gradient = 1.0;
    }

    // handle first endpoint
    int xend = round(x0);
    float yend = y0 + gradient * (xend - x0);
    float xgap = rfpart(x0 + 0.5);
    int xpxl1 = xend; // this will be used in the main loop
    int ypxl1 = floor(yend);
    if (steep) {
        plot(ypxl1,   xpxl1, rfpart(yend) * xgap, r, g, b);
        plot(ypxl1+1, xpxl1,  fpart(yend) * xgap, r, g, b);
    } else {
        plot(xpxl1, ypxl1  , rfpart(yend) * xgap, r, g, b);
        plot(xpxl1, ypxl1+1,  fpart(yend) * xgap, r, g, b);
    }
    float intery = yend + gradient; // first y-intersection for the main loop

    // handle second endpoint
    xend = round(x1);
    yend = y1 + gradient * (xend - x1);
    xgap = fpart(x1 + 0.5);
    int xpxl2 = xend; //this will be used in the main loop
    int ypxl2 = floor(yend);
    if (steep) {
        plot(ypxl2  , xpxl2, rfpart(yend) * xgap, r, g, b);
        plot(ypxl2+1, xpxl2,  fpart(yend) * xgap, r, g, b);
    } else {
        plot(xpxl2, ypxl2,  rfpart(yend) * xgap, r, g, b);
        plot(xpxl2, ypxl2+1, fpart(yend) * xgap, r, g, b);
    }

    // main loop
    if (steep) {
        for (int x = xpxl1 + 1; x <= xpxl2 - 1; x++) {
            plot(floor(intery)  , x, rfpart(intery), r, g, b);
            plot(floor(intery)+1, x,  fpart(intery), r, g, b);
            intery += gradient;
        }
    } else {
        for (int x = xpxl1 + 1; x <= xpxl2 - 1; x++) {
            plot(x, floor(intery),  rfpart(intery), r, g, b);
            plot(x, floor(intery)+1, fpart(intery), r, g, b);
            intery += gradient;
        }
    }
}
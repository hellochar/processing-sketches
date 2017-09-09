import hardcorepawn.fog.*;

import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

import processing.opengl.*;
import zhang.*;

import saito.objloader.*;


OBJModel model ;

float rotX, rotY;

void setup()
{
    size(800, 600, P3D);
    new PeasyCam(this, 100);
//    frameRate(30);
    model = new OBJModel(this, "volumetric_cloud_tutorial.obj", "absolute", TRIANGLES);
    model.enableDebug();

    model.scale(20);
//    model.translateToCenter();

    stroke(255);
    noStroke();
}



void draw()
{
    background(129);
    Methods.drawAxes(g, 1000);
    lights();
    pushMatrix();
//    translate(width/2, height/2, 0);
//    rotateX(rotY);
//    rotateY(rotX);


    for(int i = 0; i < 1; i++) {
      pushMatrix();
//      translate(random(1000), random(1000), random(1000);
      model.draw();
      popMatrix();
    }

    popMatrix();
    println(frameRate);
}

boolean bTexture = true;
boolean bStroke = false;

void keyPressed()
{
    if(key == 't') {
        if(!bTexture) {
            model.enableTexture();
            bTexture = true;
        } 
        else {
            model.disableTexture();
            bTexture = false;
        }
    }

    if(key == 's') {
        if(!bStroke) {
            stroke(255);
            bStroke = true;
        } 
        else {
            noStroke();
            bStroke = false;
        }
    }

    else if(key=='1')
        model.shapeMode(POINTS);
    else if(key=='2')
        model.shapeMode(LINES);
    else if(key=='3')
        model.shapeMode(TRIANGLES);
}

void mouseDragged()
{
    rotX += (mouseX - pmouseX) * 0.01;
    rotY -= (mouseY - pmouseY) * 0.01;
}


///////////////////////////////////
PImage[] aBallSprites = new PImage[15];
int iNumBalls = 200;
Ball[] aBalls = new Ball[iNumBalls];

PImage backgroundSprite;
PImage overlaySprite;

float fAngle = 0;
float fVelocity = 0;
float fFocalPoint = 1234;
float fFocalLength = 500;
boolean bApplyUserForce = false;

float fSpawnSphereSize = 500;
float fTargetSphereSize = 1000;
float fZOffset = 1500;


///////////////////////////////////
void setup()
{
  size(512, 512, P2D);
  frameRate(30);
  imageMode(CENTER);
  smooth();
  
  // Load the source images
  backgroundSprite = loadImage("background.png");
  overlaySprite = loadImage("overlay.png");
  PImage ballSprite = loadImage("spriteBlur.png");
  for (int i = 0; i < 15; i++)
  {
    aBallSprites[i] = createImage(128, 128, ARGB);
    aBallSprites[i].copy(ballSprite, 0, 128 * i, 128, 128, 0, 0, 128, 128);
  }
  
  // Create ball objects
  for (int i = 0 ; i < iNumBalls; i++)
  {
    aBalls[i] = new Ball();
  }
}

void draw()
{
  // MouseX controls rotation speed
  float fNewVelocity = (((float)mouseX/width)*2-1) * -0.05;
  fVelocity += (fNewVelocity - fVelocity) * 0.5;
  fAngle += fVelocity;
  
  // MouseY controls focal depth
  fFocalPoint = lerp(fZOffset-fTargetSphereSize, fZOffset+fTargetSphereSize, 1 - (float)mouseY/height);
  
  // Update balls
  for (int i = 0 ; i < iNumBalls; i++)
  {
    PVector vecSourcePos = aBalls[i].m_vecPos.get();
    
    // Force to keep balls on the surface of a sphere
    float fSurfaceDist = vecSourcePos.mag();
    float fSurfaceDistAlpha = -constrain((fSurfaceDist - fTargetSphereSize) / fTargetSphereSize/2, -1, 1);
    PVector vecForce = vecSourcePos.get();
    vecForce.normalize();
    vecForce.mult(fSurfaceDistAlpha * 100);

    // Apply a user-triggered kick?
    if (bApplyUserForce)
    {
      // Apply a kick in a random direction
      PVector vecRandomUserForce;
      do
      {
        vecRandomUserForce = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
      }
      while (vecRandomUserForce.mag() <= 1);
      vecRandomUserForce.normalize();
      vecRandomUserForce.mult(100);
      vecForce.add(vecRandomUserForce);
      
      // Apply a force to compress the sphere
      PVector vecUserForce = vecSourcePos.get();
      vecUserForce.normalize();
      vecUserForce.mult(-200);
      vecForce.add(vecUserForce);
    }

    // Force to move balls away from each other
    for (int j = 0 ; j < iNumBalls; j++)
    {
      if (i != j)
      {
        PVector vecDiff = aBalls[j].m_vecPos.get();
        vecDiff.sub(vecSourcePos);
        float fDist = vecDiff.mag();
        float fDistAlpha = 1 - constrain(fDist / 200, -1, 1);
        vecDiff.normalize();
        vecDiff.mult(fDistAlpha*fDistAlpha * -100);
        vecForce.add(vecDiff);
      }
    }
    
    // Damping and adding new forces
    aBalls[i].m_vecVelocity.mult(0.75);
    aBalls[i].m_vecVelocity.add(vecForce);
    aBalls[i].m_vecPos.add(aBalls[i].m_vecVelocity);

    // Calc new world and screen pos
    aBalls[i].UpdatePos();
  }  
  
  // Sort (slowly!) based on depth
  for (int i = 0 ; i < iNumBalls; i++)
  {
    for (int j = i + 1 ; j < iNumBalls; j++)
    {
      if (aBalls[i].m_vecScreenPos.z < aBalls[j].m_vecScreenPos.z)
      {
        Ball swap = aBalls[i];
        aBalls[i] = aBalls[j];
        aBalls[j] = swap;
      }
    }
  }

  // Render
  noTint();
  image(backgroundSprite, 256, 256, 512, 512);
  for (int i = 0 ; i < iNumBalls; i++)
  {
    aBalls[i].Render();
  }
  noTint();
  blend(overlaySprite, 0, 0, 512, 512, 0, 0, 512, 512, MULTIPLY);
  
  // Turn off user force
  if (bApplyUserForce)
  {
    bApplyUserForce = false;
  }
}

void mousePressed()
{
  bApplyUserForce = true;
}


///////////////////////////////////
class Ball
{
  Ball()
  {
    // Spawn balls on the surface of a small sphere
    PVector vecStartPos;
    do
    {
      vecStartPos = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    }
    while (vecStartPos.mag() <= 1);
    vecStartPos.normalize();
    vecStartPos.mult(fSpawnSphereSize);

    m_vecPos = vecStartPos.get();
    m_vecScreenPos = new PVector(0, 0, 0);
    m_vecVelocity = new PVector(0, 0, 0);
    m_vecColour = new PVector(random(150, 255), random(150, 255), random(150, 255));
  }

  void UpdatePos()
  {
    // Rotate and translate
    float fSin = sin(fAngle);
    float fCos = cos (fAngle);
    float fX = m_vecPos.x*fSin + m_vecPos.z*fCos;
    float fY = m_vecPos.y;
    float fZ = m_vecPos.x*fCos - m_vecPos.z*fSin + fZOffset;

    // Project from 3D to 2D
    m_vecScreenPos.x = width/2 + fX / fZ * 200;
    m_vecScreenPos.y = height/2 + fY / fZ * 200;
    m_vecScreenPos.z = fZ;
  }
  
  void Render()
  {
    if (m_vecScreenPos.z > 0)
    {
      float fDiff = abs(m_vecScreenPos.z - fFocalPoint);
      float fDiffAlpha = constrain(fDiff / fFocalLength, 0, 1);
      float fSize = (1 - (m_vecScreenPos.z / 3000)) * 40 + 10;
      tint(m_vecColour.x, m_vecColour.y, m_vecColour.z);
      image(aBallSprites[(int)(fDiffAlpha * (15-1))], m_vecScreenPos.x, m_vecScreenPos.y, fSize, fSize);
    }
  }
  
  PVector m_vecPos;
  PVector m_vecScreenPos;
  PVector m_vecVelocity;
  PVector m_vecColour;
}


float occupency_range(float startX, float startY, float dir) {

  //stroke(255, 0, 0);
  float endX = startX+500*cos(dir);
  float endY = startY+500*sin(dir);
  float dX = (endX-startX);
  float dY = endY-startY;
  map.loadPixels();


  float X, Y;
  float range1 = 500, range2=500;

  boolean occ = false;


  for (int i = 0; i<abs (round (dX)); i++) {
    if (dX!=0) {
      if (dX>0) {
        X = i+startX;
        Y = startY + i*dY/dX;
      } else {
        X = -i+startX;
        Y = startY + -i*dY/dX;
      }
      X = constrain(X, 0, 500-1);
      Y = constrain(Y, 0, 500-1);
      if (map.pixels[toPixel ( round((X)), round((Y)))] != color(255)) {
        range1 = dist(X, Y, startX, startY);
        occ = true;
        break;
      }
      //point(X, Y);
    }
  }
  for (int i = 0; i<abs (round (dY)); i++) {
    if (dY!=0) {
      if (dY>0) {
        X = startX + i*dX/dY;
        Y =  i+startY;
      } else {
        X = startX + -i*dX/dY;
        Y =  -i+startY;
      }
      X = constrain(X, 0, 499);
      Y = constrain(Y, 0, 499);
      if (map.pixels[toPixel ( round((X)), round((Y)))] != color(255)) {
        range2 = dist(X, Y, startX, startY);
        occ = true;
        break;
      }
      //point(X, Y);
    }
  }
  if (occ) {
    return min (range1, range2);
  }
  else return -1;
}

int toPixel(int x, int y) {
  return constrain(x,0,500-1)+500*constrain(y,0,500-1);
}
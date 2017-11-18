float[] pf_x;
float[] pf_y;
float[] pf_dir;
float[] pf_weight;
float[][] pf_range;

float main_pf_x;
float main_pf_y;
float main_pf_dir;
float[] main_pf_range;

void init_PF(){
  pf_x = new float[number_partical];
  pf_y = new float[number_partical];
  pf_dir = new float[number_partical];
  pf_weight = new float[number_partical];
  pf_range = new float[number_partical][degrees_scan];
  
  float random_x;
  float random_y;
  float random_dir;
  
  for (int i=0; i<number_partical; i++) {
    random_x = random(500);
    random_y = random(500);
    random_dir = random(TWO_PI);
    while (map.pixels[toPixel ( floor(random_x), floor(random_y))] != color(255)) {
      random_x = random(500);
      random_y = random(500);
      random_dir = random(TWO_PI);
    }
    pf_x[i] = random_x;
    pf_y[i] = random_y;
    pf_dir[i] = random_dir;
  }
  
  if(simmulator_mode == true){
    main_pf_range = new float[degrees_scan]; 
    
    random_x = random(500);
    random_y = random(500);
    random_dir = random(TWO_PI);
    while (map.pixels[toPixel ( floor(random_x), floor(random_y))] != color(255)) {
      random_x = random(500);
      random_y = random(500);
      random_dir = random(TWO_PI);
    }
    main_pf_x = random_x;
    main_pf_y = random_y;
    main_pf_dir = random_dir;
  }
  
  update_info_pf();
}

void update_info_pf(){
   update_pf_range();
   update_weight();
}

void update_main_pf_range(){
  for(int i = 0;i< degrees_scan;i++){
      float _dir = radians(i)+main_pf_dir-HALF_PI;
      float dis = occupency_range(main_pf_x, main_pf_y, _dir);
       
       
      float endX, endY;
      endX = dis*cos(_dir)+main_pf_x;
      endY = dis*sin(_dir)+main_pf_y;
      stroke(255, 0, 0);
      line(main_pf_x, main_pf_y, endX, endY); 
  } 
}

void update_pf_range(){
  for (int i=0; i<number_partical; i++) {
    for (int j=0; j<degrees_scan; j++) {
      float dir = radians(j)+pf_dir[i]-HALF_PI;
      pf_range[i][j] = occupency_range(pf_x[i], pf_y[i], dir);
    }
  }
  if(simmulator_mode){
    for(int i = 0;i< degrees_scan;i++){
      float dir = radians(i) + main_pf_dir - HALF_PI;
      main_pf_range[i] = occupency_range(main_pf_x,main_pf_y,dir);
    }
  }
}

void update_weight(){
  for (int i=0; i<number_partical; i++) {
    float sigma = 0;
    
    if ((map.pixels[toPixel ( floor(pf_x[i]), floor(pf_y[i]))] == color(0))) {
      pf_weight[i] = 0;
      continue;
    }
    
    if(simmulator_mode == false){
      for (int j=0; j<degrees_scan; j++) {
        sigma += abs(raw_rangedata[j]/5 - pf_range[i][j]);
      }
    } else {
      for (int j=0; j<degrees_scan; j++){
        sigma += abs(main_pf_range[j] - pf_range[i][j]);   
      }
    }
    
    pf_weight[i] = 1/sigma;
  }
}

void resampling() {
  float sum_weight = 0;
  float[] child_x = new float[number_partical];
  float[] child_y = new float[number_partical];
  float[] child_dir = new float[number_partical];
  for (int i=0; i<number_partical; i++) {
    sum_weight += pf_weight[i];
  }
  for (int i=0; i<number_partical; i++) {
    float random_seed = random(sum_weight);
    int parent = 0;
    float random_range = pf_weight[0];
    while (random_seed>random_range) {
      parent ++;
      random_range += pf_weight[parent];
      while (pf_weight[parent]==0) {
        parent ++;
        random_range += pf_weight[parent];
      }
    }
    float parent_x = pf_x[parent];
    float parent_y = pf_y[parent];
    float parent_dir = pf_dir[parent];
    child_x[i] = parent_x + randomGaussian()*5;
    child_y[i] = parent_y + randomGaussian()*5;
    child_dir[i] = parent_dir + randomGaussian()*0.1;
    while ((map.pixels[toPixel ( floor(child_x[i]), floor(child_y[i]))] == color(0))) {
      child_x[i] = parent_x + randomGaussian()*5;
      child_y[i] = parent_y + randomGaussian()*5;
      child_dir[i] = parent_dir + randomGaussian()*0.1;
    }
  }
  for (int i=0; i<number_partical; i++) {
    pf_x[i] = child_x[i];
    pf_y[i] = child_y[i];
    pf_dir[i] = child_dir[i];
  }
}

int max_weight() {
  float max_weight = 0;
  int max_p = 0;
  for (int i=0; i<number_partical; i++) {
    if (pf_weight[i]>max_weight) {
      max_weight = pf_weight[i];
      max_p = i;
    }
  }
  return max_p;
}

float avr_weight_x() {
  float sum_weight = 0;
  float avr_x = 0;
  float x;
  for (int i=0; i<number_partical; i++) {
    sum_weight += pf_weight[i];
    avr_x += pf_x[i]*pf_weight[i];
  }
  x = avr_x/sum_weight;
  return x;
}

float avr_weight_y() {
  float sum_weight = 0;
  float avr_y = 0;
  float y;
  for (int i=0; i<number_partical; i++) {
    sum_weight += pf_weight[i];
    avr_y += pf_y[i]*pf_weight[i];
  }
  y = avr_y/sum_weight;
  return y;
}

float avr_dir() {
  float avr_dir = 0;
  float y;
  for (int i=0; i<number_partical; i++) {
    avr_dir += pf_dir[i];
  }
  y = avr_dir/number_partical;
  return y;
}
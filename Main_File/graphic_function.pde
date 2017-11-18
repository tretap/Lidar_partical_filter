void load_map_forLoop(){
  background(100);
  image(map,0,0);
  
  if(debug_mode){
    draw_particle();
    //update_main_pf_range();
    draw_information_lowlevel();
  } else {
    float x = avr_weight_x();
    float y = avr_weight_y();
    float dir = avr_dir();
    
    println("X :",x," ,Y :",y," ,dir :",dir);
  }
}

void load_map_forResamp(){
   background(100);
   image(map,0,0);
}

void draw_particle() {
  if(show_avr == false){
    for (int i=0; i<number_partical; i++) {
      stroke(255);
      
      if ((map.pixels[toPixel ( floor(pf_x[i]), floor(pf_y[i]))] == color(255))) {
        fill(0, pf_weight[i]*1000000);
        ellipse(pf_x[i], pf_y[i], 8, 8);
        line(pf_x[i], pf_y[i], pf_x[i]+cos(pf_dir[i])*2, pf_y[i]+sin(pf_dir[i])*2);
      }
    
      fill(random(255), random(255), random(255));
      ellipse(pf_x[max_weight()], pf_y[max_weight()], 8, 8);
      line(pf_x[max_weight()], pf_y[max_weight()], pf_x[max_weight()]+cos(pf_dir[max_weight()])*2, pf_y[max_weight()]+sin(pf_dir[max_weight()])*2);
    } 
  } else {
    
    float x = avr_weight_x();
    float y = avr_weight_y();
    float dir = avr_dir();
    
    stroke(255);
    
    fill(150,150,150);
    ellipse(x, y, 8, 8);
    line(x, y, x+cos(dir)*2, y+sin(dir)*2);
    
  }
  if(simmulator_mode){
    stroke(255);
    
    fill(100,200,100);
    ellipse(main_pf_x, main_pf_y, 8, 8);
    line(main_pf_x, main_pf_y, main_pf_x+cos(main_pf_dir)*2, main_pf_y+sin(main_pf_dir)*2);
  }
}

void draw_information_lowlevel(){
  if(debug_mode){
    int x_o = 750;
    int y_o = 250;
    if(simmulator_mode){
       stroke(255); 
       fill(255);
       
       for(int i=0; i < degrees_scan;i++){
         float _dir = radians(i)+main_pf_dir-HALF_PI;
         float dis = occupency_range(main_pf_x, main_pf_y, _dir);
         
         float endX, endY;
         endX = dis*cos(_dir)+x_o;
         endY = dis*sin(_dir)+y_o;
         stroke(255, 255, 255);
         line(x_o, y_o, endX, endY); 
       }
    } else {
      for(int i=0; i < degrees_scan;i++){
        stroke(255);
        fill(255);
      
        float range = raw_rangedata[i]/5; 
        float tranverse = -90-i;
        
        line(x_o, y_o, x_o + sin(radians(tranverse))*range, y_o + cos(radians(tranverse))*range); 
      }
    }
  }
}
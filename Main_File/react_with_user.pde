boolean w_key = false;
boolean s_key = false;
boolean a_key = false;
boolean d_key = false;
boolean q_key = false;
boolean e_key = false;

void mouseClicked() {
  if (mouseButton == LEFT) {
    init_PF();
  } else if (mouseButton == RIGHT) {
    load_map_forResamp();
    
    update_pf_range();  
    update_weight();
    resampling();
  }
}

void keyPressed() {  // press “m”  for capture image in PNG file
  
  if (simmulator_mode) {
    update_key(key, true);
  }

  String runtime = str(day())+"-"+str(month())+"_"+str(hour()) +"-"+str(minute())+"-"+str(second());
  if (key=='m') {
    saveFrame("log_file/"+runtime+"/logs.png");
    //exit();
  }  
}

void keyReleased(){
  update_key(key, false); 
}

void update_key(char key, boolean state) {
  if (key == 'w'||key == 'W') {
    w_key = state;
  } else if (key == 's'||key == 'S') {
    s_key = state;
  } else if (key == 'a'||key == 'A') {
    a_key = state;
  } else if (key == 'd'||key == 'D') {
    d_key = state;
  } else if (key == 'q'||key == 'Q') {
    q_key = state;
  } else if (key == 'e'||key == 'E') {
    e_key = state;
  }
  
  if(state){
    update_main_pos();
  }
}

void update_main_pos () {
  float dx = 0, dy = 0;
  float sp = 1;
  int dir_num = round(256.0*atan2(sin(main_pf_dir), cos(main_pf_dir))/TWO_PI);
  if (w_key) {
    dx += sp*cos(main_pf_dir);
    dy += sp*sin(main_pf_dir);
  }
  if (s_key) {
    dx -= sp*cos(main_pf_dir);
    dy -= sp*sin(main_pf_dir);
  }
  if (d_key) {
    dx += sp*cos(main_pf_dir+HALF_PI);
    dy += sp*sin(main_pf_dir+HALF_PI);
  }
  if (a_key) {
    dx -= sp*cos(main_pf_dir+HALF_PI);
    dy -= sp*sin(main_pf_dir+HALF_PI);
  }
  if (q_key) {
    dir_num--;
  }
  if (e_key) {
    dir_num++;
  }
  main_pf_dir = float(dir_num)*TWO_PI/256.0;
  main_pf_x += dx;
  main_pf_y += dy;
  
  update_pf_pos();
}

void update_pf_pos() {
  for (int i=0; i<number_partical; i++) {
    float dx = 0, dy = 0;
    float sp = 1;
    float dir_PF = 0;

    if (w_key) {
      dx += sp*cos(pf_dir[i]);
      dy += sp*sin(pf_dir[i]);
    }
    if (s_key) {
      dx -= sp*cos(pf_dir[i]);
      dy -= sp*sin(pf_dir[i]);
    }
    if (d_key) {
      dx += sp*cos(pf_dir[i]+HALF_PI);
      dy += sp*sin(pf_dir[i]+HALF_PI);
    }
    if (a_key) {
      dx -= sp*cos(pf_dir[i]+HALF_PI);
      dy -= sp*sin(pf_dir[i]+HALF_PI);
    }
    if (q_key) {
      dir_PF-= TWO_PI/256;
    }
    if (e_key) {
      dir_PF+= TWO_PI/256;
    }

    pf_x[i] += dx;
    pf_y[i] += dy;
    pf_dir[i] += dir_PF;
    pf_dir[i] = atan2(sin( pf_dir[i]), cos( pf_dir[i]));
  }
}
import processing.serial.*;

//--------INIT DON'T EDIT--------//
Serial myPort;
PImage map;

int[] raw_rangedata = new int[360];
int[] raw_strdata = new int[360];
//-------------------------------//

//--------SETING PROGRAMS--------//
boolean debug_mode = false;//Debug will about Graphics ,but simmulator will about connection.
boolean simmulator_mode = true; // if Debug mode be true -> simmulator should be true same.
boolean show_avr = false; // Show only avr partical.
//-------------------------------//

//-------PARTICAL SETTING--------//
int number_partical = 300;
int degrees_scan = 180;
//-------------------------------//

void setup(){

  //------------LOADING MAP---------//
  map = loadImage("map_real.bmp");
  //--------------------------------//
  
  
  size(1000,500);
  
  if(simmulator_mode == false){
    myPort = new Serial(this, "COM13", 115200); // Edit Prot Connection Here !
    myPort.bufferUntil('\n');
  }
  
  init_PF();
}

void draw(){
 load_map_forLoop(); 
}
void serialEvent(Serial p) { 
  //String range = p.readString();
  String datain = p.readString();
  //println(datain);

  String data[] = datain.split(",");
  if (data.length == 3) {
    float range = float(data[0]);
    float radian = float(data[1]);
    float str = float(data[2]);
    raw_rangedata[int(radian)] = int(range);
    raw_strdata[int(radian)] = int(str);
  }
  //println(range);
  // println(radian);
}
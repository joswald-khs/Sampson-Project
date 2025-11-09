ArrayList<mouse> mice = new ArrayList<mouse>();
PrintWriter doc;
Table table;

void setup(){
  size(600,600);
  fill(0);
  background(255);
  table = loadTable("sketch_251031a/data.csv", "header");
  for (TableRow row : table.rows()) {
  float x = map(row.getFloat("time"),0,1000,60,400);
  float y = map(row.getFloat("temp")*4.8,0,600,550,60);
  float z = map(row.getFloat("outside")*4.8,0,600,550,60);
  fill(0,128,0);
  strokeWeight(0);
  circle(x,y,2);
  fill(194,24,7);
  circle(x,z,2);
  strokeWeight(1);
  fill(0);
  }
}

void draw(){
  mice.add(new mouse(mouseX,mouseY));
  graph();
}


void keyPressed(){
  if(key=='1'){
  noLoop();
  background(100);
  doc = createWriter("mouse.csv");
  doc.println("x,y");
  for(mouse z : mice){
    doc.println(z.toCSVLine());
  }
doc.flush();
doc.close();
}
}

void parseFile() {
  BufferedReader reader = createReader("points.csv");
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      String[] pieces = split(line, ',');
      float x = float(pieces[0]);
      float y = float(pieces[1]);
      mice.add( new mouse(x,y) );
      circle(x,y,2);
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
}

void graph(){
  line(60,50,60,550);
  line(60,550,560,550);
   textSize(30);
  text("Room Temperature Over Time", 150, 30);
  textSize(10);
  //for(int i = 0; i < 59; i++ ) {
  //  text(i*10 + "--", 0, 590 - i *10);
  //}
  for(int i = 600;i > 100; i=i-10) {
  line(55,i-50,62,i-50);
  line(i-40,548,i-40,555);
  }
  for(int j = 600; j > 100; j=j-20) {
    text(155-j/4, 40, j-70);
   strokeWeight(0.5);
    line(55,j-50,550,j-50);
  }
  // axis labels
  push();
  translate(35,380);
  rotate(-PI/2);
  textSize(25);
  text("Temperature (F)", 0, 0);
  pop();
  textSize(25);
  text("Time (min)", 250,585);
  textSize(10);
  int l = table.getRowCount();
   for(int k = 60; k < 560; k=k+20) {
    text(l, 550, 565);
    text(3l/2, 427, 565);
    text(l/2, 305, 565);
    text(l/4, 181, 565);
    text("0", 60, 565);
    text("0", 40, 550);
   strokeWeight(0.5);
  }
 }

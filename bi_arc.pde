import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;

ControlIO control;

ControlDevice device1;
ControlDevice device2;

void setup(){
  thread("main");

  size(800, 800);
  frameRate(30);
  smooth();
  
  control = ControlIO.getInstance(this);
  println(control.deviceListToText("")); 
  
  raw = new RawMouse[control.getNumberOfDevices()];
  MouseSelector(control, raw);
  left = rl[1]; right = rl[0];
  device1 = raw[right].device; device2 = raw[left].device;
  d1buttonL = device1.getButton(0);
  d2buttonR = device2.getButton(1);
  println("right hand device is " + raw[right].device.getName());
  println("left hand device is " + raw[left].device.getName());
  
  P.declare();
  P.resetOnCircle(4);
  A = P.G[0]; B = P.G[1];
  T0 = R(U(V(A, B)));
  T1 = R(U(V(B, A))); 
  

}

void draw() {
  background(white);
  textSize(12);
  text(str(degree2), 100, 100);
  filtering();
  if(d1buttonL.pressed()) rightControl(A);
  if(d2buttonR.pressed()) leftControl(B);
  //if(d2buttonR.pressed() || d1buttonL.pressed()) newRow();

  
  pen(green, 10); show(A, 10); pen(yellow, 10);show(B, 10);
  fill(0);text(device1.getName(), A.x, A.y); text(device2.getName(), B.x, B.y);
  T0 = R(T0, (degree1 - last1));
  T1 = R(T1, (degree2 - last2));
  drawBiarc(A, T0, B, T1);
  if(h==0) h = 1;
  last1 = R[(h-1)%n]; last2 = R1[(h-1)%n];
  //saveTable(table, "/Users/chris/Desktop/Data/new.csv");
}



static public void main(String args[]) {
   PApplet.main(new String[] { "bi_arc" });
}
  
  
void main()
    {
      int temp = 0; 
           mice = ManyMouse.Init();
            System.out.println("ManyMouse.Init() reported " + mice + ".");
        for (int i = 0; i < mice; i++){
          String cur = ManyMouse.DeviceName(i);
          if(cur.equals("Apple Internal Keyboard / Trackpad")) {
            mac = i;
          } else if(cur.equals("Bluetooth USB Host Controller")){
            blu = i;
          } else if(one == two) {
            one = i;
          } else {
            two = i;
          }
            System.out.println("Mouse #" + i + ": " + ManyMouse.DeviceName(i));
        }
        System.out.println();
  ManyMouseEvent event = new ManyMouseEvent();
    while (mice > 0)  // report events until process is killed.
    {  
      
      if (!ManyMouse.PollEvent(event)) {
        try { Thread.sleep(0); } catch (InterruptedException e) {}
      } else {
         
         temp = event.device;

          switch (event.type){
              
            case ManyMouseEvent.SCROLL:
              //print("scroll wheel ");
              if (event.item == 0){
                if(event.device == one) {
                  print("Mouse # " + event.device + " ");
                  print(event.value);
                  //last1 = degree1;
                  degree1 += event.value*PI/18.0;
                  println("Conrolling angle X");
                } if(event.device == two) {
                  print("Mouse # " + event.device + " ");
                  print(event.value);
                  //last2 = degree2;
                  degree2 += event.value*PI/18.0;
                  println("Conrolling angle Z");
                }
              }
              //newRow();
               break;

             case ManyMouseEvent.DISCONNECT:
               print("disconnect");
               mice--;
               break;
             } // switch
             println();
           } // if
        }
        ManyMouse.Quit();
    } // Main
    
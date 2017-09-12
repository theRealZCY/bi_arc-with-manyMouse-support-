int f=14; // filter size (controlled by keys)
int w, h = 0;
int n = 800;
//FILTER F = new FILTER(f,w); // Create a filter of size f
float a=0.8; // attraction weight controls speed of convergence of all filters (controlled by horizontal mouse drags)
float [] G = new float[n]; // array with n past values controlled by wheel
float [] R = new float[n]; // array with n past filtered values
float [] G1 = new float[n]; // array with n past values controlled by wheel
float [] R1 = new float[n]; // array with n past filtered values
int[] rl = new int[5];

ControlButton d1buttonL;
ControlButton d1buttonR;
ControlButton d2buttonL;
ControlButton d2buttonR;
ControlSlider slider;
ControlButton button2;
ControlSlider slider2;

pts P = new pts(); 
pt A = new pt(), B = new pt();
vec T0 = new vec();
vec T1 = new vec();
//Table table = new Table();
int counter, frame = 0;
float degree1 = PI/2, degree2 = PI/2;
float last1, last2 = 0.0;
RawMouse[] raw;
int mac, blu, one, two = 0;
int mice;
int left, right = 0;


void MouseSelector(ControlIO control, RawMouse[] rawMice) {
  
        int n = control.getNumberOfDevices();
        int t = 0;
        for (int i = 0; i < n; i++)
        {
            rawMice[i] = new RawMouse(control.getDevice(i));
            rawMice[i].device = control.getDevice(i);
            rawMice[i].id = i;
            println(rawMice[i].device.getName());
            if(rawMice[i].device.getNumberOfButtons()>= 5 && rawMice[i].device.getNumberOfSliders() == 2) {
              rl[t] = i; t++;
              println("Mouse Selector: " + rawMice[i].device.getName());
            }
        }
        if(t < 2) {
          println();
          println("***ERROR: NOT ENOUGH DEVICES.");
          exit();
        }
        
}

float movingIJ(pt A, pt B, pt lastA, pt lastB) {
  vec rightV = new vec(lastA.x - A.x, lastA.y - A.y);
  vec leftV = V(B, lastB);
  float value = dot(rightV, leftV);
  return value;
}

boolean movingK(pt A, pt B, pt lastA, pt lastB) {
   vec rightV = new vec(lastA.x - A.x, lastA.y - A.y);
   vec leftV = V(B, lastB);
  pt mid = new pt((lastA.x+lastB.x)/2.0,(lastA.y+lastB.y)/2.0);
   pt P = new pt(mid.x, mid.y + 20.0);
   return ((det(V(mid, P), V(mid, A)) > 0 == det(V(mid, P), rightV) >0) && (det(V(mid, P), V(mid, B)) > 0 == det(V(mid, P), leftV) >0));
}

void filtering() {
    G[h]= degree1;
    G1[h] = degree2;
    R[h]=lowPass(G, 0.05, 0.25)[h];
    degree1 = R[h];
    R1[h]=lowPass(G1, 0.05, 0.25)[h];
    degree2 = R1[h];
    h=(h+1)%n;
    println(h);
}

float[] lowPass(float[] x, float dt, float rc) {
  float[] y = new float[x.length];
  float alpha = dt/(rc + dt);
  //float alpha = 0.5;
  y[0] = alpha*x[0];
  for(int i = 1; i <x.length; i++) {
    y[i] = alpha*x[i] + (1-alpha)*y[i-1];
  }
  return y;
}

void drawBiarc(pt P0, vec T0, pt P1, vec T1){
   vec T = W(T0,T1), D = V(P0,P1);
   float a = 4.-n2(T);
   float b = 2 * dot(T,D);
   float c = -n2(D);
   float r = (-b+sqrt(sq(b)-4.*a*c))/(2.*a);
    pt C0 = P(P0,r,T0), C1 = P(P1,-r,T1), M = P(C0,C1);
   noFill();
   pen(cyan,2); beginShape(); v(P0); v(C0); v(C1); v(P1); endShape();
   fill(cyan); show(C0,5); show(C1,5); show(M,5);
   noFill(); 
   pen(blue,4); drawCircleInHat(P0,C0,M); 
   pen(red,4); drawCircleInHat(M,C1,P1);
 }
 
void drawCircleInHat(pt PA, pt B, pt PC){
  float e = (d(B,PC)+d(B,PA))/2;
  pt A = P(B,e,U(B,PA));
  pt C = P(B,e,U(B,PC));
  vec BA = V(B,A), BC = V(B,C);
  float d = dot(BC,BC) / dot(BC,W(BA,BC));
  pt X = P(B,d,W(BA,BC));
  float r=abs(det(V(B,X),U(BA)));
  
  vec XA = V(X,A), XC = V(X,C); 
  float a = angle(XA,XC), da=a/60;
  
   beginShape(); 
   if(a>0) for (float w=0; w<=a; w+=da) v(P(X,R(XA,w))); 
   else for (float w=0; w>=a; w+=da) v(P(X,R(XA,w)));
   endShape();

  }   
  
void rightControl(pt Q) {
  A.x += device1.getSlider(0).getValue();
  A.y += device1.getSlider(1).getValue();
  println(device1.getSlider(0).getValue());
}

void leftControl(pt P) {
    B.x += device2.getSlider(0).getValue();
    B.y += device2.getSlider(1).getValue();
}
  

//int f=8; // filter size
FILTER F = new FILTER(f,300); // battery of filters one per bin
 
class FILTER
  {
  int n=100;
  float [] V = new float [n];
  FILTER(int np, float v) // init all values to v
    {
    n=np;
    for(int i=0; i<n; i++) V[i]=v;
    }
  float[] move(float v)
    {
    V[0]=v;
    float[] arr = new float[2];
    for(int i=1; i<n; i++) V[i]=(V[i-1]+V[i])/2;
    arr[0] = V[n-1];
    arr[1] = V[n-n/2];
    return arr;
    }
   
  void set_n_to(int v)
    {
    if(v>n) for(int i=n; i<v; i++) V[i]=V[n-1];
    n=v;
    }
  }
 
//track three 10 mouse position
//calculate the qvrage A, B, C
//calculate the the bezier/neville parabola from A B C

//3k last mouse postions Mi (the avlue of k needs to be test
//preedict the next k/2 point
//a FIFO array data structure
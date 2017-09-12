class RawMouse
{
    boolean isValid;    // Is valid RawMouse class?
    int id;
    pt pos = new pt(0, 0);
    pt vel = new pt(0, 0);
    final int NUM_BUTTONS = 2;
    boolean[] btn = new boolean[NUM_BUTTONS];
    
    ControlDevice device;
    ControlSlider sliderX;
    ControlSlider sliderY;
    ControlButton[] button;
    
    
    RawMouse(ControlDevice device)
    {
        isValid = false;
        println("name = [" + device.getName() + "]");

        print(device.getNumberOfSliders() + " sliders, ");
        println(device.getNumberOfButtons() + " buttons ");
        //println(" " + device.getNumberOfSticks() + " sticks");    

        if (device.getNumberOfButtons() < 2)
        {
            println("Device [" + device.getName() + "] doesn't have enought buttons.");
            return;
        }

        if (device.getNumberOfSliders() < 2)
        {
            println("Device [" + device.getName() + "] doesn't have enought sliders.");
            return;
        }
     
        this.device = device;
        sliderX = device.getSlider(0);
        sliderY = device.getSlider(1);
        println("sliders ADD SUCCESSFUL");
        button = new ControlButton[NUM_BUTTONS];
        for (int i = 0; i < NUM_BUTTONS; i++) button[i] =  device.getButton(i);
                        
        isValid = true;
    }
    
    //void handle()
    //{
    //    //if(device.getNumberOfSliders() >= 2) {
    //      vel.setTo(sliderX.getValue(), sliderY.getValue(), 0);
    //      pos.addPt(vel);
    //    //} else {
    //    //  vel.setTo(0, 0, 0);
    //    //  pos.addPt(vel);
    //    //}
    //    for (int i = 0; i < 2; i++)
    //    {
    //        btn[i] = (device.getButton(i).getValue() != 0);
    //    }
    //}
    
    String toString()
    {
        return "ID" + id + ":" + device.getName() + " pos = (" + pos.x + "," + pos.y + ") button = [" + btn[0] + ", " + btn[1] + "]";
        //return "ID" + id + ":" + " pos = (" + pos.x + "," + pos.y + ") button = [" + btn[0] + ", " + btn[1] + "]";
    }
    
}
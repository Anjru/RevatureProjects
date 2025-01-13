public with sharing class Car extends Vehicle {
    private Double steeringRotation;
    private Double tireRotation;
    private double gear;

    public Car() {
        this.steeringRotation = 0;
        this.tireRotation = 0;
        this.gear = 0;
        this.media.add(Medium.LAND);
    }

    public Car(double speed){
        super(speed, 'Defualt', 1,1); 

    }

    public Car(double speed, String name){
        super(speed, name, 1, 1);
    }

    public Car(double speed, String name, Integer occupants){
        super(speed, name, occupants, 1);
    }

    public Car(double speed, String name, Integer occupants, Integer capacity){
        super.speed = speed;
        super.name = name;
        super.occupants = occupants;
        super.capacity = capacity;
    }

    public Double getSteeringRotation(){
        if(this.steeringRotation <= 1440 && this.steeringRotation >= -1440){
            return this.steeringRotation;
        }
        return 0;
    }

    public Double getTireRotation(){
        if(this.tireRotation <= 90 && this.tireRotation >= -90){
            return this.tireRotation;
        }
        return 0;
    }

    public Integer getGear(){
        return this.gear;
    }

    public override void turn(double degrees){
        steeringRotation += degrees;
        tireRotation += degrees/16;
    }

    public override void accelerate(){
        this.gear = (Integer)Math.ceil(0.4444 * (Math.sqrt(this.speed)));
    }

}
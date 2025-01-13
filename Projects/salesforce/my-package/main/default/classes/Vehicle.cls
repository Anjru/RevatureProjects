public with sharing abstract class Vehicle {
    public enum Medium{LAND, AIR, WATER}
    private double speed;
    private String name;
    Integer occupants;
    Integer capacity;
    protected List<Medium> media = new List<Medium>();
    public Vehicle() {
        this.speed = 1;
        this.occupants = 1;
        this.name = 'defualt';
        this.capacity = 1;
    }

    public Vehicle(double speed){
        this(speed, 'Defualt', 1,1); 

    }

    public Vehicle(double speed, String name){
        this(speed, name, 1, 1);
    }

    public Vehicle(double speed, String name, Integer occupants){
        this(speed, name, occupants, 1);
    }

    public Vehicle(double speed, String name, Integer occupants, Integer capacity){
        this.speed = speed;
        this.name = name;
        this.occupants = occupants;
        this.capacity = capacity;
    }

    public double getSpeed(){
        return speed;
    }

    public String getName(){
        return name;
    }

    public Integer getOccupants(){
        if(occupants > 0){
            return occupants;
        } else {
            return 0;
        }
    }

    public abstract void accelerate();

    public abstract void turn(double degrees);


    public override String toString(){
        System.debug('Speed: ' + this.speed + ' media: ' + this.media + ' Name: ' + this.name + ' Occupants: ' + this.occupants);
        return '';
    }
    


}
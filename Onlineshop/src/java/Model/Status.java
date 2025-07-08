package Model;

/**
 * Model class representing Status entity
 */
public class Status {
    private int statusID;
    private String name;
    
    // Constructors
    public Status() {
    }
    
    public Status(int statusID, String name) {
        this.statusID = statusID;
        this.name = name;
    }
    
    // Getters and Setters
    public int getStatusID() {
        return statusID;
    }
    
    public void setStatusID(int statusID) {
        this.statusID = statusID;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    @Override
    public String toString() {
        return "Status{" +
                "statusID=" + statusID +
                ", name='" + name + '\'' +
                '}';
    }
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author Admin
 */
public class Season {
    private int seasonID;
    private String seasonName;

    public Season() {
    }

    public Season(int seasonID, String seasonName) {
        this.seasonID = seasonID;
        this.seasonName = seasonName;
    }

    public int getSeasonID() {
        return seasonID;
    }

    public void setSeasonID(int seasonID) {
        this.seasonID = seasonID;
    }

    public String getSeasonName() {
        return seasonName;
    }

    public void setSeasonName(String seasonName) {
        this.seasonName = seasonName;
    }

    @Override
    public String toString() {
        return "Season{" + "seasonID=" + seasonID + ", seasonName=" + seasonName + '}';
    }
    
    
}

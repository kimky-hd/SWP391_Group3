/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author Admin
 */
public class Color {
    private int colorID;
    private String colorName;

    public Color() {
    }

    public Color(int colorID, String colorName) {
        this.colorID = colorID;
        this.colorName = colorName;
    }

    public int getColorID() {
        return colorID;
    }

    public void setColorID(int colorID) {
        this.colorID = colorID;
    }

    public String getColorName() {
        return colorName;
    }

    public void setColorName(String colorName) {
        this.colorName = colorName;
    }

    @Override
    public String toString() {
        return "Color{" + "colorID=" + colorID + ", colorName=" + colorName + '}';
    }
    
    
    
}

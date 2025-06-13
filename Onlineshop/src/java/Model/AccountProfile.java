/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.util.Date;

/**
 *
 * @author Admin
 */
public class AccountProfile {
    private int ProfileID;
    private String FullName;
    private String PhoneNumber;
    private String Address;
    private String Img;
    private Date DOB;
    private String Gender;
    private Date CreateAT;
    private int Account_ID;

    public AccountProfile() {
    }

    public AccountProfile(int ProfileID, String FullName, String PhoneNumber, String Address, String Img, Date DOB, String Gender, Date CreateAT, int Account_ID) {
        this.ProfileID = ProfileID;
        this.FullName = FullName;
        this.PhoneNumber = PhoneNumber;
        this.Address = Address;
        this.Img = Img;
        this.DOB = DOB;
        this.Gender = Gender;
        this.CreateAT = CreateAT;
        this.Account_ID = Account_ID;
    }

    public int getProfileID() {
        return ProfileID;
    }

    public void setProfileID(int ProfileID) {
        this.ProfileID = ProfileID;
    }

    public String getFullName() {
        return FullName;
    }

    public void setFullName(String FullName) {
        this.FullName = FullName;
    }

    public String getPhoneNumber() {
        return PhoneNumber;
    }

    public void setPhoneNumber(String PhoneNumber) {
        this.PhoneNumber = PhoneNumber;
    }

    public String getAddress() {
        return Address;
    }

    public void setAddress(String Address) {
        this.Address = Address;
    }

    public String getImg() {
        return Img;
    }

    public void setImg(String Img) {
        this.Img = Img;
    }

    public Date getDOB() {
        return DOB;
    }

    public void setDOB(Date DOB) {
        this.DOB = DOB;
    }

    public String getGender() {
        return Gender;
    }

    public void setGender(String Gender) {
        this.Gender = Gender;
    }

    public Date getCreateAT() {
        return CreateAT;
    }

    public void setCreateAT(Date CreateAT) {
        this.CreateAT = CreateAT;
    }

    public int getAccount_ID() {
        return Account_ID;
    }

    public void setAccount_ID(int Account_ID) {
        this.Account_ID = Account_ID;
    }

    @Override
    public String toString() {
        return "AccountProfile{" + "ProfileID=" + ProfileID + ", FullName=" + FullName + ", PhoneNumber=" + PhoneNumber + ", Address=" + Address + ", Img=" + Img + ", DOB=" + DOB + ", Gender=" + Gender + ", CreateAT=" + CreateAT + ", Account_ID=" + Account_ID + '}';
    }
}

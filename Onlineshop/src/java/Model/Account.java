/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author Admin
 */
public class Account {
    private int Account_ID;
    private String Email;
    private String Password;
    private String Status;
    private String Role;

    public Account() {
    }

    public Account(int Account_ID, String Email, String Password, String Status, String Role) {
        this.Account_ID = Account_ID;
        this.Email = Email;
        this.Password = Password;
        this.Status = Status;
        this.Role = Role;
    }

    public int getAccount_ID() {
        return Account_ID;
    }

    public void setAccount_ID(int Account_ID) {
        this.Account_ID = Account_ID;
    }

    public String getEmail() {
        return Email;
    }

    public void setEmail(String Email) {
        this.Email = Email;
    }

    public String getPassword() {
        return Password;
    }

    public void setPassword(String Password) {
        this.Password = Password;
    }

    public String getStatus() {
        return Status;
    }

    public void setStatus(String Status) {
        this.Status = Status;
    }

    public String getRole() {
        return Role;
    }

    public void setRole(String Role) {
        this.Role = Role;
    }
    
    @Override
    public String toString() {
        return "Account{" + "Account_ID=" + Account_ID + ", Email=" + Email + ", Password=" + Password + ", Status=" + Status + ", Role=" + Role + '}';
    }
}

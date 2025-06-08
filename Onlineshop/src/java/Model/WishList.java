/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author Admin
 */
public class WishList {
    private int WishListID;
    private int accountID;
    private int productID;

    public WishList() {
    }

    public WishList(int WishListID, int accountID, int productID) {
        this.WishListID = WishListID;
        this.accountID = accountID;
        this.productID = productID;
    }

    public int getWishListID() {
        return WishListID;
    }

    public void setWishListID(int WishListID) {
        this.WishListID = WishListID;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    @Override
    public String toString() {
        return "WishList{" + "WishListID=" + WishListID + ", accountID=" + accountID + ", productID=" + productID + '}';
    }
    
    
}

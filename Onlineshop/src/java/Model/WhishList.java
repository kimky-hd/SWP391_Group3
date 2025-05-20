/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author Admin
 */
public class WhishList {
    private int Wishlist_ID;
    private int Product_ID;
    private int Account_ID;

    public WhishList() {
    }

    public WhishList(int Wishlist_ID, int Product_ID, int Account_ID) {
        this.Wishlist_ID = Wishlist_ID;
        this.Product_ID = Product_ID;
        this.Account_ID = Account_ID;
    }
    

    public int getWishlist_ID() {
        return Wishlist_ID;
    }

    public void setWishlist_ID(int Wishlist_ID) {
        this.Wishlist_ID = Wishlist_ID;
    }

    public int getProduct_ID() {
        return Product_ID;
    }

    public void setProduct_ID(int Product_ID) {
        this.Product_ID = Product_ID;
    }

    public int getAccount_ID() {
        return Account_ID;
    }

    public void setAccount_ID(int Account_ID) {
        this.Account_ID = Account_ID;
    }

    @Override
    public String toString() {
        return "WishList{" + "Wishlist_ID=" + Wishlist_ID + ", Product_ID=" + Product_ID + ", Account_ID=" + Account_ID + '}';
    }
}

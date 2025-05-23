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
public class Rating {
    private int Rating_ID;
    private float Star;
    private Date CreateAt;
    private String Comment;
    private int Account_ID;
    private int Product_ID;

    public Rating() {
    }

    public Rating(int Rating_ID, float Star, Date CreateAt, String Comment, int Account_ID, int Product_ID) {
        this.Rating_ID = Rating_ID;
        this.Star = Star;
        this.CreateAt = CreateAt;
        this.Comment = Comment;
        this.Account_ID = Account_ID;
        this.Product_ID = Product_ID;
    }

    public int getRating_ID() {
        return Rating_ID;
    }

    public void setRating_ID(int Rating_ID) {
        this.Rating_ID = Rating_ID;
    }

    public float getStar() {
        return Star;
    }

    public void setStar(float Star) {
        this.Star = Star;
    }

    public Date getCreateAt() {
        return CreateAt;
    }

    public void setCreateAt(Date CreateAt) {
        this.CreateAt = CreateAt;
    }

        public String getComment() {
        return Comment;
    }

    public void setComment(String Comment) {
        this.Comment = Comment;
    }

    public int getAccount_ID() {
        return Account_ID;
    }

    public void setAccount_ID(int Account_ID) {
        this.Account_ID = Account_ID;
    }

    public int getProduct_ID() {
        return Product_ID;
    }

    public void setProduct_ID(int Product_ID) {
        this.Product_ID = Product_ID;
    }

    @Override
    public String toString() {
        return "Rating{" + "Rating_ID=" + Rating_ID + ", Star=" + Star + ", CreateAt=" + CreateAt + ", Comment=" + Comment + ", Account_ID=" + Account_ID + ", Product_ID=" + Product_ID + '}';
    }
}

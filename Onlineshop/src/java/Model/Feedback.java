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
public class Feedback {
    private int FeedbackID;
    private float Rate;
    private Date CreateAt;
    private String Comment;
    private int Account_ID;
    private int Product_ID;

    public Feedback() {
    }

    public Feedback(int FeedbackID, float Rate, Date CreateAt, String Comment, int Account_ID, int Product_ID) {
        this.FeedbackID = FeedbackID;
        this.Rate = Rate;
        this.CreateAt = CreateAt;
        this.Comment = Comment;
        this.Account_ID = Account_ID;
        this.Product_ID = Product_ID;
    }

    public int getFeedbackID() {
        return FeedbackID;
    }

    public void setFeedbackID(int FeedbackID) {
        this.FeedbackID = FeedbackID;
    }

    public float getRate() {
        return Rate;
    }

    public void setRate(float Rate) {
        this.Rate = Rate;
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
        return "Rating{" + "FeedbackID=" + FeedbackID + ", Rate=" + Rate + ", CreateAt=" + CreateAt + ", Comment=" + Comment + ", Account_ID=" + Account_ID + ", Product_ID=" + Product_ID + '}';
    }
}

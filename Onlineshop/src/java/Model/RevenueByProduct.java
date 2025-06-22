package Model;

public class RevenueByProduct {

    private String title;
    private int totalSold;
    private double totalRevenue;

    public RevenueByProduct(String title, int totalSold, double totalRevenue) {
        this.title = title;
        this.totalSold = totalSold;
        this.totalRevenue = totalRevenue;
    }

    public String getTitle() {
        return title;
    }

    public int getTotalSold() {
        return totalSold;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }
}

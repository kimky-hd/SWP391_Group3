
package Model;

public class RevenueByMonth {

    private int month;
    private double revenue;

    public RevenueByMonth(int month, double revenue) {
        this.month = month;
        this.revenue = revenue;
    }

    public int getMonth() {
        return month;
    }

    public double getRevenue() {
        return revenue;
    }
}

package Model;

public class RevenueByCustomer {
    private String username;
    private String fullName;
    private double totalSpent;

    public RevenueByCustomer(String username, String fullName, double totalSpent) {
        this.username = username;
        this.fullName = fullName;
        this.totalSpent = totalSpent;
    }

    public String getUsername() {
        return username;
    }

    public String getFullName() {
        return fullName;
    }

    public double getTotalSpent() {
        return totalSpent;
    }
}
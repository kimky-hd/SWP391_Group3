package Model;

public class Account {
    private int accountID;
    private String username;
    private String password;
    private int role;
    private String email;
    private String phone;
    private boolean isActive;
    
    public Account() {
    }
    
    public Account(int accountID, String username, String password, int role, String email, String phone, boolean isActive) {
        this.accountID = accountID;
        this.username = username;
        this.password = password;
        this.role = role;
        this.email = email;
        this.phone = phone;
        this.isActive = isActive;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getRole() {
        return role;
    }

    public void setRole(int role) {
        this.role = role;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }
    public String getRoleText() {
        switch (this.role) {
            case 0:
                return "Khách hàng";
            case 1:
                return "Admin";
            case 2:
                return "Quản lý";
            default:
                return "Không xác định";
        }
    }
    
    // Thêm method để lấy class CSS cho role
    public String getRoleClass() {
        switch (this.role) {
            case 0:
                return "bg-info";
            case 1:
                return "bg-danger";
            case 2:
                return "bg-warning text-dark";
            default:
                return "bg-secondary";
        }
    }
}

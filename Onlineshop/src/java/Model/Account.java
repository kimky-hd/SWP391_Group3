package model;

public class Account {
    private int accountID;
    private String username;
    private String password;
    private int role;
    private String email;
    private String phone;

    public Account() {
    }

    // Constructor đầy đủ
    public Account(int accountID, String username, String password, int role, String email, String phone) {
        this.accountID = accountID;
        this.username = username;
        this.password = password;
        this.role = role;
        this.email = email;
        this.phone = phone;
    }

    // Constructor không có phone (gán phone mặc định là "")
    public Account(int accountID, String username, String password, int role, String email) {
        this(accountID, username, password, role, email, "");
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

    @Override
    public String toString() {
        return "Account{" +
                "accountID=" + accountID +
                ", username='" + username + '\'' +
                ", password='" + password + '\'' +
                ", role=" + role +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                '}';
    }
}

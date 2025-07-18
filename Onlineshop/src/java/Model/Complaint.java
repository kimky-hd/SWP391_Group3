package Model;

import java.sql.Timestamp;
import java.util.Date;

public class Complaint {
    private int complaintID;
    private int maHD;
    private int accountID;
    private String title;
    private String content;
    private String image;        // Thêm trường image mới
    private String status;
    private String responseContent;
    private Timestamp dateCreated;
    private Timestamp dateResolved;
    // Thêm các trường này vào class Complaint
private String userName;
private String userPhone;
private double orderTotal;
private Date orderDate;
private String orderStatus;

// Thêm getters và setters cho các trường này
public String getUserName() {
    return userName;
}

public void setUserName(String userName) {
    this.userName = userName;
}

public String getUserPhone() {
    return userPhone;
}

public void setUserPhone(String userPhone) {
    this.userPhone = userPhone;
}

public double getOrderTotal() {
    return orderTotal;
}

public void setOrderTotal(double orderTotal) {
    this.orderTotal = orderTotal;
}

public Date getOrderDate() {
    return orderDate;
}

public void setOrderDate(Date orderDate) {
    this.orderDate = orderDate;
}

public String getOrderStatus() {
    return orderStatus;
}

public void setOrderStatus(String orderStatus) {
    this.orderStatus = orderStatus;
}

    // Constructor đầy đủ
    public Complaint(int complaintID, int maHD, int accountID, String title, String content, 
                    String image, String status, String responseContent, 
                    Timestamp dateCreated, Timestamp dateResolved) {
        this.complaintID = complaintID;
        this.maHD = maHD;
        this.accountID = accountID;
        this.title = title;
        this.content = content;
        this.image = image;
        this.status = status;
        this.responseContent = responseContent;
        this.dateCreated = dateCreated;
        this.dateResolved = dateResolved;
    }
    
    // Constructor không có ID (dùng khi tạo mới)
    public Complaint(int maHD, int accountID, String title, String content, String image) {
        this.maHD = maHD;
        this.accountID = accountID;
        this.title = title;
        this.content = content;
        this.image = image;
        this.status = "Đang xử lý";
    }
    
    // Constructor mặc định
    public Complaint() {
    }
    
    // Getters và Setters
    public int getComplaintID() {
        return complaintID;
    }

    public void setComplaintID(int complaintID) {
        this.complaintID = complaintID;
    }

    public int getMaHD() {
        return maHD;
    }

    public void setMaHD(int maHD) {
        this.maHD = maHD;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
    
    // Getter và Setter cho trường image mới
    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getResponseContent() {
        return responseContent;
    }

    public void setResponseContent(String responseContent) {
        this.responseContent = responseContent;
    }

    public Timestamp getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(Timestamp dateCreated) {
        this.dateCreated = dateCreated;
    }

    public Timestamp getDateResolved() {
        return dateResolved;
    }

    public void setDateResolved(Timestamp dateResolved) {
        this.dateResolved = dateResolved;
    }
    
    @Override
    public String toString() {
        return "Complaint{" +
                "complaintID=" + complaintID +
                ", maHD=" + maHD +
                ", accountID=" + accountID +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", image='" + image + '\'' +
                ", status='" + status + '\'' +
                ", dateCreated=" + dateCreated +
                ", dateResolved=" + dateResolved +
                '}';
    }
}

# Sử dụng image Tomcat 10 với JDK 17
FROM tomcat:10.1-jdk17-temurin

# Xóa ứng dụng mặc định trong thư mục webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file WAR của bạn và đổi tên thành ROOT.war để chạy tại /
COPY ./dist/Onlineshop.war /usr/local/tomcat/webapps/ROOT.war

# Mở cổng 9999
EXPOSE 9999

# Khởi động Tomcat
CMD ["catalina.sh", "run"]

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test Reviews</title>
</head>
<body>
    <h1>Test Reviews Page</h1>
    
    <h2>Debug Info:</h2>
    <p>feedbackList exists: <c:out value="${not empty feedbackList}"/></p>
    <p>feedbackList size: <c:out value="${feedbackList != null ? feedbackList.size() : 0}"/></p>
    <p>totalReviews: <c:out value="${totalReviews}"/></p>
    
    <h2>Feedback List:</h2>
    <c:choose>
        <c:when test="${not empty feedbackList}">
            <ul>
                <c:forEach var="feedback" items="${feedbackList}">
                    <li>
                        ID: <c:out value="${feedback.feedbackId}"/> - 
                        Customer: <c:out value="${feedback.username}"/> - 
                        Product: <c:out value="${feedback.productTitle}"/> - 
                        Rating: <c:out value="${feedback.rating}"/> - 
                        Comment: <c:out value="${feedback.comment}"/>
                    </li>
                </c:forEach>
            </ul>
        </c:when>
        <c:otherwise>
            <p>No feedbacks found</p>
        </c:otherwise>
    </c:choose>
</body>
</html>

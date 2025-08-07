<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <title>All Feedback</title>
    <link rel="stylesheet" href="/resources/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">
    <h2>All User Feedback</h2>
    <table class="table table-bordered table-striped mt-3">
        <thead class="thead-dark">
        <tr>
            <th>ID</th>
            <th>message</th>
            <th>Stars</th>
            <th>Date</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="fb" items="${feedbackList}">
            <tr>
                <td>${fb.feedbackId}</td>
                <td>${fb.message}</td>
                <td>${fb.rating}</td>
                <td>${fb.submitDate}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
<br><br>
<form action="/admin/adminindex" method="get">
    <button type="submit">Back to Admin Home</button>
</form>

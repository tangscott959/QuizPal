<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>All Feedback/Contact Messages</title>
</head>
<body>
<h2>All Submitted Contact Messages</h2>
<table border="1">
    <thead>
    <tr>
        <th>Contact ID</th>
        <th>First Name</th>
        <th>Last Name</th>
        <th>Subject</th>
        <th>Message</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="c" items="${contactlist}">
        <tr>
            <td>${c.contactId}</td>
            <td>${c.firstName}</td>
            <td>${c.lastName}</td>
            <td>${c.subject}</td>
            <td>${c.message}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>
<br><br>
<form action="/admin/home" method="get">
    <button type="submit">Back to Admin Home</button>
</form>

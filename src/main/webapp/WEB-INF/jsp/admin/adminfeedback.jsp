<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <title>All Feedback</title>
    <link rel="stylesheet" href="/resources/css/bootstrap.min.css">
    <style>
        body {
            background: linear-gradient(to right, #e0eafc, #cfdef3);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .feedback-card {
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            border: none;
            border-radius: 10px;
            background-color: white;
        }

        .table thead th {
            background-color: #007bff;
            color: white;
        }

        .btn-custom {
            background-color: #007bff;
            color: white;
            border-radius: 25px;
            padding: 10px 25px;
            transition: 0.3s ease;
        }

        .btn-custom:hover {
            background-color: #0056b3;
            transform: scale(1.05);
        }

        .title-border {
            border-bottom: 3px solid #007bff;
            display: inline-block;
            padding-bottom: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <div class="card feedback-card p-4">
        <h2 class="text-center title-border">All User Feedback</h2>

        <div class="table-responsive mt-4">
            <table class="table table-bordered table-hover text-center">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Message</th>
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

        <div class="text-center mt-4">
            <form action="${pageContext.request.contextPath}/admin/adminindex" method="get">
                <button type="submit" class="btn btn-custom">Back to Admin Home</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>

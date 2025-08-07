<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Access Denied</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8d7da;
            color: #721c24;
            text-align: center;
            padding-top: 100px;
        }
        .container {
            border: 1px solid #f5c6cb;
            background-color: #f8d7da;
            padding: 30px;
            border-radius: 10px;
            display: inline-block;
        }
        .btn-home {
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Access Denied</h1>
    <p>You do not have permission to access this page.</p>
    <a href="${pageContext.request.contextPath}/home" class="btn btn-danger btn-home">Return to Home</a>
</div>
</body>
</html>

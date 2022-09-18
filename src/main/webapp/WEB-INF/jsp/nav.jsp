<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>quiz</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <script src="js/bootstrap.min.js"></script>
    <style>.topnav {
        background-color: #333;
        overflow: hidden;
    }

    /* Style the links inside the navigation bar */
    .topnav a {
        float: left;
        color: #f2f2f2;
        text-align: center;
        padding: 14px 16px;
        text-decoration: none;
        font-size: 17px;
    }

    /* Change the color of links on hover */
    .topnav a:hover {
        background-color: #ddd;
        color: black;
    }

    /* Add a color to the active/current link */
    .topnav a.active {
        background-color: #04AA6D;
        color: white;
    }</style>
</head>
<body>
<nav class="navbar navbar-default justify-content-center">
    <div class="container-fluid">
        <div class="topnav">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <a href="${pageContext.request.contextPath}/feedback">Feed Back</a>

            <a href="${pageContext.request.contextPath}/contact">Contact Us</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>
    </div>
</nav>
</body>
</html>
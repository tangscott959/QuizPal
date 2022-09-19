
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>admin</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <div class="text-center">
                <h3 class="page-header">
                    Administator Index
                </h3>
            </div>
        </div>

        <ul class="nav nav-list"><li class="divider"></li></ul>
        <div class="row">
            <div class="col-md-6">
                <h4 class="text-info text-center">
                    <a  href="${pageContext.request.contextPath}/adminquiz?pageNum=1"   >Browse Results</a>
                </h4>
            </div>
            <div class="col-md-6 ">
                <h4 class="text-info text-center">
                    <a  href="${pageContext.request.contextPath}/adminallquestions?pageNum=1"   >Manage Questions</a>
                </h4>
            </div>
        </div>
    </div>
    <script src="js/bootstrap.min.js"></script>
</body>
</html>

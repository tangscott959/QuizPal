<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
    <meta name="viewport" content="width=device-width,initial-scale=1"/>
    <title>QuizHistory</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <script src="js/bootstrap.min.js"></script>

    <style type="text/css">
        .table tbody tr td {
            vertical-align: middle;
        }

        th {
            background-color: #42b983;
            color: rgba(255, 255, 255, 0.66);
            cursor: pointer;
        }

        .arrow {
            display: inline-block;
            vertical-align: middle;
            width: 0;
            height: 0;
            margin-left: 5px;
            opacity: 0.66;
        }

        .arrow.asc {
            border-left: 4px solid transparent;
            border-right: 4px solid transparent;
            border-bottom: 4px solid #fff;
        }

        .arrow.dsc {
            border-left: 4px solid transparent;
            border-right: 4px solid transparent;
            border-top: 4px solid #fff;
        }
    </style>
</head>

<body>
<div class="container">
    <div class="col-md-10">
        <h4> Contact Result</h4>
        <div class="row align-items-center">



        </div>
        <table class="table table-striped mt-2">
            <thead>
            <tr class="bg-info">
                <th class="col-2">First Name<span class="arrow asc"></span></th>
                <th class="col-2">Last Name<span class="arrow asc"></span></th>
                <th class="col-2">Subject<span class="arrow asc"></span></th>
                <th class="col-2">Message</th>

            </tr>
            </thead>
            <c:forEach items="${contactInfo}" var="contact">
            <tr>
            <td class="col-2">${contact.getFirstName()}</td>
            <td class="col-2">${contact.getLastName()}</td>
            <td class="col-2">${contact.getSubject()}</td>
            <td class="col-2">${contact.getMessage()}</td>
            </tr>
            </c:forEach>


        </table>
    </div>
</div>
<script type="text/javascript">

</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Users</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">

    <style type="text/css">
        .table tbody tr td{
            vertical-align: middle;
        }
        th {
            background-color: #42b983;
            color: rgba(255,255,255,0.66);
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
    <div class="col-10">
        <h4> User List</h4>
        <table class="table table-striped">
            <thead>
            <tr class="bg-info">
                <th  class="col-2">UserName<span class="arrow asc"></span></th>
                <th  class="col-2">FirstName<span class="arrow asc"></span></th>
                <th  class="col-2">LastName<span class="arrow asc"></span></th>
                <th  class="col-2">Email</th>
                <th class="col-2">phone</th>
                <th class="col-1">status</th>

                <th class="col-1">--</th>
                <th class="col-1">Is_admin</th>
            </tr>
            </thead>

            <c:forEach items="${userInfo}" var="user">
            <form action="${pageContext.request.contextPath}/admin/adminupdateuser" method="POST" >
                <tr>
                    <td class="col-2">${user.getUsername()}</td>
                    <td class="col-2">${user.getFirstname()}</td>
                    <td class="col-2">${user.getLastname()}</td>
                    <td class="col-2">${user.getEmail()}</td>
                    <td class="col-2">${user.getPhone()}</td>
                    <td class="col-1">${user.getIs_active() == 1 ? "active" : "disabled"}</td>
                    <td class="col-1">${user.getIs_admin()==1 ? "admin" : "Not admin"}</td>


                    <td class="col-1">
                        <input type="hidden" name="userid" value="${user.getId()}">
                        <button type="submit" ${user.getIs_active()==1 ? "class=\"btn btn-outline-danger\"" : "class=\"btn btn-outline-success\""} >
                                ${user.getIs_active()==1 ? "disable" : "enable"}
                        </button>
                    </td>
                </tr>
            </form>
            </c:forEach>

        </table>
    </div>
</div>
<script src="js/bootstrap.min.js"></script>
<script type="text/javascript">
    // <body onload="show()"
    // function show(data){
    //     console.log(data);
    // }

</script>
</body>
</html>
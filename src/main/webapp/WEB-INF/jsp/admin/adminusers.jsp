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
<%--<c:if test="${sessionScope.user.is_admin == 1}">--%>
<%--    <div class="container">--%>
<%--        <div class="col-10">--%>
<%--            <h4>User List</h4>--%>
<%--            <table class="table table-striped">--%>
<%--                <thead>--%>
<%--                <tr class="bg-info">--%>
<%--                    <th>UserName</th>--%>
<%--                    <th>FirstName</th>--%>
<%--                    <th>LastName</th>--%>
<%--                    <th>Email</th>--%>
<%--                    <th>Phone</th>--%>
<%--                    <th>Status</th>--%>
<%--                    <th>Make Admin</th>--%>
<%--                </tr>--%>
<%--                </thead>--%>
<%--                <c:forEach items="${userInfo}" var="user">--%>
<%--                    <form action="${pageContext.request.contextPath}/admin/adminupdateuser" method="POST">--%>
<%--                        <tr>--%>
<%--                            <td>${user.getUsername()}</td>--%>
<%--                            <td>${user.getFirstname()}</td>--%>
<%--                            <td>${user.getLastname()}</td>--%>
<%--                            <td>${user.getEmail()}</td>--%>
<%--                            <td>${user.getPhone()}</td>--%>
<%--                            <td>${user.getIs_active() == 1 ? "Active" : "Inactive"}</td>--%>
<%--                            <!-- Button to toggle user status -->--%>
<%--                            <td>--%>
<%--                                <button type="submit" name="action" value="toggle_status"--%>
<%--                                    ${user.getIs_active() == 1 ? "class='btn btn-outline-danger'" : "class='btn btn-outline-success'"} >--%>
<%--                                        ${user.getIs_active() == 1 ? "Disable" : "Enable"}--%>
<%--                                </button>--%>
<%--                            </td>--%>
<%--                            <!-- Button to toggle admin role -->--%>
<%--                            <td>--%>
<%--                                <button type="submit" name="action" value="toggle_admin"--%>
<%--                                    ${user.getIs_admin() == 1 ? "class='btn btn-warning'" : "class='btn btn-secondary'"} >--%>
<%--                                        ${user.getIs_admin() == 1 ? "Remove Admin" : "Make Admin"}--%>
<%--                                </button>--%>
<%--                            </td>--%>
<%--                        </tr>--%>
<%--                    </form>--%>
<%--                </c:forEach>--%>
<%--            </table>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</c:if>--%>

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
                <tr>
                    <!-- Is Admin Column -->
                    <td class="col-1">${user.getIs_admin() == 1 ? "Admin" : "Not Admin"}</td>

                    <!-- Enable/Disable User Button in its own form -->
                    <td class="col-1">
                        <form action="${pageContext.request.contextPath}/admin/toggleuser" method="POST">
                            <input type="hidden" name="userid" value="${user.getId()}">
                            <input type="hidden" name="action" value="toggle_status">
                            <button type="submit"
                                ${user.getIs_active() == 1 ? "class='btn btn-outline-danger'" : "class='btn btn-outline-success'"}>
                                    ${user.getIs_active() == 1 ? "Disable" : "Enable"}
                            </button>
                        </form>
                    </td>

                    <!-- Toggle Admin Button in its own form -->
                    <td class="col-1">
                        <form action="${pageContext.request.contextPath}/admin/toggleuser" method="POST">
                            <input type="hidden" name="userid" value="${user.getId()}">
                            <input type="hidden" name="action" value="toggle_admin">
                            <button type="submit"
                                ${user.getIs_admin() == 1 ? "class='btn btn-warning'" : "class='btn btn-secondary'"}>
                                    ${user.getIs_admin() == 1 ? "Remove Admin" : "Make Admin"}
                            </button>
                        </form>
                    </td>
                </tr>
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
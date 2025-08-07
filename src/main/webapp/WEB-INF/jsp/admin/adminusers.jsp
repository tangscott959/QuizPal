<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f8f9fa;
            padding: 30px;
        }

        .table thead {
            background-color: #42b983;
            color: white;
        }

        .table td, .table th {
            vertical-align: middle;
            text-align: center;
        }

        .btn {
            width: 100px;
        }

        h2 {
            color: #42b983;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2 class="text-center">User Management</h2>
    <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle">
            <thead>
            <tr>
                <th>Username</th>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Status</th>
                <th>Toggle Status</th>
                <th>Admin</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${userInfo}" var="user">
                <tr>
                    <td>${user.username}</td>
                    <td>${user.firstname}</td>
                    <td>${user.lastname}</td>
                    <td>${user.email}</td>
                    <td>${user.phone}</td>
                    <td>
                            <span class="badge ${user.is_active == 1 ? 'bg-success' : 'bg-secondary'}">
                                    ${user.is_active == 1 ? "Active" : "Inactive"}
                            </span>
                    </td>
                    <td>
                        <form action="${pageContext.request.contextPath}/admin/toggleuser" method="POST">
                            <input type="hidden" name="userid" value="${user.id}">
                            <input type="hidden" name="action" value="toggle_status">
                            <button type="submit" class="btn ${user.is_active == 1 ? 'btn-outline-danger' : 'btn-outline-success'}"
                                    title="${user.is_active == 1 ? 'Disable User' : 'Enable User'}">
                                    ${user.is_active == 1 ? "Disable" : "Enable"}
                            </button>
                        </form>
                    </td>
                    <td>
                        <form action="${pageContext.request.contextPath}/admin/toggleuser" method="POST">
                            <input type="hidden" name="userid" value="${user.id}">
                            <input type="hidden" name="action" value="toggle_admin">
                            <button type="submit" class="btn ${user.is_admin == 1 ? 'btn-warning' : 'btn-secondary'}"
                                    title="${user.is_admin == 1 ? 'Remove Admin Rights' : 'Grant Admin Rights'}">
                                    ${user.is_admin == 1 ? "Remove" : "Make Admin"}
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

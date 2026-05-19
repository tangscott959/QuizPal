<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f8f9fa;
        }
        .admin-card {
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        }
        .admin-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
        }
        .card-link {
            text-decoration: none;
            color: #0d6efd;
        }
        .card-link:hover {
            text-decoration: underline;
            color: #0a58ca;
        }
    </style>
</head>
<body>
<div class="container py-5">
    <div class="text-center mb-4">
        <h2 class="fw-bold">Administrator Dashboard</h2>
        <form action="${pageContext.request.contextPath}/logout" method="post" class="mt-2">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <button type="submit" class="btn btn-danger">Logout</button>
        </form>
    </div>

    <div class="row g-4">
        <div class="col-md-4">
            <div class="card admin-card h-100 text-center p-3">
                <div class="card-body">
                    <h5 class="card-title">
                        <a class="card-link" href="${pageContext.request.contextPath}/adminquiz?pageNum=1&sortByCategory=0">
                            Browse Results
                        </a>
                    </h5>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card admin-card h-100 text-center p-3">
                <div class="card-body">
                    <h5 class="card-title">
                        <a class="card-link" href="${pageContext.request.contextPath}/admin/contact">
                            Browse Contact
                        </a>
                    </h5>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card admin-card h-100 text-center p-3">
                <div class="card-body">
                    <h5 class="card-title">
                        <a class="card-link" href="${pageContext.request.contextPath}/admin/feedback">
                            Browse Feedback
                        </a>
                    </h5>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card admin-card h-100 text-center p-3">
                <div class="card-body">
                    <h5 class="card-title">
                        <a class="card-link" href="${pageContext.request.contextPath}/admin/managequestions">
                            Manage Questions
                        </a>
                    </h5>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card admin-card h-100 text-center p-3">
                <div class="card-body">
                    <h5 class="card-title">
                        <a class="card-link" href="${pageContext.request.contextPath}/adminallusers?pageNum=1">
                            Manage Users
                        </a>
                    </h5>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

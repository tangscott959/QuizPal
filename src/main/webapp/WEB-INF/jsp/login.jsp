<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">

</head>

<body class="bg-dark bg-opacity-75">
<div class="container vh-100">

    <div class="row justify-content-center">
        <div class="col-6 mt-5 p-5 justify-content-center bg-white rounded">
            <form method="post" action="${pageContext.request.contextPath}/login">
                <!-- UserName input -->
                <div class="mb-2">
                    <label class="form-label" for="form21">Username</label>
                    <input type="text" id="form21" name="username" class="form-control" />
                </div>

                <!-- Password input -->
                <div class="mb-4">
                    <label class="form-label" for="form22">Password</label>
                    <input type="password" id="form22" name="password" class="form-control" />
                </div>
                <!-- Submit button -->
                <div class="mb-4">
                    <button type="submit" class="btn btn-primary btn-block">Submit</button>
                </div>
            </form>
            <a href="${pageContext.request.contextPath}/register">New user? Click here to create an account. </a>
        </div>
    </div>
</div>
<script>

</script>

</body>

</html>
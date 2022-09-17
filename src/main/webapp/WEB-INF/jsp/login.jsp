<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <script src="js/bootstrap.min.js"></script>
</head>

<body class="bg-dark bg-opacity-75">
<div class="container vh-100">

    <div class="row vh-100">
        <div class="col-6 m-auto p-5 justify-content-center bg-white rounded">
            <form method="post" action="/login">
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

                <!-- Register buttons
                <div class="text-center">
                    <p>Not a member? <a href="#!">Register</a></p>
                    <p>or sign up with:</p>
                    <button type="button" class="btn btn-link btn-floating mx-1">
                        <i class="fab fa-facebook-f"></i>
                    </button>

                    <button type="button" class="btn btn-link btn-floating mx-1">
                        <i class="fab fa-google"></i>
                    </button>

                    <button type="button" class="btn btn-link btn-floating mx-1">
                        <i class="fab fa-twitter"></i>
                    </button>

                    <button type="button" class="btn btn-link btn-floating mx-1">
                        <i class="fab fa-github"></i>
                    </button>
                </div>
                -->
            </form>
        </div>
    </div>
</div>
<script>

</script>
</body>

</html>
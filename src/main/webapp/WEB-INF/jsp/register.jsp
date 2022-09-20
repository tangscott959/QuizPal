<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>register</title>
    <!-- CSS only -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container vh-100">

    <div class="row justify-content-center">
        <div class="col-6 mt-5 p-5 bg-white rounded">
            <form method="post" action="/register">
                <div class="row">
                    <div class="col-12 mb-2">
                        <label class="form-label" for="form11">Username</label>
                        <input type="text" id="form11" name="username" class="form-control" />
                    </div>


                    <div class="col-12 mb-4">
                        <label class="form-label" for="form12">Password</label>
                        <input type="password" id="form12" name="password" class="form-control" />
                    </div>
                    <div class="col-6 mb-2">
                        <label class="form-label" for="form13">FirstName</label>
                        <input type="text" id="form13" name="firstname" class="form-control" />
                    </div>
                    <div class="col-6 mb-2">
                        <label class="form-label" for="form14">LastName</label>
                        <input type="text" id="form14" name="lastname" class="form-control" />
                    </div>
                    <div class="col-6 mb-2">
                        <label class="form-label" for="form15">Email</label>
                        <input type="text" id="form15" name="email" class="form-control" />
                    </div>
                    <div class="col-6 mb-2">
                        <label class="form-label" for="form16">Phone</label>
                        <input type="text" id="form16" name="phone" class="form-control" />
                    </div>
                    <div class="col mb-4">
                        <button type="submit" class="btn btn-primary btn-block">Submit</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>

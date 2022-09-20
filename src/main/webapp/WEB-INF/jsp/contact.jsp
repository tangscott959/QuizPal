<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Contact</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>

<body>
<%-- div is for grouping items --%>
<div>
    <div class = "container vh-100">
        <div class="row justify-content-center">
            <div class="col-6 mt-5 p-5 bg-white rounded">
                <form method="post" action="/contact">
                    <div class="row">
                        <div class="col-12 mb-2">
                            <label class="form-label" for="form11">FirstName</label>
                            <input type="text" id="form11" name="firstname" class="form-control" />
                        </div>


                        <div class="col-12 mb-2">
                            <label class="form-label" for="form12">LastName</label>
                            <input type="text" id="form12" name="lastname" class="form-control" />
                        </div>
                        <div class="col-12 mb-2">
                            <label class="form-label" for="form13">Subject</label>
                            <input type="text" id="form13" name="subject" class="form-control" />
                        </div>
                        <div class="col-12 mb-2">
                            <label class="form-label" for="form13">message</label>
                            <input type="text" id="form14" name="message" class="form-control" />
                        </div>

                        <div class="col-12 mb-2">
                            <button id ="btn" type="submit" class="btn btn-primary btn-block"><span>Submit</span></button>
                        </div>
                        <div class=" text-center">
                            <a href="/quizindex" class = "card-link text-center"> Back to Quiz Page </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

    </div>
</div>
</body>

</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>QuizDetails</title>
</head>
<jsp:include page="nav.jsp" flush="true" />
<body>
<div class="container">

    <div class="row justify-content-center">
        <div class="col-6 mb-5 bg-info">
            <div class="card" >
                <div class="card-body">
                    <h5 class="card-title">Quiz Results of user2 - Pokeman</h5>

                    <ul class="list-group list-group-flush justify-content-center">
                        <li class="list-group-item">Quiz ID:8</li>
                        <li class="list-group-item">Quiz Name: user2-Pokeman</li>
                        <li class="list-group-item">Score 2/5</li>
                        <li class="list-group-item">Start TIme: 2022-9-3 12:21</li>
                        <li class="list-group-item">End TIme: 2022-9-3 12:41</li>
                        <li class="list-group-item">Result: Quiz failed</li>
                    </ul>
                    <a href="#" class="card-link">Take Another Quiz</a>
                </div>
            </div>
        </div>
    </div>
    <div class="col-8 text-center">
        <h5>Your Quiz Response and Answers</h5>
    </div>
    <div class="row justify-content-center">
        <div class="col-6 mb-5 bg-info">
            <div class="card" >
                <div class="card-body">
                    <h5 class="card-title">Question 1 --{}</h5>

                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>QuizDetails</title>
</head>
<style>

</style>
<jsp:include page="nav.jsp" flush="true" />
<body class="bg-light">
<div class="container">

    <div class="row justify-content-center">

            <div class="card" style="width: 38rem;" >
                <div class="card-body">
                    <h5 class="card-title">Quiz Results of <strong>${user.getFullName()}</strong></h5>

                    <ul class="list-group list-group-flush ">
                        <li class="list-group-item">Quiz ID: ${quizdetail.getQuizId()}</li>
                        <li class="list-group-item">Quiz Name: ${quizdetail.getQuizName()}</li>
                        <li class="list-group-item">Score ${score}/5</li>
                        <li class="list-group-item">Start Time: ${quizdetail.getQuizTimeStart()}</li>
                        <li class="list-group-item">End Time: ${quizdetail.getQuizTimeEnd()}</li>
                        <c:if test="${score > 2 }">
                            <li class="list-group-item text-success">Result: Quiz passed</li>
                        </c:if>
                        <c:if test="${score <= 2 }">
                            <li class="list-group-item text-danger">Result: Quiz failed</li>
                        </c:if>

                    </ul>
                    <div class="text-center">
                        <a href="#" class="card-link text-center">Take Another Quiz</a>
                    </div>
                </div>
            </div>
            <div class="gy-5">
                Your Quiz Response and Answers
            </div>
        <c:forEach var="qq" items="${qqlist}">
            <div class="card gy-5" style="width: 38rem;" >
                <div class="card-body">
                    <h5 class="card-title">Question <strong>${qq.getQuestionId()}</strong></h5>
                    Correct Answer :
                    <div class="text-center">
                        <a href="#" class="card-link text-center">Take Another Quiz</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>

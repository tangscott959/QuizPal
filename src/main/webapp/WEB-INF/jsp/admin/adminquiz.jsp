<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>QuizDetails</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
</head>
<style>

</style>
<body>
<div class="container bg-light">

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
                </div>
            </div>
        <div class="gy-5">
            <h4>Your Quiz Response and Answers</h4>
        </div>
        <c:forEach var="qc" items="${qclist}" varStatus="status">
            <div class="card gy-5" style="width: 48rem;" >
                <div class="card-body">
                    <h5 class="card-title">Question-${status.count}:&nbsp&nbsp<strong class="pl-3">${qc.getDescription()}</strong></h5>
                    <div>
                    <c:forEach var="choice" items="${qc.getChoiceList()}">
                        <c:if test="${choice.getIs_correct() == 1 }">
                            <c:set var="answer" value='${choice.getChoice_description()}' />
                        </c:if>
                        <div class=" form-check">
                            <input class="form-check-input" type="radio"  value="1"
                                   ${choice.getChoice_id() == qc.getUserChoice()  ? "checked=\"checked\"" : ""} disabled>
                            <label class="form-check-label" >
                                ${choice.getChoice_description()}
                            </label>
                        </div>
                    </c:forEach>
                        <div>
                            Correct Answer : ${answer}
                        </div>
                    </div>

                </div>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>

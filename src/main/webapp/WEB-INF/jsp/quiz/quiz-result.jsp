<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>QuizPal - Result</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #f8fafc 0%, #eef2ff 100%);
        }
        .result-card,
        .answer-card {
            border: 0;
            border-radius: 22px;
            box-shadow: 0 14px 38px rgba(15, 23, 42, 0.09);
        }
    </style>
</head>
<jsp:include page="../nav.jsp" flush="true" />
<body>
<div class="container pb-5">
    <div class="row justify-content-center">
        <div class="card result-card mb-5" style="max-width: 42rem;">
            <div class="card-body p-4 p-md-5">
                <p class="text-uppercase text-primary fw-semibold mb-2">Quiz complete</p>
                <h3 class="card-title fw-bold">Quiz Results for <strong>${user.fullName}</strong></h3>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item">Quiz ID: ${quiz.quizId}</li>
                    <li class="list-group-item">Quiz Name: ${quiz.quizName}</li>
                    <li class="list-group-item">Score: ${score}/5</li>
                    <li class="list-group-item">Start Time: ${quiz.quizTimeStart}</li>
                    <li class="list-group-item">End Time: ${quiz.quizTimeEnd}</li>
                    <c:if test="${score > 2}">
                        <li class="list-group-item text-success">Result: Quiz passed</li>
                    </c:if>
                    <c:if test="${score <= 2}">
                        <li class="list-group-item text-danger">Result: Quiz failed</li>
                    </c:if>
                </ul>
                <div class="text-center mt-3">
                    <a href="${pageContext.request.contextPath}/quiz/index" class="btn btn-primary">Take Another Quiz</a>
                </div>
            </div>
        </div>

        <div class="col-12">
            <h4 class="fw-bold mb-3">Your Quiz Response and Answers</h4>
        </div>
        <c:forEach var="qc" items="${qclist}" varStatus="status">
            <div class="card answer-card mb-4" style="max-width: 52rem;">
                <div class="card-body p-4">
                    <h5 class="card-title">Question ${status.count}: <strong>${qc.description}</strong></h5>
                    <c:forEach var="choice" items="${qc.choiceList}">
                        <c:if test="${choice.is_correct == 1}">
                            <c:set var="answer" value="${choice.choice_description}" />
                        </c:if>
                        <div class="form-check">
                            <input class="form-check-input" type="radio"
                                   ${choice.choice_id == qc.userChoice ? "checked=\"checked\"" : ""} disabled>
                            <label class="form-check-label">
                                ${choice.choice_description}
                            </label>
                        </div>
                    </c:forEach>
                    <div class="mt-2">Correct Answer: ${answer}</div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>

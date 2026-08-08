<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>QuizPal - Question</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #f8fafc 0%, #eef2ff 100%);
        }
        .question-card {
            border: 0;
            border-radius: 24px;
            box-shadow: 0 16px 44px rgba(15, 23, 42, 0.1);
        }
        .btn-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: 0;
            color: #fff;
            font-weight: 600;
        }
        .btn-gradient:hover {
            color: #fff;
            filter: brightness(1.05);
        }
        .quiz-timer {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.65rem 1rem;
            border-radius: 999px;
            background: #eef2ff;
            color: #3730a3;
            font-weight: 700;
            font-variant-numeric: tabular-nums;
        }
        .quiz-timer.warning {
            background: #fef3c7;
            color: #b45309;
        }
        .quiz-timer.expired {
            background: #fee2e2;
            color: #b91c1c;
        }
    </style>
</head>
<jsp:include page="../nav.jsp" flush="true" />
<body>
<div class="container pb-5">
    <div class="row">
        <div class="col-12 d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3 mb-4">
            <div>
                <p class="text-uppercase text-primary fw-semibold mb-2">Quiz in progress</p>
                <h3 class="fw-bold mb-0">Question ${questionIndex + 1} / ${totalQuestions}</h3>
            </div>
            <div id="quiz-timer" class="quiz-timer" aria-live="polite">
                <span>Time left</span>
                <span id="quiz-timer-value">${timeLimitMinutes}:00</span>
            </div>
        </div>
        <div class="col-lg-8">
            <div class="card question-card">
                <div class="card-body p-4 p-md-5">
                    <h4 class="card-title fw-bold mb-4">${question.quiz_description}</h4>
                    <form action="${pageContext.request.contextPath}/quiz/answer" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <input type="hidden" name="quizId" value="${quiz.quizId}" />
                        <input type="hidden" name="questionId" value="${question.question_id}" />
                        <c:forEach var="choice" items="${choices}">
                            <div class="form-check border rounded-3 p-3 ps-5 my-3 bg-light">
                                <input class="form-check-input" type="radio" name="selectedChoiceId"
                                       id="choice-${choice.choice_id}" value="${choice.choice_id}" required>
                                <label class="form-check-label" for="choice-${choice.choice_id}">
                                    ${choice.choice_description}
                                </label>
                            </div>
                        </c:forEach>
                        <button type="submit" class="btn btn-gradient px-4 mt-3">
                            <c:choose>
                                <c:when test="${questionIndex + 1 == totalQuestions}">Finish Quiz</c:when>
                                <c:otherwise>Next Question</c:otherwise>
                            </c:choose>
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    (function () {
        const deadline = ${timerDeadlineEpochMs};
        const quizId = ${quiz.quizId};
        const completeUrl = '${pageContext.request.contextPath}/quiz/complete?quizId=' + quizId;
        const timerValue = document.getElementById('quiz-timer-value');
        const timerBadge = document.getElementById('quiz-timer');

        function pad(value) {
            return value < 10 ? '0' + value : String(value);
        }

        function updateTimer() {
            const remainingMs = deadline - Date.now();
            if (remainingMs <= 0) {
                timerValue.textContent = '0:00';
                timerBadge.classList.add('expired');
                window.location.href = completeUrl;
                return;
            }

            const totalSeconds = Math.floor(remainingMs / 1000);
            const minutes = Math.floor(totalSeconds / 60);
            const seconds = totalSeconds % 60;
            timerValue.textContent = minutes + ':' + pad(seconds);

            timerBadge.classList.toggle('warning', totalSeconds <= 60);
        }

        updateTimer();
        setInterval(updateTimer, 1000);
    })();
</script>
</body>
</html>

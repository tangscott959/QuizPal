<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>QuizPal - Quizzes</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #f8fafc 0%, #eef2ff 50%, #f5f3ff 100%);
            color: #111827;
        }
        .hero-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: 0;
            border-radius: 28px;
            color: #fff;
            box-shadow: 0 18px 50px rgba(102, 126, 234, 0.25);
        }
        .quiz-card {
            border: 0;
            border-radius: 20px;
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.08);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .quiz-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 18px 42px rgba(15, 23, 42, 0.12);
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
        .results-card {
            border: 0;
            border-radius: 20px;
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.08);
            overflow: hidden;
        }
    </style>
</head>
<jsp:include page="../nav.jsp" flush="true" />
<body>
<div class="container pb-5">
    <div class="hero-card p-4 p-md-5 mb-4">
        <p class="text-uppercase fw-semibold opacity-75 mb-2">Welcome back</p>
        <h1 class="display-6 fw-bold mb-2">Choose a Quiz</h1>
        <p class="mb-0 opacity-75">Pick a category and answer five random questions.</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <c:if test="${not empty inProgressQuiz}">
        <div class="alert alert-warning d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3">
            <div>
                <strong>Quiz in progress:</strong> ${inProgressQuiz.quizName}
                (${inProgressAnsweredCount} / ${inProgressQuiz.totalQuestions} answered)
            </div>
            <a class="btn btn-gradient"
               href="${pageContext.request.contextPath}/quiz/question?quizId=${inProgressQuiz.quizId}">
                Resume Quiz
            </a>
        </div>
    </c:if>

    <div class="row g-4">
        <c:forEach var="category" items="${categories}">
            <div class="col-sm-6 col-lg-3">
                <div class="card quiz-card h-100">
                    <div class="card-body p-4">
                        <div class="rounded-circle bg-primary-subtle text-primary d-inline-flex align-items-center justify-content-center mb-3" style="width: 48px; height: 48px;">
                            <strong>${category.categoryId}</strong>
                        </div>
                        <h4 class="card-title fw-bold">${category.categoryName}</h4>
                        <p class="card-text text-muted">Five random questions.</p>
                        <a class="btn btn-gradient w-100"
                           href="${pageContext.request.contextPath}/quiz/start?categoryId=${category.categoryId}&timeLimit=15">
                            Start Quiz
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <div class="row mt-5">
        <div class="col-12">
            <div class="d-flex align-items-center justify-content-between mb-3">
                <h3 class="fw-bold mb-0">Past Quizzes</h3>
            </div>
            <div class="card results-card">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th>Quiz ID</th>
                    <th>Quiz Name</th>
                    <th>Start Time</th>
                    <th>End Time</th>
                    <th>Score</th>
                    <th>Details</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${userQuizzes}" var="quiz">
                    <tr>
                        <td>${quiz.quizId}</td>
                        <td>${quiz.quizName}</td>
                        <td><fmt:formatDate value="${quiz.quizTimeStart}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td><fmt:formatDate value="${quiz.quizTimeEnd}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td>${scoreMap[quiz.quizId] != null ? scoreMap[quiz.quizId] : 0}/5</td>
                        <td>
                            <a class="btn btn-outline-info"
                               href="${pageContext.request.contextPath}/quiz/result?quizId=${quiz.quizId}">
                                Details
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>

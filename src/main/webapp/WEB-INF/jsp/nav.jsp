<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .quizpal-navbar {
        background: rgba(15, 12, 41, 0.95);
        box-shadow: 0 4px 24px rgba(15, 12, 41, 0.18);
    }
    .quizpal-navbar .navbar-brand,
    .quizpal-navbar .nav-link,
    .quizpal-navbar .logout-button {
        color: #fff;
        font-weight: 600;
    }
    .quizpal-navbar .nav-link:hover,
    .quizpal-navbar .logout-button:hover {
        color: #c7d2fe;
    }
    .quizpal-navbar .logout-button {
        background: transparent;
        border: 0;
        padding: 0.5rem 0;
    }
</style>
<nav class="navbar navbar-expand-lg quizpal-navbar mb-5">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/quiz/index">QuizPal</a>
        <div class="navbar-nav ms-auto align-items-lg-center gap-lg-3">
            <a class="nav-link" href="${pageContext.request.contextPath}/quiz/index">Home</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/feedback">Feedback</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/contact">Contact Us</a>
            <form action="${pageContext.request.contextPath}/logout" method="post" class="mb-0">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <button class="logout-button" type="submit">Logout</button>
            </form>
        </div>
    </div>
</nav>
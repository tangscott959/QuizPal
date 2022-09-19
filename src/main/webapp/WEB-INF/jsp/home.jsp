<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
    <title>QuizMe</title>
</head>
<jsp:include page="nav.jsp" flush="true" />
<body>
<div class="container ">
    <%if(session.getAttribute("user") ==null) {%>
    <div class="mt-3">
        <h3>please<a href="/login"> log in</a> first</h3>
    </div>
    <%} else { %>
    <div class="row">
        <c:forEach var="quizType" items="${quizTypeList}">
            <div class="col-sm-4 ">
                <div class="card border-primary mb-3" style="max-width: 25rem;">

                    <div class="card-body">
                        <h4 class="card-title"><c:out value="${quizType.getCategoryId()}"/></h4>
                        <p class="card-text"><c:out value="${quizType.getCategoryName()}"/></p>
                        <form action="${pageContext.request.contextPath}/doquiz" method="GET">
                            <div class="form-group">
                                <input type="hidden" class="form-control" name="qtid" value="${quizType.getCategoryId()}">
                                <input type="hidden" class="form-control" name="lefttime" value="15">
                            </div>
                            <div class="form-group">
                                <input type="hidden" class="form-control" name="page" value="0">
                            </div>
                            <div class="form-group">
                                <button type="submit" name="action" value="init" class="btn btn-primary btn-block">Start Quiz</button>
                            </div>

                        </form>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    <div class="row  mt-5">
        <div class="justify-content-center">
            <h3>${rows.get(0).getUser().getName()} Past Quizzes</h3>
        </div>

        <table class="table table-striped">
            <thead>
            <tr>
                <th class="col-1">Quiz ID</th>
                <th class="col-2">Quiz Name</th>
                <th class="col-2">Category</th>
                <th class="col-2">Start Time</th>
                <th class="col-2">End Time</th>
                <th class="col-1">Score</th>
                <th class="col-1">Details</th>
            </tr>
            </thead>
            <c:forEach items="${quizList}" var="result">
                <c:set var="Key" value='${result.getQuizId().toString()}' />
                <tr>
                    <td class="col-1">${result.getQuizId()}</td>
                    <td class="col-2">${result.getQuizName()}</td>
                    <td class="col-2">${result.getCategoryId()}</td>
                    <td class="col-2"><fmt:formatDate value="${result.getQuizTimeStart()}" type="date"
                                                         pattern="yyyy-MM-dd HH:mm"/></td>
                    <td class="col-2"><fmt:formatDate value="${result.getQuizTimeEnd()}" type="date"
                                                  pattern="yyyy-MM-dd HH:mm"/></td>
                    <td class="col-md-1">${scoreMap.get(Key)!=null ? scoreMap.get(Key) : 0}/5</td>
                    <td class="col-md-2"><a class="btn btn-default"
                                            href="${pageContext.request.contextPath}/quiz/resultdetail?resultId=${result.getQuizId()}"
                                            role="button">Details</a></td>

                </tr>
            </c:forEach>
        </table>

    </div>
    <% } %>
</div>
</body>
</html>
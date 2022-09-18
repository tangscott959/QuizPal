<<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>QuizMe</title>

</head>
<jsp:include page="nav.jsp" flush="true" />
<body>
<div class="container">
    <%if(session.getAttribute("user") ==null) {%>
    <h3>please<a href="/login"> log in</a> first</h3>
    <%} else { %>
    <div class="row">
        <c:forEach var="quizType" items="${quizTypeList}">
            <div class="col-sm-4">
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

    <% } %>
</div>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Quiz</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <script src="js/bootstrap.min.js"></script>
</head>

<body>
<div>

    <form method="post" action="/quiz">

        <%-- Question description --%>
        <p>${question.description}</p>

        <%-- Dynamically render the choices --%>
        <c:forEach items="${question.choices}" var="choice" varStatus="loop">
            <div>
                <input type="radio"
                       name="selectedChoiceId"
                       value="${choice.id}"/>
                    ${choice.description}
            </div>
        </c:forEach>

        <%-- Button to submit quiz --%>
        <button type="submit">submit</button>

    </form>
</div>
</body>
</html>

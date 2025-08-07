<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Edit Questions</title>
</head>
<body>
<h2>Edit Questions</h2>
<table border="1">
    <thead>
    <tr>
        <th>Question ID</th>
        <th>Description</th>
        <th>Choices</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="item" items="${questionChoiceList}">
        <tr>
            <form action="/admin/updateQuestion" method="post">
                <td>
                    <input type="hidden" name="questionId" value="${item.questionId}" />
                        ${item.questionId}
                </td>
                <td>
                    <input type="text" name="description" value="${item.description}" />
                </td>
                <td>
                    <ul>
                        <c:forEach var="choice" items="${item.choiceList}" varStatus="status">
                            <li>
                                <!-- Include choice ID as hidden field -->
                                <input type="hidden" name="choiceIds" value="${choice.choice_id}" />
                                <input type="text" name="choices" value="${choice.choice_description}" />
                                <c:if test="${choice.is_correct == 1}">(Correct)</c:if>
                            </li>
                        </c:forEach>
                    </ul>
                </td>
                <td>
                    <input type="submit" value="Update" />
                </td>
            </form>
        </tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>
<form action="/admin/adminindex" method="get">
    <button type="submit">Back to Admin Home</button>
</form>

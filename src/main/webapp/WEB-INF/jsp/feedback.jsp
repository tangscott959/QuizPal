<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Feedback</title>
</head>

<body>
<%-- div is for grouping items --%>
<div>
    <form method="post" action="/feedback">





        <div>
            <label>Message</label>
            <input type="text" name="message">
        </div>
        <div>
            <label>Rating</label>
            <input type="text" name="rating">
        </div>
        <div>
            <label>Subject</label>
            <input type="text" name="subject">
        </div>

        <button type="submit">Submit</button>
    </form>

</div>
</body>

</html>
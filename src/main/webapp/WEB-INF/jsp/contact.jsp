<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Contact</title>
</head>

<body>
<%-- div is for grouping items --%>
<div>
    <form method="post" action="/contact">
        <div>
            <label>FirstName</label>
            <input type="text" name="firstname">
        </div>
        <div>
            <label>LastName</label>
            <input type="text" name="lastname">
        </div>
        <div>
            <label>Subject</label>
            <input type="text" name="subject">
        </div>


        <div>
            <label>Message</label>
            <input type="text" name="message">
        </div>

        <button type="submit">Submit</button>
    </form>

</div>
</body>

</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
</head>

<body>
<%-- div is for grouping items --%>
<div>
    <form method="post" action="/register">
        <div>
            <label>Username</label>
            <input type="text" name="username">
        </div>
        <div>
            <label>Password</label>
            <input type="password" name="password">
        </div>
        <div>
            <label>Firstname</label>
            <input type="text" name="firstname">
        </div>
        <div>
            <label>Lastname</label>
            <input type="text" name="lastname">
        </div>
        <div>
            <label>Email</label>
            <input type="text" name="email">
        </div>
        <div>
            <label>Phone</label>
            <input type="text" name="phone">
        </div>
        <button type="submit">Submit</button>
    </form>

</div>
</body>

</html>

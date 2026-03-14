<!DOCTYPE html>
<html>
<head>
    <title>Registration</title>
    <meta charset="UTF-8">
</head>
<body>
<h2>Register</h2>

<#if error??>
    <p style="color: red;">${error}</p>
</#if>

<form action="/forms/register" method="post">
    <div>
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required>
    </div>
    <div>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required>
    </div>
    <div>
        <button type="submit">Register</button>
    </div>
</form>

<p>Already have an account? <a href="/login">Login here</a></p>
</body>
</html>
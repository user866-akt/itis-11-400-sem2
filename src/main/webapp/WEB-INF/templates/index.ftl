<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            text-align: center;
        }
        .links {
            margin-top: 30px;
        }
        .links a {
            margin: 0 10px;
            padding: 10px 20px;
            text-decoration: none;
            background-color: #4CAF50;
            color: white;
            border-radius: 5px;
            display: inline-block;
        }
        .links a:hover {
            background-color: #45a049;
        }
        .logout-btn {
            background-color: #f44336;
        }
        .logout-btn:hover {
            background-color: #da190b;
        }
        .admin-btn {
            background-color: #ff9800;
        }
        .admin-btn:hover {
            background-color: #fb8c00;
        }
        .user-info {
            margin-bottom: 20px;
            padding: 10px;
            background-color: #e8f5e9;
            border-radius: 5px;
        }
    </style>
</head>
<body>
<h1>Welcome to Notes App</h1>

<#if user??>
    <div class="user-info">
        Hello, ${user.username}! You are logged in.
        <p>Roles:
            <#if user.getUser().roles??>
                <#list user.getUser().roles as role>
                    ${role.name}
                </#list>
            </#if>
        </p>
    </div>

    <div class="links">
        <a href="/notes">My Notes</a>
        <a href="/notes/public">Public Notes</a>
        <#if user.isAdmin()>
            <a href="/admin/notes" class="admin-btn">Admin Panel</a>
        </#if>
        <a href="/logout" class="logout-btn">Logout</a>
    </div>
<#else>
    <div class="links">
        <a href="/login">Login</a>
        <a href="/register">Register</a>
        <a href="/notes/public">Public Notes</a>
    </div>
</#if>
</body>
</html>
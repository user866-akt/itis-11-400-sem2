<!DOCTYPE html>
<html>
<head>
    <title>Public Notes</title>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            margin: 0;
            font-size: 24px;
        }

        .nav {
            display: flex;
            gap: 15px;
        }

        .nav a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            background-color: rgba(255,255,255,0.2);
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        .nav a:hover {
            background-color: rgba(255,255,255,0.3);
        }

        .note {
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
            background-color: #f9f9f9;
        }

        .note-title {
            font-size: 1.5em;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .note-content {
            margin-bottom: 10px;
            line-height: 1.6;
        }

        .note-meta {
            font-size: 0.9em;
            color: #666;
            margin-bottom: 10px;
        }

        .public-badge {
            background-color: #ff9800;
            color: white;
            padding: 3px 8px;
            border-radius: 3px;
            font-size: 0.8em;
            margin-left: 10px;
        }

        .login-link {
            background-color: #2196F3;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
            margin-top: 20px;
        }

        .login-link:hover {
            background-color: #0b7dda;
        }
    </style>
</head>
<body>
<div class="header">
    <h1>Public Notes</h1>
    <div class="nav">
        <#if user??>
            <a href="/notes">My Notes</a>
        </#if>
        <a href="/notes/public">Public Notes</a>
        <a href="/">Home</a>
        <#if user?? && user.isAdmin()>
            <a href="/admin/notes" style="background-color: #ff9800;">Admin Panel</a>
        </#if>
        <#if user??>
            <a href="/logout">Logout</a>
        <#else>
            <a href="/login">Login</a>
            <a href="/register">Register</a>
        </#if>
    </div>
</div>

<#if notes?has_content>
    <#list notes as note>
        <div class="note">
            <div class="note-title">
                ${note.title}
                <span class="public-badge">Public</span>
            </div>
            <div class="note-meta">
                Author: ${note.authorUsername} | Created: ${note.createdAtAsDate?string('yyyy-MM-dd HH:mm:ss')}
            </div>
            <div class="note-content">
                ${note.content}
            </div>
        </div>
    </#list>
<#else>
    <p>No public notes available.</p>
</#if>

<#if !(user??)>
    <div>
        <a href="/login" class="login-link">Login to create your own notes</a>
    </div>
</#if>
</body>
</html>
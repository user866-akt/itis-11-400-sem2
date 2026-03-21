<!DOCTYPE html>
<html>
<head>
    <title>My Notes</title>
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

        .create-btn {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
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

        .note-actions {
            margin-top: 10px;
        }

        .edit-btn {
            background-color: #2196F3;
            color: white;
            padding: 5px 10px;
            text-decoration: none;
            border-radius: 3px;
            margin-right: 10px;
            border: none;
            cursor: pointer;
            display: inline-block;
        }

        .delete-btn {
            background-color: #f44336;
            color: white;
            padding: 5px 10px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }

        .public-badge {
            background-color: #ff9800;
            color: white;
            padding: 3px 8px;
            border-radius: 3px;
            font-size: 0.8em;
            margin-left: 10px;
        }

        .private-badge {
            background-color: #9e9e9e;
            color: white;
            padding: 3px 8px;
            border-radius: 3px;
            font-size: 0.8em;
            margin-left: 10px;
        }

        .success {
            background-color: #d4edda;
            color: #155724;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<div class="header">
    <h1>My Notes</h1>
    <div class="nav">
        <a href="/notes">My Notes</a>
        <a href="/notes/public">Public Notes</a>
        <a href="/">Home</a>
        <a href="/admin/notes" style="background-color: #ff9800;">Admin Panel</a>
        <a href="/logout">Logout</a>
    </div>
</div>

<div style="margin-bottom: 20px; text-align: right;">
    <a href="/notes/create" class="create-btn">Create New Note</a>
</div>

<#if success??>
    <div class="success">${success}</div>
</#if>

<#if error??>
    <div class="error">${error}</div>
</#if>

<#if notes?has_content>
    <#list notes as note>
        <div class="note">
            <div class="note-title">
                ${note.title}
                <#if note.public>
                    <span class="public-badge">Public</span>
                <#else>
                    <span class="private-badge">Private</span>
                </#if>
            </div>
            <div class="note-meta">
                Created: ${note.createdAtAsDate?string('yyyy-MM-dd HH:mm:ss')}
            </div>
            <div class="note-content">
                ${note.content}
            </div>
            <div class="note-actions">
                <a href="/notes/${note.id}/edit" class="edit-btn">Edit</a>
                <form action="/notes/${note.id}/delete" method="post" style="display: inline;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="delete-btn" onclick="return confirm('Are you sure you want to delete this note?')">Delete</button>
                </form>
            </div>
        </div>
    </#list>
<#else>
    <p>No notes yet. <a href="/notes/create">Create your first note!</a></p>
</#if>
</body>
</html>
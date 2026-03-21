<!DOCTYPE html>
<html>
<head>
    <title><#if isEdit>Edit Note<#else>Create Note</#if></title>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"],
        textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-family: Arial, sans-serif;
        }
        textarea {
            min-height: 200px;
            resize: vertical;
        }
        input[type="checkbox"] {
            margin-right: 5px;
        }
        .submit-btn {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .cancel-btn {
            background-color: #9e9e9e;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            margin-left: 10px;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .nav {
            margin-bottom: 20px;
        }
        .nav a {
            margin-right: 15px;
            text-decoration: none;
        }
    </style>
</head>
<body>
<div class="nav">
    <a href="/notes">My Notes</a>
    <a href="/notes/public">Public Notes</a>
    <a href="/">Home</a>
    <a href="/logout">Logout</a>
</div>

<h1><#if isEdit>Edit Note<#else>Create New Note</#if></h1>

<#if error??>
    <div class="error">${error}</div>
</#if>

<form action="<#if isEdit>/notes/${note.id}/edit<#else>/notes/create</#if>" method="post">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <div class="form-group">
        <label for="title">Title:</label>
        <input type="text" id="title" name="title" value="${(note.title)!''}" required>
    </div>

    <div class="form-group">
        <label for="content">Content:</label>
        <textarea id="content" name="content" required>${(note.content)!''}</textarea>
    </div>

    <div class="form-group">
        <input type="checkbox" id="isPublic" name="isPublic" value="true" <#if (note.public)!false>checked</#if>>
        <label for="isPublic" style="display: inline;">Make this note public</label>
    </div>

    <div class="form-group">
        <button type="submit" class="submit-btn">
            <#if isEdit>Update Note<#else>Create Note</#if>
        </button>
        <a href="/notes" class="cancel-btn">Cancel</a>
    </div>
</form>
</body>
</html>
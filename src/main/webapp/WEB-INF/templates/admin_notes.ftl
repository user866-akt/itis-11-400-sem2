<!DOCTYPE html>
<html>
<head>
    <title>Admin - All Notes</title>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 1400px;
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

        .stats {
            background-color: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .stats p {
            margin: 0;
            font-size: 16px;
            color: #666;
        }

        .stats strong {
            color: #667eea;
            font-size: 20px;
        }

        .success {
            background-color: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #28a745;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #dc3545;
        }

        table {
            width: 100%;
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        th {
            background-color: #667eea;
            color: white;
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }

        td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }

        tr:hover {
            background-color: #f8f9fa;
        }

        .note-title {
            font-weight: 600;
            color: #333;
        }

        .note-content {
            max-width: 400px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            color: #666;
        }

        .public-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 3px;
            font-size: 11px;
            font-weight: bold;
            background-color: #ff9800;
            color: white;
        }

        .private-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 3px;
            font-size: 11px;
            font-weight: bold;
            background-color: #9e9e9e;
            color: white;
        }

        .delete-btn {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 12px;
            transition: background-color 0.3s;
        }

        .delete-btn:hover {
            background-color: #c82333;
        }

        .no-notes {
            text-align: center;
            padding: 40px;
            background-color: white;
            border-radius: 10px;
            color: #666;
        }

        .footer {
            margin-top: 30px;
            text-align: center;
            color: #666;
            font-size: 12px;
        }

        @media (max-width: 768px) {
            table {
                font-size: 12px;
            }

            td, th {
                padding: 8px;
            }

            .note-content {
                max-width: 150px;
            }
        }
    </style>
</head>
<body>
<div class="header">
    <h1>Admin Dashboard - All Notes</h1>
    <div class="nav">
        <a href="/notes">My Notes</a>
        <a href="/notes/public">Public Notes</a>
        <a href="/">Home</a>
        <a href="/logout">Logout</a>
    </div>
</div>

<div class="stats">
    <p>Total notes: <strong>${notes?size}</strong></p>
</div>

<#if success??>
    <div class="success">
        ${success}
    </div>
</#if>

<#if error??>
    <div class="error">
        ${error}
    </div>
</#if>

<#if notes?has_content>
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Content</th>
            <th>Author</th>
            <th>Created</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <#list notes as note>
            <tr>
                <td>${note.id}</td>
                <td class="note-title">${note.title}</td>
                <td class="note-content" title="${note.content}">${note.content}</td>
                <td>${note.authorUsername}</td>
                <td>${note.createdAtAsDate?string('yyyy-MM-dd HH:mm:ss')}</td>
                <td>
                    <#if note.public>
                        <span class="public-badge">Public</span>
                    <#else>
                        <span class="private-badge">Private</span>
                    </#if>
                </td>
                <td>
                    <form action="/admin/notes/${note.id}/delete" method="post" style="display: inline;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="delete-btn" onclick="return confirm('Are you sure you want to delete this note? This action cannot be undone.')">
                            Delete
                        </button>
                    </form>
                </td>
            </tr>
        </#list>
        </tbody>
    </table>
<#else>
    <div class="no-notes">
        <p>No notes found in the system.</p>
    </div>
</#if>

<div class="footer">
    <p>Admin Panel - You have full access to all notes</p>
</div>
</body>
</html>
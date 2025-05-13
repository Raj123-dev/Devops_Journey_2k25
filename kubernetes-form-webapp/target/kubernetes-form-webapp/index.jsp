<html>
<head>
    <title>Kubernetes Form WebApp</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f8; }
        .container { max-width: 400px; margin: 60px auto; background: #fff; padding: 32px; border-radius: 8px; box-shadow: 0 2px 8px #0001; }
        h2 { text-align: center; color: #1976d2; }
        label { display: block; margin-top: 16px; color: #333; }
        input[type="text"], input[type="email"] { width: 100%; padding: 8px; margin-top: 4px; border: 1px solid #ccc; border-radius: 4px; }
        button { margin-top: 24px; width: 100%; padding: 10px; background: #1976d2; color: #fff; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; }
        button:hover { background: #125ea2; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Submit Your Details</h2>
        <form method="post" action="submit">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required>
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
            <button type="submit">Submit</button>
        </form>
    </div>
</body>
</html>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu Inicial</title>
    
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            color: #333;
        }

        h3 {
            margin: 10px 0;
        }

        h2 {
            color: #4caf50;
            text-align: center;
            font-size: 1.5em;
        }

        form {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 300px;
            margin: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        label {
            display: block;
            margin: 10px 0;
            color: #555;
            text-align: left;
        }

        input {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        button {
            background-color: #4caf50;
            color: #fff;
            padding: 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #45a049;
        }

        .container {
            text-align: center;
            margin-top: 30px;
        }

        .container h3 {
            font-size: 18px;
            margin-bottom: 5px;
            color: #555;
        }

        .container h2 {
            font-size: 24px;
            margin-bottom: 20px;
        }

        .container div {
            margin-top: 20px;
        }
    </style>
</head>
<body>

    <div class="container">
        <h3>SBD - Sistemas de Base de Dados</h3>
        <h3>Trabalho Prático 2</h3>
        <h3>Docente: Engº Porfírio Filipe</h3>
        <br>
        <h3>Trabalho Realizado Por:</h3>
        <h3>Gonçalo Alves, nº49705</h3>
        <h3>Ricardo Vieira, nº45871</h3>
    </div>

    <div>
        <h2>Login</h2>
        <form method="post" action="LoginServlet">
            <label for="username">Nome de Utilizador</label>
            <input type="text" name="username" id="username" />
            <label for="password">Palavra-Passe</label>
            <input type="password" name="password" id="password" />
            <button type="submit">Login</button>
        </form>
    </div>

</body>
</html>

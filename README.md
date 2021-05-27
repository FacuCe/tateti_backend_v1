# README

* `bundle install`
* `rails db:create db:migrate`
* `rails server`

* `rails version 2.7.2`

# <a name="top"></a> Documentacion de la API

- [Seguridad](#seguridad)
  - [Registrar Usuario](#registrar-usuario)
  - [Login](#login)
  - [Cambiar Password](#cambiar-password)
  - [Usuario Actual](#usuario-actual)
  - [Logout](#logout)

- [Jugabilidad](#jugabilidad)
  - [Nuevo Juego](#nuevo-juego)
  - [Jugar](#jugar)
  - [Juego Actual](#juego-actual)
  - [Lista de Juegos](#lista-de-juegos)


# <a name='seguridad'></a> Seguridad

## <a name='registrar-usuario'></a> Registrar Usuario
[Back to top](#top)

<p>Registra un nuevo usuario en el sistema.</p>

    POST /v1/user

### Examples

Body

```
{
  "name": "{Nombre de Usuario}",
  "login": "{Login de usuario}",
  "password": "{Contraseña}"
}
```

### Success Response

Respuesta

```
HTTP/1.1 200 OK
{
  "token": "{Token de autorización}"
}
```

### Error Response

400 Bad Request

```
HTTP/1.1 400 Bad Request
{
   "messages" : [
     {
       "path" : "{Nombre de la propiedad}",
       "message" : "{Motivo del error}"
     },
     ...
  ]
}
```

500 Server Error

```
HTTP/1.1 500 Internal Server Error
{
   "error" : "Not Found"
}
```



## <a name='login'></a> Login
[Back to top](#top)

<p>Loguea un usuario en el sistema.</p>

    POST /v1/user/signin

### Examples

Body

```
{
    "login":"{Login de usuario}",
    "password":"{Contraseña}"
}
```

### Success Response

Respuesta

```
HTTP/1.1 200 OK
{
    "token":"{Token de autorización}"
}
```

### Error Response

400 Bad Request

```
HTTP/1.1 400 Bad Request
{
    "messages":[
        {
            "path":"{Nombre de la propiedad}",
            "message":"{Motivo del error}"
        }
    ]
}
```

500 Server Error

```
HTTP/1.1 500 Internal Server Error
{
    "error":"Not Found"
}
```



## <a name='cambiar-password'></a> Cambiar Password
[Back to top](#top)

<p>Cambia la contraseña del usuario actual.</p>

    POST /v1/user/password

### Examples

Body

```
{
  "currentPassword" : "{Contraseña actual}",
  "newPassword" : "{Nueva Contraseña}",
}
```

Header Autorización

```
Authorization=bearer {token}
```

### Success Response

Respuesta

```
HTTP/1.1 200 OK
```

### Error Response

401 Unauthorized

```
HTTP/1.1 401 Unauthorized
```

400 Bad Request

```
HTTP/1.1 400 Bad Request
{
   "messages" : [
     {
       "path" : "{Nombre de la propiedad}",
       "message" : "{Motivo del error}"
     },
     ...
  ]
}
```

500 Server Error

```
HTTP/1.1 500 Internal Server Error
{
   "error" : "Not Found"
}
```



## <a name='usuario-actual'></a> Usuario Actual
[Back to top](#top)

<p>Obtiene información del usuario actual.</p>

    GET /v1/users/current

### Examples

Header Autorización

```
Authorization=bearer {token}
```

### Success Response

Respuesta

```
HTTP/1.1 200 OK
{
   "id": "{Id usuario}",
   "name": "{Nombre del usuario}",
   "login": "{Login de usuario}",
   "permissions": [
       "{Permission}"
   ]
}
```

### Error Response

401 Unauthorized

```
HTTP/1.1 401 Unauthorized
```

500 Server Error

```
HTTP/1.1 500 Internal Server Error
{
   "error" : "Not Found"
}
```



## <a name='logout'></a> Logout
[Back to top](#top)

<p>Desloguea un usuario en el sistema, invalida el token.</p>

    GET /v1/user/signout

### Examples

Header Autorización

```
Authorization=bearer {token}
```

### Success Response

Respuesta

```
HTTP/1.1 200 OK
```

### Error Response

401 Unauthorized

```
HTTP/1.1 401 Unauthorized
```

500 Server Error

```
HTTP/1.1 500 Internal Server Error
{
   "error" : "Not Found"
}
```



# <a name='jugabilidad'></a> Jugabilidad

## <a name='nuevo-juego'></a> Nuevo Juego
[Back to top](#top)

<p>Crea un nuevo juego o me devuelve el juego activo. Solo se puede tener un juego activo a la vez</p>

    POST /v1/games

### Examples

Header Autorización

```
Authorization=bearer {token}
```

### Success Response

Respuesta

```
HTTP/1.1 200 OK
{
   "current_player":"{de quién es el turno x/o}",
   "board":["","","","","","","","",""],
   "symbol":"{simbolo del jugador x/o}"
}
```

### Error Response

401 Unauthorized

```
HTTP/1.1 401 Unauthorized
```

500 Server Error

```
HTTP/1.1 500 Internal Server Error
{
   "error" : "Not Found"
}
```



## <a name='jugar'></a> Jugar
[Back to top](#top)

<p>Envío el movimiento para jugar</p>

    POST /v1/games/play

### Examples

Body

```
{
  "movement":{
      "square":{posicion del tablero, 0-8}
  }
}
```

Header Autorización

```
Authorization=bearer {token}
```

### Success Response

Respuesta

```
HTTP/1.1 200 OK
{
   "id":{game id},
   "board":["","","","","","","","",""],
   "players_complete":{true/false},
   "current_player":"{de quién es el turno x/o}",
   "game_over":{true/false},
   "tied_game":{true/false},
   "winner":"{ganador del juego}",
   ...
}
```

### Error Response

400 Bad Request

```
HTTP/1.1 400 Bad Request
{
   "msg":"{mensaje del error}"
}
```

401 Unauthorized

```
HTTP/1.1 401 Unauthorized
```

500 Server Error

```
HTTP/1.1 500 Internal Server Error
{
   "error" : "Not Found"
}
```



## <a name='juego-actual'></a> Juego Actual
[Back to top](#top)

<p>Me devuelve el juego activo o el último juego que estuvo activo</p>

    GET /v1/games/current

### Examples

Header Autorización

```
Authorization=bearer {token}
```

### Success Response

Respuesta

```
HTTP/1.1 200 OK
{
   "id":{game id},
   "board":["","","","","","","","",""],
   "players_complete":{true/false},
   "current_player":"{de quién es el turno x/o}",
   "game_over":{true/false},
   "tied_game":{true/false},
   "winner":"{ganador del juego}",
   ...
}
```

### Error Response

401 Unauthorized

```
HTTP/1.1 401 Unauthorized
```

500 Server Error

```
HTTP/1.1 500 Internal Server Error
{
   "error" : "Not Found"
}
```



## <a name='lista-de-juegos'></a> Lista de Juegos
[Back to top](#top)

<p>Me devuelve la lista de los juegos del usuario actual</p>

    GET /v1/games

### Examples

Header Autorización

```
Authorization=bearer {token}
```

### Success Response

Respuesta

```
HTTP/1.1 200 OK
[
    {
        "id":{game id},
        "game_over":{true/false},
        "tied_game":{true/false},
        "winner":"{ganador del juego}",
        "users":[
            {
                "user_id":{id del user},
                "login":"{login del user}",
                "player_symbol":"{simbolo del user x/o}"
            },
            {
                "user_id":{id del user},
                "login":"{login del user}",
                "player_symbol":"{simbolo del user x/o}"
            }
        ]
    },
    ...
]
```

### Error Response

401 Unauthorized

```
HTTP/1.1 401 Unauthorized
```

500 Server Error

```
HTTP/1.1 500 Internal Server Error
{
   "error" : "Not Found"
}
```
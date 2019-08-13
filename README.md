## Simple API for key-value storage based on Tarantool's memtx engine
With this API you can easily create, edit and remove any JSON-foramtted document.

You can try it [here](kv.rasseki.pro)

## Running on your machine 
The default port is 8080.

```bash
docker build -t kv-app https://github.com/eadium/tarantool-key-value.git
docker run -p 8080:8080 -t kv-app
```

# Create 
Used to create a new database entry.

**URL** : `/kv`

**Method** : `POST`

**Auth required** : NO

**Data constraints**

```json
{
    "key": "[some string]",
    "value": "[any JSON]"
}
```

**Data example**

```json
{
    "key": "42",
    "value": {
        "name": "John",
        "surname": "Fedor",
        "age": 23
    }
}
```

## Success Response

**Code** : `200 OK`

**Content example**

```json
{
    "key": "42",
    "value": {
        "name": "John",
        "surname": "Fedor",
        "age": 23
    }
}
```

## Error Response
### 400 BAD REQUEST

**Condition** : If requst body does not contain fields `key` and `value`.

**Code** : `400 BAD REQUEST`

**Content** :

```json
{
    "message": "Invalid body"
}
```
### 409 CONFLICT

**Condition** : Value with this key already exists.

**Code** : `409 CONFLICT`

**Content** :

```json
{
    "message": "Key already exists"
}
```

# Get

Used to get an existing database entry.

**URL** : `/kv/{id}`

**Method** : `GET`

**Auth required** : NO

## Success Response

**Code** : `200 OK`

**Content example**

```json
{
    "key": "42",
    "value": {
        "name": "John",
        "surname": "Fedor",
        "age": 23
    }
}
```

## Error Response
### 404 NOT FOUND

**Condition** : If the key does not exist.

**Code** : `404 NOT FOUND`

**Content** :

```json
{
    "message": "Not found"
}
```

# Update

Used to update an existing database entry.

**URL** : `/kv/{id}`

**Method** : `PUT`

**Auth required** : NO

**Data constraints**

```json
{
    "value": "[any JSON]"
}
```

**Data example**

```json
{
    "value": {
        "name": "John",
        "surname": "Fedor",
        "age": 23
    }
}
```

## Success Response

**Code** : `200 OK`

**Content example**

```json
{
    "value": {
        "name": "John",
        "surname": "Fedor",
        "age": 23
    }
}
```

## Error Response
### 400 BAD REQUEST

**Condition** : If requst body does not contain fields `key` and `value`.

**Code** : `400 BAD REQUEST`

**Content** :

```json
{
    "message": "Invalid body"
}
```
### 404 NOT FOUND

**Condition** : If the key does not exist.

**Code** : `404 NOT FOUND`

**Content** :

```json
{
    "message": "Not found"
}
```

# Delete
Used to delete value by a key.

**URL** : `/kv/{id}`

**Method** : `DELETE`

**Auth required** : NO

## Success Response

**Code** : `200 OK`

**Content example**

```json
{
    "message": "Successfully deleted"
}
```

## Error Response
### 404 NOT FOUND

**Condition** : If the key does not exist.

**Code** : `404 NOT FOUND`

**Content** :

```json
{
    "message": "Not found"
}
```

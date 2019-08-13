#!/usr/bin/env tarantool

local http  = require('http.server')
local json  = require('json')
local space_name = 'kv'

local function log(...)
    local log_string = ''
    for _, v in ipairs({...}) do
        log_string = log_string .. tostring(v) .. ' '
    end
    print(log_string)
end

local function http_error(code, message)
    log(code, message)
    return {
        status = code,
        headers = { ['content-type'] = 'application/json' },
        body = json.encode({message = message})
    }
end

local function http_json(data)
    log(200, 'OK')
    return {
        status = 200,
        headers = { ['content-type'] = 'application/json' },
        body = json.encode(data)
    }
end

local function create_object(req)
    local key = req:param('key')
    local value = req:param('value')

    if type(key) ~= 'string' or type(value) ~= 'table' then
        return http_error(400, 'Invalid body')
    end

    if box.space[space_name]:get{key} ~= nil then
        return http_error(409, 'Key already exists')
    end

    box.space[space_name]:insert{key, value}
    log('New value with key', key, 'created')

    return http_json({key = key, value = value})
end

local function get_object(req)
    local id = req:stash('id')

    obj = box.space[space_name]:get{id}
    if obj == nil then
        log('Key', id, 'wasn\'t found')
        return http_error(404, 'Not found')
    end
    
    log('Found value with key', id)
    return http_json({key = id, value = obj[2]})
end

local function update_object(req)
    local id = req:stash('id')
    local value = req:param('value')

    if type(value) ~= 'table' then
        return http_error(400, 'Invalid body')
    end

    obj = box.space[space_name]:get{id}
    if obj == nil then
        log('No tuple with key', id, 'was found')
        return http_error(404, 'Not found')
    end

    log('Updated tuple with id', id)
    new_obj = box.space[space_name]:update(id, {{'=', 2, value}})

    return http_json({value = new_obj[2]})
end

local function delete_object(req)
    local id = req:stash('id')

    obj = box.space[space_name]:get{id}
    if obj == nil then
        log('No tuple with key', id, 'was found')
        return http_error(404, 'Not found')
    end

    box.space[space_name]:delete(id)
    log('Deleted tuple with id ', id)
    return http_json({message = 'Successfully deleted'})
end

box.cfg{}
box.schema.space.create(space_name, {if_not_exists = true})
pk = box.space[space_name]:create_index('primary', {
    unique = true,
    if_not_exists = true,
    parts = {1,'string'}
})

local httpd = http.new('0.0.0.0', 8080, { log_requests = true })

-- create object
httpd:route({ path = '/kv', method = 'POST' },
    create_object)

-- update object
httpd:route({ path = '/kv/:id', method = 'PUT' },
    update_object)

-- remove object
httpd:route({ path = '/kv/:id', method = 'DELETE' },
    delete_object)

-- get object
httpd:route({ path = '/kv/:id', method = 'GET' },
    get_object)

httpd:start()
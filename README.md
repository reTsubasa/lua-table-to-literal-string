# lua table to literal string

This is a library for convert the lua table(array/hash) to literal string just like the lua code itself.



# Status

This library is for test use.

it support

- key type  :`string`/`number`

- value type:`string`/`number`/`boolean`/`table`

# Overview

The propose  usages for this library is you had a json format rule file ,and you may have to do the decode/encode every time, to convert the json to the table.

Use this library to convert the lua table to the code file.Then we can just require the output lua file,and it return the orig table,without further json decode/encode cost.

```lua
local t_to_l = require("t_to_l")

local tb = {1,2,3,"a","b",true,false,{1,2,3},b=2,d=true,c="123123",a=1,e={1,2,3}}

local str,err = t_to_l.convert(tb)
if not str then
    return nil,err
end
-- str:
--  {1,2,3,"a","b",true,false,{1,2,3},b=2,d=true,c="123123",a=1,e={1,2,3}}

local path = "/tmp/output.lua"
local ok,err = t_to_l.render(tb,path)
if not ok then
    return nil,err
end
--output.lua：
--  return {1,2,3,"a","b",true,false,{1,2,3},b=2,d=true,c="123123",a=1,e={1,2,3}}
```



# Methods

## str,err = convert(tb)

Convert the given table.

`tb` is the table we want to convert.

Return the strings,if succeed.

Return `nil` and `error message` if failed.

```lua
local str,err = convert(tb)
if not str then
	print(err)
end
```



## ok,err = render (tb,path)

Render the table to local file.If use **require** function to load the output lua file,it will be a table.

`tb` is the table we want to convert.

`path` is the absolute path where you want to output. You should give the correct file permit by yourself.

return `true`, if succeed.

Return `nil` and `error message` if failed.

```lua
local ok,err = render (tb,path)
if not ok then
	print(err)
end
```



# Install

luarocks:

`luarocks install lua-table-to-literal`
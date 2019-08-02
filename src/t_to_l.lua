--- lua table to literal string
-- This is a module for convert the lua table(array/hash) to literal string just like the lua code itself
-- It propose for the useage like convert a json format rule file to a lua file
-- Then we can just require the output lua file,and it return the orig table,without further json decode/encode cost
-- For now,it support
-- 	   key type  :string/number
-- 	   value type:string/number/boolean/table

-- Usage:

-- convert a table:
-- local str,err = convert(table)
-- if not str then
-- 	 print(err)
-- end

-- render a table to local file
-- local ok,err = render(table,path)
-- if not ok then
-- 	print(err)
-- end


-- reTsubasa@gmail.com
-- 20190802

local remove	= table.remove
local fmt		= string.format
local byte      = string.byte
local sub       = string.sub

local _M = {_VERSION = "0.1.0"}

-- convert input table to the string,if err,return nil,and error message
-- @table tb input table
local function convert(tb)
    if type(tb) ~= "table" then
       return tb 
    end
    
    local str = ""
	
	while next(tb) do
		local a,b = next(tb)
		if not a then
			return str
		end
		
		-- array table
		if type(a) == "number" then
			local tp = type(b)

            if tp == "string" then
                str = fmt('%s%q,',str,b)
                
            elseif tp == "number" then
                str = fmt('%s%g,',str,b)
                
            elseif tp == "boolean" then
                if b then
                    str = fmt('%s%s,',str,"true")
                else
                    str = fmt('%s%s,',str,"false")
                end
                
            elseif tp == "table" then
                str = fmt('%s%s,',str,conv(b))
                
            else
               -- not support func,upvalue...
               return nil,"table contain the unsupport type args"
            end
            
            remove(tb,a)


		-- hash table
		elseif type(a) == "string" then
            local tp = type(b)

            if tp == "string" then
                str = fmt('%s%s=%q,',str,a,b)

            elseif tp == "number" then
                str = fmt('%s%s=%g,',str,a,b)
                
            elseif tp == "boolean" then
                if b then
                    str = fmt('%s%s=%s,',str,a,"true")
                else
                    str = fmt('%s%s=%s,',str,a,"false")
                end
                
            elseif tp == "table" then
                str = fmt('%s%s=%s,',str,a,conv(b))
                
            else
               -- not support func,upvalue...
               return nil,"table contain the unsupport type args"
            end
            
            tb[a] = nil
        else
            -- not support the other type key
            return nil,"the key type only support number and string"
		end

		
	end
    
    -- remove the last byte ","
    if byte(str) == 49 then
       str = sub(str,1,-2)
    end
    
    return "{"..str.."}"
end

_M.convert = convert


local function render(tb,path)
    if not tb or not path then
       return nil,"input can not be nil" 
    end
    if type(tb) ~= "table" then
        return nil,"arg #1 type must be table"
    end
    
    local str,err,f
    
    str,err = conv(tb)
    if not str then
       return nil,err 
    end
    str = "return "..str
    
    f,err = io.open(path,"w+")
    if err then
       return nil,err 
    end
    f:write(str)
    f:close()
    return true
end

_M.render = render

return _M
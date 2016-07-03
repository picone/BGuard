ngx.header.content_type='text/plain';

local dict_keys=_Dict:get_keys()
local white_list={}
local block_list={}

for i,dict_key in ipairs(dict_keys)
do
  local identify=string.sub(dict_key,-6)
  if identify=="_white"
  then
    table.insert(white_list,string.sub(dict_key,0,-7))
  elseif identify=="_block"
  then
    table.insert(block_list,string.sub(dict_key,0,-7))
  end
end

ngx.say("block list:\r\n")
ngx.say(table.concat(block_list,"\r\n"))
ngx.say("\r\nwhite_list:\r\n")
ngx.say(table.concat(white_list,"\r\n"))

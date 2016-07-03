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

if _Dict:get("NO_ATTACK_TIMES")
then
  ngx.say("ATTACKING")
else
  ngx.say("NO_ATTACK")
end
ngx.say("block list:"..#block_list)
ngx.say(table.concat(block_list,"\r\n"))
ngx.say("\r\nwhite_list:"..#white_list)
ngx.say(table.concat(white_list,"\r\n"))

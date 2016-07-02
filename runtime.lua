--[[ 
键名             类型    作用
block:ip        String  已经禁封的黑名单
verified:ip     String  已经验证通过的白名单
cookie_key:ip   String  存放用于验证的Cookie key
verify_time:ip  String  存放验证次数
--]]
local remote_ip=ngx.var.remote_addr

local redis=_Redis.new()
--连接redis
redis:connect(_Config.redis.host,_Config.redis.port)
redis:set_timeout(_Config.redis.host)
redis:select(_Config.redis.db)

--判断是否在白名单内
local in_white_list=false;
for uri in ipairs(_Config.white_list)
do
  if ngx.re.match(ngx.var.uri,uri)
  then
    in_white_list=true;
    break
  end
end
if not in_white_list--判断是不是白名单
then
  if redis:exists("BGuard:block:"..remote_ip)==1--判断是否已经禁止
  then
    ngx.exit(ngx.HTTP_FORBIDDEN)
  else
    if redis:exists("BGuard:verified:"..remote_ip)==0--是否已通过过验证
    then
      local remote_cookie_key=ngx.var["cookie_bguard1"];
      if (not remote_cookie_key) or redis:sismember("BGuard:cookie_key:"..remote_ip,remote_cookie_key)==1
      then--通过Cookie key 验证
        redis:set("BGuard:verified:"..remote_ip,1)
        redis:expire("BGuard:verified:"..remote_ip,_Config.white_time)
        redis:del("BGuard:cookie_key:"..remote_ip)
        redis:del("BGuard:verify_time:"..remote_ip)
      else
        local verify_times=tonumber(redis:get("BGuard:verify_time:"..remote_ip))
        if verify_times==nil or verify_times<_Config.verify_times--判断验证次数
        then
          redis:incr("Buard:verify_time:"..remote_ip)
          redis:expire("BGuard:verify_time:"..remote_ip,_Config.block_time)
          local cookie_key=randomString(8)
          ngx.header['Set-Cookie']={"bguard="..cookie_key.."; path=/"}--客户端设置Cookie
          redis:sadd("BGuard:cookie_key:"..remote_ip,cookie_key)
          redis:expire("BGuard:cookie_key:"..remote_ip,_Config.expires)
        else--添加到黑名单
          redis:set("BGuard:block:"..remote_ip,1)
          redis:expire("BGuard:block:"..remote_ip,_Config.block_time)
        end        
      end
    end
  end
end

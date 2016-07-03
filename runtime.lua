--[[ 
https://github.com/openresty/lua-nginx-module#ngxshareddict
键名        作用
ip_block   已经禁封的黑名单
ip_white   已经验证通过的白名单,在激活情况下用于计数
ip_key     存放用于验证的Cookie key
ip_verify  存放验证次数
--]]
local remote_ip=ngx.var.remote_addr

local block_key=remote_ip.."_block"
if _Dict:get(block_key)
then--存在于黑名单中
  ngx.exit(ngx.HTTP_FORBIDDEN)
else--还不存在黑名单中
  local white_key=remote_ip.."_white";
  if not _Dict:get(white_key) then--若不在IP白名单内
    --判断是否在白名单URI内
    local in_white_list=false;
    if ngx.var.white_list and _Config.white_list[ngx.var.white_list]
    then--若存在白名单
      for index,uri in ipairs(_Config.white_list[ngx.var.white_list])
      do
        if ngx.re.match(ngx.var.uri,uri)
        then
          in_white_list=true;
          break
        end
      end
    end
    if not in_white_list then--判断是不是白名单
      --ngx.log(ngx.INFO,remote_ip..":判断key")
      local remote_key=ngx.var["cookie_bguard"]
      local key_key=remote_ip.."_key"
      local local_key=_Dict:get(key_key)
      if remote_key and local_key==remote_key
      then--验证通过
        --ngx.log(ngx.INFO,remote_ip..":验证成功")
        _Dict:set(white_key,1,_Config.white_time)
        _Dict:delete(block_key)
        _Dict:delete(key_key)
      else--验证不通过
        local verify_key=remote_ip.."_verify"
        local verify_times=tonumber(_Dict:get(verify_key))
        --if verify_times then ngx.log(ngx.INFO,remote_ip..":验证失败,次数"..verify_times) else ngx.log(ngx.INFO,remote_ip..":验证失败,次数0") end
        if verify_times and verify_times>_Config.verify_times
        then--超过次数没验证成功
          --ngx.log(ngx.INFO,remote_ip..":已被禁止")
          _Dict:add(block_key,true,_Config.block_time)
          _Dict:delete(white_key)
          _Dict:delete(key_key)
        else--发送验证的Cookie
          if not local_key then--若key还没有被生成过
            local_key=randomString(8)
          end
          --ngx.log(ngx.INFO,remote_ip..":发送key"..local_key)
          _Dict:add(key_key,local_key,_Config.expires)--保存验证key
          ngx.header['Set-Cookie']={"bguard="..local_key.."; path=/"}--客户端设置Cookie
          if verify_times then
            _Dict:incr(verify_key,1)--验证次数+1
          else
            _Dict:set(verify_key,1,_Config.expires)
          end
        end
      end
    --[[else
      ngx.log(ngx.INFO,remote_ip..":通过白名单")--]]
    end
  end
end

local remote_ip=ngx.var.remote_addr

local function print_page()
    ngx.header.content_type="text/html";
    ngx.header['Set-Cookie']={"bguard="..randomString(8).."; path=/"}
    ngx.say('<html><head><meta http-equiv="Content-Type" content="text/html;charset=UTF-8"><title>验证码</title></head><body style="background-color:#3C3;"><img src="'.._Config.redirect_url..'?img"><form method="POST"><input type="text" name="vcode" required><input type="submit"></form></body></html>')
end

if ngx.req.get_method()=="POST"
then--提交验证码
  ngx.header.content_type="text/html";
  local key=ngx.var["cookie_bguard"]
  if key then
    key=_Dict:get("captcha:"..key)
    local answer=ngx.req.get_post_args()["vcode"]
    if key and answer and key==answer then
      _Dict:delete("captcha:"..key)
      _Dict:delete(remote_ip.."_block")
      _Dict:set(remote_ip.."_white",1,_Config.white_time)
      ngx.redirect("/",ngx.HTTP_MOVED_TEMPORARILY)
    else
      print_page()
    end
  else
    print_page()
  end
elseif ngx.var.query_string and ngx.var.query_string~=""
then--输出验证码
  local key=ngx.var["cookie_bguard"]
  if key then
    local vcode="";
    ngx.header.content_type="image/png";
    math.randomseed(os.time())
    for i=0,3
    do
      vcode=vcode..math.random(0,9)
    end
    local file=io.open(_Config.base_dir.."captcha/"..vcode..".png","r")
    if file then
      ngx.print(file:read("*all"))
      file:close()
      _Dict:set("captcha:"..key,vcode,_Config.expires)
    end
  end
else--显示验证码页面
  print_page()
end

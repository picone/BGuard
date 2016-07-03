_Config=require("config")
_Dict=ngx.shared.guard;

--生成随机字符串
function randomString(length)
  local result="";
  math.randomseed(os.time())
  for i=0,length,1
  do
    result=result..string.char(math.random(33,126))
  end
  return result
end

--初始化白名单
for i,ip in ipairs(_Config.white_ip)
do
  _Dict:set(ip.."_white",1,1)--设置flag为1标记为白名单IP
end

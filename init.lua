_Redis=require "resty.redis"
_Config=require("config")

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

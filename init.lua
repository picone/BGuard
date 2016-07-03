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

--ss -tn state established '( sport = :80 )'|wc -l

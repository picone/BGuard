local function detect_conn()
  local num=tonumber(io.popen("ss -tn state established '( sport = :80 )'|wc -l"):read("*all"))
  --ngx.log(ngx.INFO,"当前连接数"..num)
  if num and num>_Config.auto_limit.limit_connect
  then
    _Dict:set("NO_ATTACK_TIMES",1)
  else
    num=_Dict:incr("NO_ATTACK_TIMES",1)
    if num and num>=_Config.auto_limit.no_attack_times then
      _Dict:delete("NO_ATTACK_TIMES")
    end  
  end
  ngx.timer.at(_Config.auto_limit.detect_time,detect_conn)
end

if ngx.worker.id()==0
then--仅在worker0上开启任务
  ngx.timer.at(_Config.auto_limit.detect_time,detect_conn)
end

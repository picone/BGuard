#功能
1.为请求注入cookie并以此判断是否机器访问

2.当连接数达到限制时使用访问速度判断并ban流量

#环境
1.openresty

2.redis 

#使用
1.设置目录路径

在http下加入`lua_package_path "/your_project_path/?.lua;;";`

2.设置启动时处理的lua脚本

在http下加入`init_by_lua_file "/your_project_path/init.lua";`

3.设置接受请求时处理的lua脚本

在需要的http/server/location/if下加入

`set $white_list "your white list name";`

`access_by_lua_file "/your_project_path/runtime.lua";`

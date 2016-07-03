#功能
1.为请求注入cookie并以此判断是否机器访问

2.当连接数达到限制时使用访问速度判断并ban流量

#环境
openresty

#使用
1.设置目录路径

在http下加入`lua_package_path "/your_project_path/?.lua;;";`

2.开辟DICT空间

`lua_shared_dict guard 100m;`

3.设置启动时处理的lua脚本

在http下加入`init_by_lua_file "/your_project_path/init.lua";`

4.设置定时器启动的lua脚本

如果不需要超过当前连接数启动限制模块,可以不添加此模块

添加到http下面`init_worker_by_lua_file "/your_project_path/worker.lua";`

5.设置接受请求时处理的lua脚本

在需要的http/server/location/if下加入

`set $white_list "your white list name";`

`access_by_lua_file "/your_project_path/runtime.lua";`

6.设置查看状态的url

在您需要的location里面加入`content_by_lua_file "/your_project_path/status.lua";`

# spbtool
用来生成sproto的spb文件,类似于google protobuf生成出来的pb文件. 生成的spb文件可以直接被客户端和服务器加载, 而不需要lpeg等语法树的支持  
> cocos creator可以通过http的方式加载取得spb文件内容, 还可以使用生成出来的base64版本的spb文件直接使用creator api loadRes加载  

> cocos2dx lua 可以通过集成云风的sproto库直接使用

> skynet 直接载入文件就可以使用 

## 如何使用spbtool生成spb文件

### 1. windows系统里面必须有以动态库生成的lua53或者直接下载zerobrane studio安装后使用zerobrane里的bin目录的lua53

### 2. 在sublime里面新一个lua53的编译系统
```json
{
	"cmd": ["D:/softinstall/ZeroBraneStudio/bin/lua53.exe", "$file"], 
	"file_regex": "^(?:lua:)?[\t ](...*?):([0-9]*):?([0-9]*)",
	"selector": "source.lua"
}
```

### 3. 用sublime打开GenerateSpb.lua 并编缉原始sproto文件路径和生成的spb文件路径, Ctrl+B执行脚本
```lua
local sprotodump = require "sprotodump"

local dump = sprotodump()
dump:set_dump_path(root.."/protocol/")
dump:load(root.."/sproto/", true)
dump:dump("protocol.spb")

--生成base64的protocol文件
dump:base64_dump("protocol.txt")
```

* 本库所使用的sproto与云风原版的sproto在解析的时候增加了模块的定义, 并不影响原版sproto的读取
* 本库所使用的sproto与云风原版的rpc部分有所不同, 强调区分了c2s和s2c, 修改了源代码, 如果不使用rpc则与原版没有影响


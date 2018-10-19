local root = ".."

package.path = "./lualib/?.lua;"
package.cpath = "./luaclib/?.dll;"

local sprotodump = require "sprotodump"

local dump = sprotodump()
dump:set_dump_path(root.."/protocol/")
dump:load(root.."/sproto/", true)
dump:dump("protocol.spb")

--生成base64的protocol文件
dump:base64_dump("protocol.txt")
package.path = "./lualib/?.lua;"
package.cpath = "./luaclib/?.dll;"

local sproto = require "sproto"
local core = require "sproto.core"
local print_r = require "print_r"

local server_sproto = sproto.parse [[

.UserData {
	errorcode 0 : integer
	token     1 : string
	unionid   2 : string
}

.Package {
	type    0 : integer
	session 1 : integer
	ud      2 : UserData 
}

login {
	.Player {
		playerid 0 : integer   #玩家id
		nickname 1 : string    #昵称
		headid   2 : integer   #默认头像id
		headurl  3 : string    #头像地址
		sex      4 : integer   #0-未知 1-男 2-女
		gold     5 : integer   #金币
	}

	#C2S
	account_login 100 {
		request {
			account   0 : string  #帐号
			password  1 : string  #密码
			channelid 2 : string  #渠道id
		}
		response {
			player 0 : Player
		}
	}

	#S2C
	login_event 150 {
		request {
			tips     0 : string
		}
	}
}

]]

local client_sproto = sproto.parse [[

.UserData {
	errorcode 0 : integer
	token 1 : string
	unionid 2 : string
}

.Package {
	type 0 : integer
	session 1 : integer
	ud 2 : UserData
}

]]

function print_binary(name, binary)
	local str = ""
	for i=1, #binary do
		str = str .. string.byte(string.sub(binary, i, i)) .. ", "
	end
	print("buffer=", str);
	-- print(str)
end

local server = server_sproto:host "Package"
local client = client_sproto:host "Package"

--客户端请求
local client_request = client:attach(server_sproto)
local server_request = server:attach(server_sproto)

local player = {
	playerid = 22,
	--nickname = "陌陌欧383",
	--headid = 100033,
	--headurl = "http://www.wechat.com/images/0001",
	--sex = 1,
	--gold = 188888888,
}

--encode && decode
local encodedString = server_sproto:encode("login.Player", player)

print_binary("encode=", encodedString)

local decodedInfo = server_sproto:decode("login.Player", encodedString)
print_r(decodedInfo)


--rpc request
print("1.==============C2S request==================")
local req = {account="account01", password="18c08cc0af530ff3c1fd82156db181ac", channelid="huawei"}
local reqStream = server_request("login.account_login", req, 1, {token="e10adc3949ba59abbe56e057f20f883e"})
local type, name, reqInfo, response, ud = server:dispatch(reqStream)
print("type=", type)
print("name=", name)
print("reqInfo=", table.tostring(reqInfo))
print("ud=", table.tostring(ud))



print("2.==============C2S response==================")
local respStream = response { player = player }
local type, session, respInfo, ud = server:dispatch(respStream)
print("type=", type)
print("session=", session)
print("respInfo=", table.tostring(reqInfo))
print("ud=", table.tostring(ud))



print("3.================S2C response================")
local s2cStream = server:response("login.account_login", { player = player })
local type, name, respInfo, session, ud = server:dispatch(s2cStream)
print("type=", type)
print("name=", name)
print("reqInfo=", table.tostring(reqInfo))
print("session=", session)
print("ud=", table.tostring(ud))
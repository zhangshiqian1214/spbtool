local root = ".."

package.path = "./lualib/?.lua;"
package.cpath = "./luaclib/?.dll;"

local sproto = require "sproto"
local print_r = require "print_r"

local sp = sproto.parse [[

.package {
	type 0 : integer
	session 1 : integer
}

.ExtraPackage {
	uuid 0 : string

}

auth {

	.Person {
		name 0 : string
		id 1 : integer
		email 2 : string
		.PhoneNumber {
			number 0 : string
			type 1 : integer
		}
		phone 3 : *PhoneNumber
	}
	.AddressBook {
		person 0 : *Person(id)
		others 1 : *Person
	}

	foobar 1 {
		request {
			what 0 : string
		}
		response {
			ok 0 : boolean
		}
	}
}


]]

--[[

auth {
	foobar 1 {
		request {
			what 0 : string
		}
		response {
			ok 0 : boolean
		}
	}
	foo 2 {
		response {
			ok 0 : boolean
		}
	}
	bar 3 {
		response nil
	}
	blackhole 4 {

	}
}

]]


local client_proto = sproto.parse [[

.package {
	type 0 : integer
	session 1 : integer
}

]]



local ab = {
	person = {
		[10000] = {
			name = "Alice",
			id = 10000,
			phone = {
				{ number = "123456789" , type = 1 },
				{ number = "87654321" , type = 2 },
			}
		},
		[20000] = {
			name = "Bob",
			id = 20000,
			phone = {
				{ number = "01234567890" , type = 3 },
			}
		}
	},
	others = {
		{
			name = "Carol",
			id = 30000,
			phone = {
				{ number = "9876543210" },
			}
		},
	}
}

local code = sp:encode("auth.AddressBook", ab)
local addr = sp:decode("auth.AddressBook", code)
print_r(addr)

print(sp.pack)


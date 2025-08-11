--!native

local exports = require("@self/runtime")
local CSPRNG = require("@self/CSPRNG").New()

if game then --[[ if on roblox, add extra entropy ]]
	local HttpService = game:GetService("HttpService")
	local s = ""
	for i = 0, 64 do
		s ..= HttpService:GenerateGUID(false)
	end

	CSPRNG:GatherEntropy(buffer.fromstring(s))
end

local Module = {}

-- This returns a *mut State. On the WASM side, this contains your verification (public) key and signing (private) key.
function Module.generate(): number
	return exports.generate(CSPRNG:GetBytes(32))
end

-- This returns the *mut State's public key.
function Module.getPublicKey(state: number): buffer
	return exports.get_public_key(state)
end

-- This returns a *mut State. On the WASM side, this contains your verification (public) key and signing (private) key.
function Module.fromKeys(public: buffer, private: buffer)
	return exports.from_keys(public, private)
end

-- This returns a signature on success and nothing on fail.
function Module.sign(state: number, message: buffer, context: string)
	return exports.sign(state, message, context, CSPRNG:GetBytes(32))
end

-- This returns a boolean indicating if the signature is valid.
function Module.verify(state: number, message: buffer, context: string, signature: buffer): boolean
	return exports.verify(state, message, context, signature) == 1
end

-- Call this on a *mut State to free it once you are done using it.
function Module.free(state: number)
	exports.free_state(state)
end

return table.freeze(Module)

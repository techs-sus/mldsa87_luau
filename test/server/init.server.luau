--!native

local Module: typeof(require("../library")) = require(script.Parent.Library)

local start = os.clock()

local state = Module.generate()
local publicKey = Module.getPublicKey(state)

assert(buffer.len(publicKey) == 2592, "public key must be 2592 bytes")

local signature = assert(Module.sign(state, buffer.fromstring("I am bob"), "bob->alice"), "failed signing message")

assert(Module.verify(state, buffer.fromstring("I am bob"), "bob->alice", signature), "failed verifying message")

Module.free(state)

print("took", os.clock() - start, "seconds to test implementation")

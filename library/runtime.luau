--!native
--!optimize 2
local WASM_CTOR = require(script.Parent.wasm)
local WASM_FUNCS = {}
local WASM_EXPORTS = {}
local HEAP, HEAP_ID = {}, 0
local WASM, MEMORY, WASM_STACK
WASM_EXPORTS["generate"] = function(param_0)
	local vec_0 = WASM.func_list.alloc_98dc10e9d72dd56a(32, 1)
	buffer.copy(MEMORY.data, vec_0, param_0)
	local output_0 = WASM.func_list.generate_ff6f4e8e056a6a91(vec_0, 32)
	return output_0
end
WASM_EXPORTS["from_keys"] = function(param_0, param_1)
	local vec_0 = WASM.func_list.alloc_98dc10e9d72dd56a(2592, 1)
	buffer.copy(MEMORY.data, vec_0, param_0)
	local vec_1 = WASM.func_list.alloc_98dc10e9d72dd56a(4896, 1)
	buffer.copy(MEMORY.data, vec_1, param_1)
	local output_0 = WASM.func_list.from_keys_3c5999475e503b(vec_0, 2592, vec_1, 4896)
	return output_0
end
WASM_EXPORTS["sign"] = function(param_0, param_1, param_2, param_3)
	local vec_0 = WASM.func_list.alloc_98dc10e9d72dd56a(buffer.len(param_1), 1)
	buffer.copy(MEMORY.data, vec_0, param_1)
	local string_0 = WASM.func_list.alloc_98dc10e9d72dd56a(#param_2, 1)
	buffer.writestring(MEMORY.data, string_0, param_2)
	local vec_1 = WASM.func_list.alloc_98dc10e9d72dd56a(32, 1)
	buffer.copy(MEMORY.data, vec_1, param_3)
	local spill_0 = WASM_STACK.value - 12
	WASM_STACK.value = spill_0
	WASM.func_list.sign_1a0c7475bef4fa4f(spill_0, param_0, vec_0, buffer.len(param_1), string_0, #param_2, vec_1, 32)
	local output_0 = buffer.readu8(MEMORY.data, spill_0 + 0)
	local output_1 = buffer.readu32(MEMORY.data, spill_0 + 4)
	local output_2 = buffer.readu32(MEMORY.data, spill_0 + 8)
	WASM_STACK.value = spill_0 + 12
	local optional_0
	if output_0 == 1 then
		local vector_0 = buffer.create(output_2)
		buffer.copy(vector_0, 0, MEMORY.data, output_1, output_2)
		WASM.func_list.free_9f0c05e41871769c(output_1, output_2, 1)
		optional_0 = vector_0
	end
	return optional_0
end
WASM_EXPORTS["verify"] = function(param_0, param_1, param_2, param_3)
	local vec_0 = WASM.func_list.alloc_98dc10e9d72dd56a(buffer.len(param_1), 1)
	buffer.copy(MEMORY.data, vec_0, param_1)
	local string_0 = WASM.func_list.alloc_98dc10e9d72dd56a(#param_2, 1)
	buffer.writestring(MEMORY.data, string_0, param_2)
	local vec_1 = WASM.func_list.alloc_98dc10e9d72dd56a(buffer.len(param_3), 1)
	buffer.copy(MEMORY.data, vec_1, param_3)
	local output_0 = WASM.func_list.verify_d5014ed1f5bb242b(
		param_0,
		vec_0,
		buffer.len(param_1),
		string_0,
		#param_2,
		vec_1,
		buffer.len(param_3)
	)
	return output_0
end
WASM_EXPORTS["get_public_key"] = function(param_0)
	local spill_0 = WASM_STACK.value - 8
	WASM_STACK.value = spill_0
	WASM.func_list.get_public_key_9429be60f531f740(spill_0, param_0)
	local output_0 = buffer.readu32(MEMORY.data, spill_0 + 0)
	local output_1 = buffer.readu32(MEMORY.data, spill_0 + 4)
	WASM_STACK.value = spill_0 + 8
	local vector_0 = buffer.create(output_1)
	buffer.copy(vector_0, 0, MEMORY.data, output_0, output_1)
	WASM.func_list.free_9f0c05e41871769c(output_0, output_1, 1)
	return vector_0
end
WASM_EXPORTS["free_state"] = function(param_0)
	local output_0 = WASM.func_list.free_state_78cdd3c508f73eaf(param_0)
	return output_0
end
WASM = WASM_CTOR({ luau = { func_list = WASM_FUNCS } })
MEMORY = WASM.memory_list.memory
WASM_STACK = WASM.global_list.__stack_pointer
return WASM_EXPORTS

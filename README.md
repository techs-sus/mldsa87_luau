# mldsa87_luau

You can download the library by downloading the repository as a zip and taking the "library" folder.

If ran on Roblox, CSPRNG is seeded with 64 `HttpService:GenerateGuid()` calls on Roblox.

An example is provided in `test/server/init.server.luau`.

## Build steps

```bash
rustup target add wasm32-unknown-unknown
roblox-rs build -o out ./target/wasm32-unknown-unknown/release/mldsa87_wasm.wasm
```

You need to modify the output of runtime.luau to turn all `Vec<u8>`'s into buffers.

## Credits

Uses [roblox-rs](https://github.com/roblox-rs/bindings).
Uses CSPRNG via [rbx-cryptography](https://github.com/daily3014/rbx-cryptography).
Uses a verified ML-DSA implementation via [libcrux](https://github.com/cryspen/libcrux).

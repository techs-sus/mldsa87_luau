use libcrux_ml_dsa::{
	KEY_GENERATION_RANDOMNESS_SIZE, MLDSASignature,
	ml_dsa_87::{self, MLDSA87KeyPair},
};
use roblox_rs::prelude::*;

/// The #[luau] macro is responsible for generating bindings between Rust and Luau.
/// You can import Luau/Roblox globals using `extern` and simply defining the function signature.
#[luau]
extern "C" {
	fn error(value: &str);
}

struct State {
	pair: MLDSA87KeyPair,
}

#[luau]
pub fn generate(randomness: Vec<u8>) -> u32 {
	assert!(
		randomness.len() == KEY_GENERATION_RANDOMNESS_SIZE,
		"must give exactly {KEY_GENERATION_RANDOMNESS_SIZE} random bytes"
	);

	let randomness_array: [u8; KEY_GENERATION_RANDOMNESS_SIZE] = randomness.try_into().unwrap();
	let pair = ml_dsa_87::generate_key_pair(randomness_array);

	Box::into_raw(Box::new(State { pair })) as u32
}

#[luau]
pub fn get_public_key(state: u32) -> Vec<u8> {
	unsafe {
		(*(state as *mut State))
			.pair
			.verification_key
			.as_ref()
			.to_vec()
	}
}

#[luau]
pub fn from_keys(public: Vec<u8>, private: Vec<u8>) -> u32 {
	assert!(
		public.len() == 2592,
		"must give exactly 2592 public key bytes"
	);
	assert!(
		private.len() == 4896,
		"must give exactly 4896 private key bytes"
	);

	let public: [u8; 2592] = public.try_into().unwrap();
	let private: [u8; 4896] = private.try_into().unwrap();

	let verification_key = ml_dsa_87::MLDSA87VerificationKey::new(public);
	let signing_key = ml_dsa_87::MLDSA87SigningKey::new(private);

	Box::into_raw(Box::new(State {
		pair: MLDSA87KeyPair {
			verification_key,
			signing_key,
		},
	})) as u32
}

#[luau]
pub fn sign(state: u32, message: Vec<u8>, context: String, randomness: Vec<u8>) -> Option<Vec<u8>> {
	let state = unsafe { &*(state as *const State) };

	assert!(randomness.len() == 32, "must give exactly 32 random bytes");
	assert!(
		context.len() < 255,
		"context length must be below or equal to 255"
	);

	let randomness_array: [u8; 32] = randomness.try_into().unwrap();

	ml_dsa_87::sign(
		&state.pair.signing_key,
		&message,
		context.as_bytes(),
		randomness_array,
	)
	.map(|signature| signature.as_slice().to_vec())
	.ok()
}

#[luau]
pub fn verify(state: u32, message: Vec<u8>, context: String, signature: Vec<u8>) -> u8 {
	let state = unsafe { &*(state as *const State) };

	if signature.len() != 4627 {
		return 0;
	}

	let signature: [u8; 4627] = signature.try_into().unwrap();

	if ml_dsa_87::verify(
		&state.pair.verification_key,
		&message,
		context.as_bytes(),
		&MLDSASignature::new(signature),
	)
	.is_ok()
	{
		1
	} else {
		0
	}
}

#[luau]
pub fn free_state(ptr: u32) -> u8 {
	unsafe {
		drop(Box::from_raw(ptr as *mut State));
	};

	0 // prevent build panic
}

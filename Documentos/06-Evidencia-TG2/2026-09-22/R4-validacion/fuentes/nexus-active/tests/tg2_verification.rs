//! Caracterización del comportamiento heredado y evaluación de la variante TG2.
#[path = "../experiments/tg2_canonical_verifier.rs"]
mod canonical;

use canonical::{ExpectedTransition, public_inputs, verify_canonical_transition};
use nexus_active::{pq_verifier::{PqValidityProof, encode_root, root_from_felt},
    verifier::{NitroVerifier, ProofType, StateProof, VerificationMode}};
use nexus_core::{BlockHeight, Hash256, StateRoot};
use nexus_zk::stark::field::{Felt, P};
use std::sync::OnceLock;

fn fixture() -> (StateProof, ExpectedTransition) {
    static FIXTURE: OnceLock<(StateProof, ExpectedTransition)> = OnceLock::new();
    FIXTURE.get_or_init(|| {
        let pre = root_from_felt(Felt::new(3));
        let pq = PqValidityProof::prove(&pre, 5, 16);
        let expected = ExpectedTransition { pre, post: pq.post_root(), height: BlockHeight(1), steps: 16 };
        let proof = StateProof { proof_type: ProofType::ZKValidity, pre_state_root: pre,
            post_state_root: expected.post, height: expected.height,
            proof_data: pq.to_bytes(), public_inputs: public_inputs(&expected) };
        (proof, expected)
    }).clone()
}

#[test]
fn legacy_accepts_garbage_and_marks_root_verified() {
    let (mut proof, expected) = fixture();
    proof.proof_data = vec![1, 2, 3, 4];
    let mut legacy = NitroVerifier::new(VerificationMode::ZKValidity);
    assert!(legacy.verify(&proof).unwrap().valid);
    assert!(legacy.is_verified(expected.height, expected.post));
    assert!(verify_canonical_transition(&proof, &expected).is_err());
}

#[test]
fn legacy_ignores_each_of_the_last_24_bytes_of_both_roots() {
    let (proof, expected) = fixture();
    let pq = PqValidityProof::from_bytes(&proof.proof_data).unwrap();
    for byte in 8..32 {
        let mut pre = expected.pre;
        pre.0.0[byte] ^= 1;
        assert!(pq.verify_bound(&pre, &expected.post));
        let mut post = expected.post;
        post.0.0[byte] ^= 1;
        assert!(pq.verify_bound(&expected.pre, &post));
    }
}

#[test]
fn legacy_field_reduction_also_collides_within_first_eight_bytes() {
    let (proof, expected) = fixture();
    let mut alias = expected.pre;
    alias.0.0[..8].copy_from_slice(&(P + 3).to_le_bytes());
    assert_ne!(alias, expected.pre);
    assert_eq!(encode_root(&alias), encode_root(&expected.pre));
    let pq = PqValidityProof::from_bytes(&proof.proof_data).unwrap();
    assert!(pq.verify_bound(&alias, &expected.post));
    assert!(canonical::canonical_scalar(&alias).is_err());
}

#[test]
fn legacy_does_not_bind_height_type_or_outer_inputs_for_stark() {
    let (mut proof, _) = fixture();
    proof.height = BlockHeight(99);
    proof.proof_type = ProofType::FraudProof;
    proof.public_inputs = vec![255];
    let mut legacy = NitroVerifier::new(VerificationMode::ZKValidity);
    assert!(legacy.verify(&proof).unwrap().valid);
    assert!(legacy.is_verified(BlockHeight(99), proof.post_state_root));
}

#[test]
fn canonical_valid_proof_accepts() {
    let (proof, expected) = fixture();
    verify_canonical_transition(&proof, &expected).unwrap();
}

#[test]
fn canonical_rejects_mutations_in_every_byte_of_pre_and_post() {
    let (proof, expected) = fixture();
    for byte in 0..32 {
        for pre in [true, false] {
            let mut changed = proof.clone();
            let mut context = expected.clone();
            if pre {
                changed.pre_state_root.0.0[byte] ^= 1;
                context.pre = changed.pre_state_root;
            } else {
                changed.post_state_root.0.0[byte] ^= 1;
                context.post = changed.post_state_root;
            }
            changed.public_inputs = public_inputs(&context);
            assert!(verify_canonical_transition(&changed, &context).is_err(), "byte={byte}, pre={pre}");
        }
    }
}

#[test]
fn canonical_refuses_arbitrary_hash_roots() {
    let (mut proof, mut expected) = fixture();
    expected.pre = StateRoot::new(Hash256::hash(b"raiz completa"));
    proof.pre_state_root = expected.pre;
    proof.public_inputs = public_inputs(&expected);
    assert!(verify_canonical_transition(&proof, &expected).is_err());
}

#[test]
fn canonical_rejects_wrong_type_height_and_outer_inputs() {
    let (proof, expected) = fixture();
    for mode in [ProofType::Optimistic, ProofType::FraudProof] {
        let mut changed = proof.clone();
        changed.proof_type = mode;
        assert!(verify_canonical_transition(&changed, &expected).is_err());
    }
    let mut changed = proof.clone();
    changed.height = BlockHeight(2);
    assert!(verify_canonical_transition(&changed, &expected).is_err());
    changed = proof;
    changed.public_inputs[71] ^= 1;
    assert!(verify_canonical_transition(&changed, &expected).is_err());
}

#[test]
fn canonical_rejects_empty_truncated_trailing_and_oversized_payloads() {
    let (proof, expected) = fixture();
    for size in [0, 1, 4, proof.proof_data.len() / 2, proof.proof_data.len() - 1] {
        let mut changed = proof.clone();
        changed.proof_data.truncate(size);
        assert!(verify_canonical_transition(&changed, &expected).is_err());
    }
    let mut changed = proof.clone();
    changed.proof_data.push(0);
    assert!(verify_canonical_transition(&changed, &expected).is_err());
    changed.proof_data = vec![0; canonical::MAX_PROOF_BYTES + 1];
    assert!(verify_canonical_transition(&changed, &expected).is_err());
}

#[test]
fn canonical_bounds_trace_size_before_arithmetic() {
    let (proof, expected) = fixture();
    for steps in [0, 1, 4, 8, 15, 17, canonical::MAX_STEPS + 1, 1usize << (usize::BITS - 1)] {
        let mut context = expected.clone();
        context.steps = steps;
        assert!(verify_canonical_transition(&proof, &context).is_err());
    }
    let mut context = expected;
    context.steps = 32;
    assert!(verify_canonical_transition(&proof, &context).is_err());
}

#[test]
fn canonical_rejects_noncanonical_deserialized_field_elements() {
    let (proof, expected) = fixture();
    let noncanonical: Felt = bincode::deserialize(&P.to_le_bytes()).unwrap();
    assert_eq!(noncanonical.value(), P);
    for case in 0..4 {
        let mut pq = PqValidityProof::from_bytes(&proof.proof_data).unwrap();
        match case {
            0 => pq.statement.start = noncanonical,
            1 => pq.proof.fri_final.c0 = noncanonical,
            2 => pq.proof.queries[0].trace[0].value = noncanonical,
            _ => pq.proof.queries[0].fri.layers[0].left.c1 = noncanonical,
        }
        let mut changed = proof.clone();
        changed.proof_data = pq.to_bytes();
        assert!(verify_canonical_transition(&changed, &expected).is_err());
    }
}

#[test]
fn canonical_rejects_missing_queries_layers_and_paths() {
    let (proof, expected) = fixture();
    for case in 0..5 {
        let mut pq = PqValidityProof::from_bytes(&proof.proof_data).unwrap();
        match case {
            0 => { pq.proof.queries.pop(); }
            1 => { pq.proof.fri_roots.pop(); }
            2 => { pq.proof.queries[0].trace.pop(); }
            3 => { pq.proof.queries[0].fri.layers.clear(); }
            _ => { pq.proof.queries[0].fri.layers[0].left_proof.siblings.pop(); }
        }
        let mut changed = proof.clone();
        changed.proof_data = pq.to_bytes();
        assert!(verify_canonical_transition(&changed, &expected).is_err());
    }
}

#[test]
fn canonical_executes_stark_checks_after_structural_validation() {
    let (proof, expected) = fixture();
    for case in 0..3 {
        let mut pq = PqValidityProof::from_bytes(&proof.proof_data).unwrap();
        match case {
            0 => pq.proof.queries[0].trace[0].value = pq.proof.queries[0].trace[0].value.add(Felt::ONE),
            1 => pq.proof.queries[0].trace[0].proof.siblings[0].0[31] ^= 1,
            _ => pq.proof.fri_final.c1 = pq.proof.fri_final.c1.add(Felt::ONE),
        }
        let mut changed = proof.clone();
        changed.proof_data = pq.to_bytes();
        assert!(verify_canonical_transition(&changed, &expected).is_err());
    }
}

#[test]
fn canonical_does_not_claim_height_is_in_the_air_statement() {
    let (mut proof, mut expected) = fixture();
    expected.height = BlockHeight(2);
    proof.height = expected.height;
    proof.public_inputs = public_inputs(&expected);
    // El mismo enunciado matemático es válido en otro contexto autorizado.
    // La prevención de repetición requiere el estado y las reglas de la aplicación.
    verify_canonical_transition(&proof, &expected).unwrap();
}

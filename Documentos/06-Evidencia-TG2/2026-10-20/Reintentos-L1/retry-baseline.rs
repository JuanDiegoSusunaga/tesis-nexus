//! Retry bookkeeping remains local and does not certify L2 validity or BFT finality.
use nexus_active::{ActiveChain, ActiveChainConfig, L2Batch};
use nexus_anchor::{AnchorChain, AnchorChainConfig};
use nexus_core::{Address, Amount, ChainId, Hash256, Nonce, SignatureScheme, Transaction};
use nexus_crypto::{DilithiumKeypair, Signer};

fn key() -> DilithiumKeypair { DilithiumKeypair::generate(SignatureScheme::Dilithium3).unwrap() }
fn pair() -> (ActiveChain, DilithiumKeypair) {
    let publisher = key();
    let chain = ActiveChain::new(ActiveChainConfig { batch_interval_blocks: 1, ..Default::default() }, publisher.clone());
    (chain, publisher)
}
fn batch(chain: &ActiveChain) -> L2Batch {
    let sender = key();
    let tx = Transaction::transfer(ChainId::LOCAL, Nonce(0), Address::ZERO, Amount(1), 21000, Amount(1_000_000_000));
    chain.submit_transaction(sender.sign_transaction(tx).unwrap()).unwrap();
    chain.produce_block().unwrap();
    chain.get_next_batch().unwrap()
}
fn anchor() -> AnchorChain { AnchorChain::new(AnchorChainConfig::default(), key()) }

#[test]
fn baseline_incorrect_hash_leaves_no_recovery_through_the_existing_api() {
    let (chain, _) = pair();
    let local = batch(&chain);
    let first = Hash256::hash(b"incorrect intent");
    chain.mark_batch_submitted(local.clone(), first).unwrap();
    assert!(chain.mark_batch_confirmed(local.index, &anchor()).is_err());
    assert!(chain.mark_batch_submitted(local.clone(), Hash256::hash(b"corrected intent")).is_err());
    assert_eq!(chain.stats().submitted_batches, 1);
    assert_eq!(chain.stats().confirmed_batches, 0);
    assert_eq!(chain.get_known_batch(local.index).unwrap().batch_hash, local.batch_hash);
}

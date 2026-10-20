//! Exporta un certificado público legado y las aperturas usadas para reconstruirlo.

use nexus_zk::stark::{
    air::{prove_state_transition, verify_state_transition, StarkProof, TransitionStatement, BLOWUP},
    channel::{Channel, TAG_FINAL, TAG_FRI_ROOT, TAG_STATEMENT, TAG_TRACE_ROOT},
    field::{root_of_unity, Felt, GENERATOR},
    fri::derive_query_indices,
    params::POW_BITS_RUNTIME,
};
use serde::{Deserialize, Serialize};
use std::{collections::BTreeMap, error::Error, fs, path::Path};

// El orden y tipos coinciden con PqValidityProof, sin modificar el módulo legado.
#[derive(Serialize, Deserialize)]
struct Certificado {
    statement: TransitionStatement,
    proof: StarkProof,
}

fn exportar(destino: &Path) -> Result<(), Box<dyn Error>> {
    let (statement, proof) = prove_state_transition(Felt::new(3), Felt::new(5), 16);
    let bytes = bincode::serialize(&Certificado { statement, proof })?;
    // El extractor lee únicamente la representación pública deserializada.
    let certificado: Certificado = bincode::deserialize(&bytes)?;
    let s = &certificado.statement;
    let p = &certificado.proof;
    if !verify_state_transition(s, p) {
        return Err("El certificado generado no supera el verificador legado".into());
    }
    let dominio = s.steps * BLOWUP;
    let mut canal = Channel::new(b"NEXUS-STARK-v2");
    let mut enunciado = Vec::new();
    enunciado.extend_from_slice(&s.start.to_bytes());
    enunciado.extend_from_slice(&s.output.to_bytes());
    enunciado.extend_from_slice(&(s.steps as u64).to_le_bytes());
    canal.absorb_tagged(TAG_STATEMENT, &enunciado);
    canal.absorb_tagged(TAG_TRACE_ROOT, p.trace_root.as_bytes());
    for _ in 0..3 { canal.challenge_ext(); }
    for raiz in &p.fri_roots {
        canal.absorb_tagged(TAG_FRI_ROOT, raiz.as_bytes());
        canal.challenge_ext();
    }
    canal.absorb_tagged(TAG_FINAL, &p.fri_final.to_bytes());
    if !canal.check_grinding(p.pow_nonce, POW_BITS_RUNTIME) {
        return Err("No se reprodujo el nonce público".into());
    }
    let indices = derive_query_indices(&mut canal, dominio);
    if indices.len() != p.queries.len() {
        return Err("Número de consultas incompatible".into());
    }
    let omega = root_of_unity(dominio.trailing_zeros());
    let mut puntos = BTreeMap::new();
    let mut aperturas = Vec::new();
    for (consulta, (&indice, query)) in indices.iter().zip(&p.queries).enumerate() {
        if query.trace.len() != 6 { return Err("Consulta AIR mal formada".into()); }
        for (ranura, apertura) in query.trace.iter().enumerate() {
            let posicion = (indice + (ranura / 3) * (dominio / 2) + (ranura % 3) * BLOWUP) % dominio;
            let x = Felt::new(GENERATOR).mul(omega.pow(posicion as u64));
            let valor = u64::from_le_bytes(apertura.value.to_bytes());
            if let Some((_, anterior, _, _)) = puntos.get(&posicion) {
                if *anterior != valor { return Err("Aperturas contradictorias".into()); }
            } else {
                puntos.insert(posicion, (u64::from_le_bytes(x.to_bytes()), valor, consulta, ranura));
            }
            aperturas.push(serde_json::json!({"consulta": consulta, "ranura": ranura,
                "indice": posicion, "valor": valor}));
        }
    }
    if puntos.len() < s.steps { return Err("Faltan puntos públicos distintos".into()); }
    let seleccionados: Vec<_> = puntos.iter().take(s.steps).map(|(indice, (x, valor, consulta, ranura))|
        serde_json::json!({"indice": indice, "x": x, "valor": valor,
            "consulta": consulta, "ranura": ranura})).collect();
    let registro = serde_json::json!({"formato": "PqValidityProof legado bincode 1.3.3",
        "dominio_canal": "NEXUS-STARK-v2", "T": s.steps, "N": dominio,
        "inicio": u64::from_le_bytes(s.start.to_bytes()),
        "salida": u64::from_le_bytes(s.output.to_bytes()), "bits": POW_BITS_RUNTIME,
        "nonce": p.pow_nonce, "indices_consulta": indices,
        "aperturas": aperturas, "puntos_distintos": puntos.len(),
        "seleccionados": seleccionados, "verificador_legado_acepta": true});
    fs::create_dir_all(destino)?;
    fs::write(destino.join("certificado-legado-16.bin"), &bytes)?;
    fs::write(destino.join("aperturas-legado-16.json"), serde_json::to_vec_pretty(&registro)?)?;
    println!("Certificado legado aceptado; {} puntos distintos, 16 seleccionados", puntos.len());
    Ok(())
}

fn main() -> Result<(), Box<dyn Error>> {
    let destino = std::env::args().nth(1).ok_or("Se requiere el directorio de evidencia")?;
    exportar(Path::new(&destino))
}

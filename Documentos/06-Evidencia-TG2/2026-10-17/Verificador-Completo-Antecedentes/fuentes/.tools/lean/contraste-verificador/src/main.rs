//! Contraste externo del corpus y rechazos; no es una prueba formal de Rust.
use bincode::Options;
use nexus_core::Hash256;
use nexus_zk::stark::{air::TransitionStatement, field::{Felt, P}};
use serde_json::{json, Value};
use std::{error::Error, fs, path::{Path, PathBuf}};

#[allow(dead_code)]
#[path = "../../../../nexus/nexus-zk/experiments/tg2_linked_trace_fri.rs"]
mod vinculado;
type Certificado = (TransitionStatement, vinculado::LinkedProof);

fn resultado(bytes: &[u8], estricto: bool) -> String {
    let parsed: Result<Certificado, _> = if estricto {
        bincode::DefaultOptions::new().with_fixint_encoding().reject_trailing_bytes().deserialize(bytes)
    } else { bincode::deserialize(bytes) };
    match parsed {
        Err(_) => "Lectura".to_owned(),
        Ok((s, p)) => match vinculado::verify(&s, &p) {
            Ok(()) => "Acepta".to_owned(), Err(e) => format!("{e:?}"),
        },
    }
}

fn registrar(destino: &Path, casos: &mut Vec<Value>, nombre: &str, bytes: &[u8], esperado: &str,
    estricto_esperado: &str) -> Result<(), Box<dyn Error>> {
    let rust = resultado(bytes, false);
    let estricto = resultado(bytes, true);
    if rust != esperado || estricto != estricto_esperado {
        return Err(format!("{nombre}: Rust={rust}, estricto={estricto}; esperado={esperado}/{estricto_esperado}").into());
    }
    let archivo = format!("{nombre}.bin");
    fs::write(destino.join(&archivo), bytes)?;
    let digest = Hash256::hash(bytes);
    let huella: String = digest.as_bytes().iter().map(|b| format!("{b:02x}")).collect();
    casos.push(json!({"nombre": nombre, "archivo_binario": archivo, "bytes": bytes.len(), "sha3_256":
        huella, "rust": rust, "envoltura_estricta": estricto}));
    Ok(())
}

fn main() -> Result<(), Box<dyn Error>> {
    let args: Vec<_> = std::env::args_os().collect();
    if args.len() != 3 { return Err("Uso: contraste-verificador CORPUS SALIDA_JSON".into()); }
    let perfil = if cfg!(debug_assertions) { "debug" } else { "release" };
    let carpeta = PathBuf::from(&args[1]).join(format!("corpus-{perfil}"));
    let destino = Path::new(&args[2]).with_extension("");
    fs::create_dir_all(&destino)?;
    let mut caminos: Vec<_> = fs::read_dir(&carpeta)?.map(|r| r.map(|e| e.path())).collect::<Result<_, _>>()?;
    caminos.sort();
    let mut casos = vec![];
    for path in caminos.into_iter().filter(|p| p.extension().is_some_and(|e| e == "bin")) {
        let nombre = path.file_name().ok_or("Archivo sin nombre")?.to_string_lossy();
        let esperado = if nombre.starts_with("honesto-") { "Acepta" } else { "TraceFri" };
        registrar(&destino, &mut casos, &nombre, &fs::read(&path)?, esperado, esperado)?;
    }
    let base = fs::read(carpeta.join("honesto-16.bin"))?;
    let original: Certificado = bincode::deserialize(&base)?;
    let mut cola = base.clone(); cola.extend_from_slice(&[1, 2, 3]);
    registrar(&destino, &mut casos, "sufijo-tres-bytes", &cola, "Acepta", "Lectura")?;
    registrar(&destino, &mut casos, "truncado", &base[..base.len()-1], "Lectura", "Lectura")?;
    let mut no_canonico = base.clone(); no_canonico[..8].copy_from_slice(&P.to_le_bytes());
    registrar(&destino, &mut casos, "campo-no-canonico", &no_canonico, "NonCanonical", "NonCanonical")?;
    let mut pruebas: Vec<(&str, Certificado, &str)> = vec![];
    let mut c = original.clone(); c.0.steps = 17; pruebas.push(("filas", c, "Rows"));
    let mut c = original.clone(); c.1.version = 2; pruebas.push(("version", c, "Profile"));
    let mut c = original.clone(); c.1.pow_bits = 1; pruebas.push(("trabajo-perfil", c, "Profile"));
    let mut c = original.clone(); c.1.trace_fri.roots.clear(); pruebas.push(("raices-vacias", c, "Shape"));
    let mut c = original.clone(); c.1.queries.pop(); pruebas.push(("faltan-consultas", c, "Shape"));
    let mut c = original.clone(); c.1.trace_root = Hash256::ZERO; pruebas.push(("raiz-compartida", c, "TraceRoot"));
    let mut c = original.clone(); c.1.queries[0].trace.pop(); pruebas.push(("faltan-puntos-air", c, "Shape"));
    let mut c = original.clone(); c.1.queries[0].trace[0].proof.siblings.pop(); pruebas.push(("camino-corto", c, "Shape"));
    let mut c = original.clone(); c.1.queries[0].trace_fri.layers.pop(); pruebas.push(("faltan-capas", c, "Shape"));
    let mut c = original.clone(); c.1.queries[0].trace[0].value = c.1.queries[0].trace[0].value.add(Felt::ONE);
    pruebas.push(("apertura-air", c, "TraceOpening"));
    let mut c = original.clone(); c.1.queries[0].trace_fri.layers[0].left =
        c.1.queries[0].trace_fri.layers[0].left.add(nexus_zk::stark::field::Fp2::ONE);
    pruebas.push(("enlace-traza", c, "TraceLink"));
    let mut c = original.clone(); c.1.queries[0].trace_fri.layers[0].left_proof.siblings[0] = Hash256::ZERO;
    pruebas.push(("fri-traza", c, "TraceFri"));
    let mut c = original.clone(); c.1.queries[0].composition_fri.layers[0].left =
        c.1.queries[0].composition_fri.layers[0].left.add(nexus_zk::stark::field::Fp2::ONE);
    pruebas.push(("enlace-composicion", c, "CompositionLink"));
    let mut c = original.clone(); c.1.queries[0].composition_fri.layers[0].right_proof.siblings[0] = Hash256::ZERO;
    pruebas.push(("fri-composicion", c, "CompositionFri"));
    let mut fallo_trabajo = None;
    for delta in 1..=64 { let mut c = original.clone(); c.1.nonce = c.1.nonce.wrapping_add(delta);
        if vinculado::verify(&c.0, &c.1) == Err(vinculado::VerifyError::Grinding) { fallo_trabajo = Some(c); break; } }
    pruebas.push(("nonce-invalido", fallo_trabajo.ok_or("No se encontró rechazo de trabajo en 64 intentos")?, "Grinding"));
    for (nombre, c, esperado) in pruebas { registrar(&destino, &mut casos, nombre, &bincode::serialize(&c)?, esperado, esperado)?; }
    let reporte = json!({"esquema": 1, "correcto": true, "perfil": perfil, "casos": casos,
        "limite": "Contraste de ejemplos en Rust. El EOF estricto es una envoltura adicional; bincode::deserialize admite sufijos. No es refinamiento universal ni ejecución de Lean."});
    fs::write(Path::new(&args[2]), serde_json::to_vec_pretty(&reporte)?)?;
    println!("Contraste {perfil}: {} casos correctos", reporte["casos"].as_array().ok_or("Casos inválidos")?.len());
    Ok(())
}

#[cfg(test)]
mod pruebas {
    use super::*;
    #[test]
    fn truncamiento_se_distingue_de_verificacion() {
        assert_eq!(resultado(&[], false), "Lectura");
        assert_eq!(resultado(&[0; 12], true), "Lectura");
    }
}

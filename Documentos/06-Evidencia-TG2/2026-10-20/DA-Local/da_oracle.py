from pathlib import Path
import hashlib
import json

payload = bytes([7]) * 512
digest = hashlib.sha3_256(payload).digest()
leaves = []
for index in range(2):
    preimage = (b'NEXUS/LOCAL-DA/CHUNK/V1' + digest + (512).to_bytes(8, 'little')
        + (2).to_bytes(4, 'little') + index.to_bytes(4, 'little') + bytes([7]) * 256)
    leaves.append(hashlib.sha3_256(preimage).digest())
result = {'herramienta': 'Python hashlib.sha3_256; sin importar codigo Rust',
    'payload': '512 bytes de valor 7', 'version': 1, 'data_size': 512, 'chunk_count': 2,
    'payload_sha3': digest.hex(), 'leaf_0': leaves[0].hex(), 'leaf_1': leaves[1].hex(),
    'chunk_root': hashlib.sha3_256(b''.join(leaves)).hexdigest()}
Path(__file__).with_name('da-oracle.json').write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
print(json.dumps(result))

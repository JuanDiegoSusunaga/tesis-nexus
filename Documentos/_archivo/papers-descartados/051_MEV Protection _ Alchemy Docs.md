# MEV Protection | Alchemy Docs

- **ID**: `56cd430c-4d1d-49b4-9bdc-550382c7112e`
- **Tipo de Fuente**: `SOURCE_TYPE_WEB_PAGE`
- **URL**: [https://www.alchemy.com/docs/reference/mev-protection](https://www.alchemy.com/docs/reference/mev-protection)

---

## Contenido Extraído / Texto Completo

MEV Protection | Alchemy Docs
For the complete documentation index, see llms.txt.
Skip to content
Alchemy LogoAlchemy Logo
Search or Ask AI Ctrl K
Go to Dashboard
Chains
Data
Wallets
Build with AI
Tools & Resources
Changelog
Chains
Data
Wallets
Build with AI
Tools & Resources
Changelog
Introduction
API Overview Supported Chains MEV Protection Pricing
WebSockets
Trace API
Debug API
Yellowstone gRPC
Launch Your Own Chain (Rollups)
Chains
Ethereum
Robinhood Chain
Solana
Abstract
ADI
Anime
Apechain
Show all ( 79 more)
Go to Dashboard
Introduction
API Overview Supported Chains MEV Protection Pricing
WebSockets
Trace API
Debug API
Yellowstone gRPC
Launch Your Own Chain (Rollups)
Chains
Ethereum
Robinhood Chain
Solana
Abstract
ADI
Anime
Apechain
Show all ( 79 more)
Introduction
Copy page
MEV Protection
Alchemy's RPC endpoints now come with built-in MEV protection on supported chains. This feature helps prevent frontrunning, sandwich attacks, and other forms of transaction manipulation with no additional code changes or tooling required.
Why it matters
By default, most blockchain transactions are broadcast to the public mempool. This exposes them to MEV (Maximal Extractable Value) risks, where bots insert transactions to extract profit at the user's expense.
MEV protection mitigates this risk by routing transactions through private infrastructure. This improves transaction privacy, protects ordering, and reduces block inclusion time.
How MEV protection works
Transactions sent through Alchemy's MEV-protected RPC endpoints are:
Routed through private mempools — not broadcast publicly.
Hidden until block inclusion — keeping sensitive trade details private.
Ordered fairly — processed in the original sequence without manipulation.
Shielded from frontrunning and sandwiching — keeping transaction intent intact.
This protection is powered through trusted Order Flow Auction (OFA) partners like Merkle and Blink.
Supported networks
MEV protection is automatically enabled on:
Ethereum
Arbitrum
BNB Smart Chain (BSC)
Base
Solana
No configuration changes are required. Just send transactions to the standard RPC endpoint.
Key benefits
✅ Automatically protects transactions from MEV
✅ Faster block inclusion through private routing
✅ No changes required in your dApp logic
✅ Included at no additional cost
Was this page helpful?
Yes No
Previous
Next Subscription API Overview Learn how to subscribe to pending transactions, log events, new blocks, account and program updates, and more using WebSockets on Ethereum, Polygon, Arbitrum, Optimism, and Solana.
AI tools
Copy as Markdown
View as Markdown(opens in new tab)
Ask Claude(opens in new tab)
Ask ChatGPT(opens in new tab)
On this page
Why it matters
How MEV protection works
Supported networks
Key benefits
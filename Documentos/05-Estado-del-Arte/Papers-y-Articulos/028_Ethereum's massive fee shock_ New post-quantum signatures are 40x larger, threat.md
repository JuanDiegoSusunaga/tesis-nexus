# Ethereum's massive fee shock: New post-quantum signatures are 40x larger, threatening to crush network throughput and user costs - CryptoSlate

- **ID**: `9c4a7719-bd32-40f9-9e54-40b1605d6693`
- **Tipo de Fuente**: `SOURCE_TYPE_WEB_PAGE`
- **URL**: [https://cryptoslate.com/ethereums-massive-fee-shock-new-post-quantum-signatures-are-40x-larger-threatening-to-crush-network-throughput-and-user-costs/](https://cryptoslate.com/ethereums-massive-fee-shock-new-post-quantum-signatures-are-40x-larger-threatening-to-crush-network-throughput-and-user-costs/)

---

## Contenido Extraído / Texto Completo

Ethereum's massive fee shock: New post-quantum signatures are 40x larger, threatening to crush network throughput and user costs
More Search
CryptoSlate
Search CryptoSlate Type /
Install App Light Mode
Now reading Article
Ethereum's massive fee shock: New post-quantum signatures are 40x larger, threatening to crush network throughput and user costs
Back to Top Top Share
News Coins Predictions NEW Laws Learn Reviews Directory More 
› News › Quantum › Ethereum
Ethereum's massive fee shock: New post-quantum signatures are 40x larger, threatening to crush network throughput and user costs
Coinbase, Solana, Polkadot, and Bitcoin all moved on PQ planning, but wallet UX and aggregation may decide the winner.
By Gino Matos
Reporter
• CryptoSlate 
Image by CryptoSlate
Jan. 27, 2026 at 12:14 pm GMT
• Updated Jan. 27, 2026 at 12:30 pm GMT
• 6 min read
MakeCryptoSlate logo CryptoSlate preferred onGoogle logo
Share     
Share     
Ethereum elevated post-quantum cryptography to a top strategic priority this month, forming a dedicated PQ team led by Thomas Coratger and announcing $1 million in prizes to harden hash-based primitives.
The announcement came one day before a16z crypto published a roadmap arguing that quantum threats are frequently overstated and premature migrations risk trading known security for speculative protection.
Both positions are defensible, and the apparent tension reveals where the real battle lies.
The Ethereum Foundation's announcement frames PQ security as an inflection point. Multi-client consensus devnets are live, bi-weekly All Core Devs calls start next month to coordinate precompiles and account abstraction paths, and a comprehensive roadmap promises “zero loss of funds and zero downtime” during a multi-year transition.
Coinbase launched an independent quantum advisory board on Jan. 21, including Ethereum researcher Justin Drake, signaling cross-industry alignment around long-horizon planning.
Solana ran PQ signature experiments on testnet in December under Project Eleven, explicitly branding the work as “proactive” rather than emergency-driven.
[ Related Reading
Solana co-founder urges need for Bitcoin to adopt quantum resistance for future security
Yakovenko praised Bitcoin's decentralized nature and proof-of-work system but warned that quantum compting poses threats. Sep 19, 2025 · Oluwapelumi Adejumo](https://cryptoslate.com/solana-co-founder-urges-need-for-bitcoin-to-adopt-quantum-resistance-for-future-security/)
Polkadot's JAM proposal outlines ML-DSA and Falcon deployment alongside SNARK-based migration proofs.
Bitcoin's conservative BIP-360 proposal for pay-to-quantum-resistant-hash represents an incremental first step constrained by governance realities.
The pattern resembles an arms race, but not one driven by an imminent threat.
This is a competition in institutional readiness, where the winner preserves fee economics, consensus efficiency, and wallet UX while upgrading cryptographic foundations before external pressure forces rushed coordination.
The harvest paradox
a16z's core argument hinges on distinguishing harvest-now-decrypt-later risk from signature vulnerability. HNDL attacks matter when adversaries can intercept encrypted data today and decrypt it once quantum computers achieve sufficient scale.
That threat maps cleanly to TLS, VPNs, and data-at-rest encryption. Less so to blockchain signatures, which authenticate transactions in real time and leave no encrypted payload to store for future cracking.
Ethereum's response implicitly accepts this framing but argues operational urgency remains high because changing signature schemes touches everything: wallets, account formats, hardware signers, custody infrastructure, mempools, fee markets, consensus messages, and L2 settlement proofs.
Migration requires years of lead time, not because quantum computers are imminent, but because the engineering surface is vast and failure modes are catastrophic.
NIST finalized its first post-quantum standards in 2024, FIPS 203, 204, and 205, and selected HQC as a backup key encapsulation mechanism while advancing Falcon and FN-DSA toward draft stages.
The EU issued a coordinated PQC transition roadmap in June 2025. These developments reduce “which algorithms?” uncertainty and make migration planning concrete, even if cryptographically relevant quantum computing remains distant.
Citi's January 2026 report cites probability ranges for widespread breaking of public key encryption by 2034 and 2044, though many experts view CRQC in the 2020s as highly unlikely. 
Kalshi data shows 50% of respondents expect the first useful quantum computer before 2035, with 59% predicting arrival before 2030.
The timeline ambiguity doesn't eliminate the planning imperative: it amplifies it, because chains that wait until threat signals are unambiguous will face compressed timelines and coordination chaos.
Signature bloat as the base-layer bottleneck
The immediate technical challenge is signature size.
ECDSA signatures consume roughly 65 bytes, which translates to approximately 1,040 gas under Ethereum's calldata pricing model at 16 gas per non-zero byte.
ML-DSA candidates produce signatures in the 2-3 KB range, with Dilithium variants likely to see wide adoption. A 2,420-byte signature consumes roughly 38,720 gas just for the signature bytes, a 37,680-gas delta versus ECDSA.
That overhead is material enough to affect throughput and fees unless chains compress or aggregate signatures at the protocol level.
This is where Ethereum's bet on hash-based cryptography and the $1 million Poseidon Prize becomes strategic. Hash-based signatures avoid the algebraic structure that quantum algorithms exploit, and hash functions integrate naturally with zero-knowledge proof systems.
If Ethereum can make STARK-based signature aggregation practical, it preserves fee economics while upgrading security assumptions. The challenge is that no practical post-quantum analogue to BLS aggregation exists yet, and zk-based aggregation introduce real performance constraints.
Consensus efficiency depends on this problem.
Ethereum's consensus layer relies heavily on BLS signature aggregation today. Validators sign attestations and sync committee messages, and the protocol aggregates thousands of signatures into compact proofs.
Losing that capability without a replacement would force dramatic changes to consensus participation economics or liveness assumptions.
EF's public emphasis on “lean” cryptographic foundations and interop calls coordinating multi-client PQ devnets suggests the organization understands aggregation is the hidden cliff.
[ Related Reading
Vitalik proposes 'Lean Ethereum' to achieve quantum security, simpler validator operations
The concept already has four research tracks already under review, which are connected to existing efforts in the Ethereum ecosystem. Jun 12, 2025 · Gino Matos](https://cryptoslate.com/vitalik-proposes-lean-ethereum-to-achieve-quantum-security-simpler-validator-operations/)
Wallet UX as the social layer of cryptography
Protocol support alone doesn't complete the migration.
Externally owned accounts can't rotate keys cleanly under Ethereum's current design. Users need one-click migration flows that don't require deep technical knowledge. Hardware wallets must ship firmware updates. Custodians need a safe bulk migration tooling.
Ethereum researchers have explored key-recovery-friendly proof systems and seed-based migration approaches precisely to reduce coordination risk and UX friction.
a16z warns that premature migration introduces fragility, including immature implementations, shifting standards after deployment, and bugs in new cryptographic libraries.
CryptoSlate Daily Brief
Daily signals, zero noise.
Market-moving headlines and context delivered every morning in one tight read.
5-minute digest 100k+ readers
Email address
Get the brief
Free. No spam. Unsubscribe any time.
Whoops, looks like there was a problem. Please try again.
You're subscribed. Welcome aboard.
The organization argues that current security issues, such as governance failures and software bugs, pose a greater immediate risk than quantum computers.
This is the crux of the “don't panic” framing: migrating too early trades known security for speculative security, and the cost of getting it wrong is potentially higher than the cost of waiting for standards maturity and better tooling.
Both positions are defensible because they optimize for different failure modes. EF prioritizes avoiding rushed coordination under pressure.
a16z prioritizes avoiding self-inflicted wounds from hasty deployment. The divergence reveals the real battleground: chains that thread the needle, building migration infrastructure early without prematurely forcing users onto immature standards, will gain a competitive advantage.
[ Related Reading
Bitcoin's “quantum” death sentence is causing a Wall Street rift, but the fix is already hidden in the code
The quantum computing threat challenges Bitcoin's status as "digital gold," prompting strategic shifts. Jan 16, 2026 · Oluwapelumi Adejumo](https://cryptoslate.com/bitcoins-quantum-death-sentence-is-causing-a-wall-street-rift-but-the-fix-is-already-hidden-in-the-code/)
Three scenarios, different winners
The migration timeline depends on external breakthroughs that no one controls.
In a slow-burn scenario where CRQC doesn't arrive until the 2040s, migration occurs on a regulatory and standards cadence, prioritizing safety over speed. Chains that invested in crypto agility, with dual-signature periods, hybrid schemes, break-glass playbooks, can adapt without disruption.
In the base case where material quantum threats emerge in the mid-2030s, today's work determines outcomes. If the ecosystem wants smooth transitions by 2035, wallet tooling and aggregation research must be production-ready years earlier.
This is the scenario EF's roadmap optimizes for, and the one where multi-year lead times justify current investment.
In a fast-shock scenario where breakthroughs signal credible risk before 2030, the differentiator becomes how quickly a chain can freeze exposure, migrate accounts, and maintain liveness. a16z argues this outcome is unlikely, but the organization's emphasis on planning suggests even low-probability tail risks justify preparation.
Triggers to watch include credible demonstrations of error-corrected scaling, logical qubit stability, and sustained gate fidelities. NIST or major governments advancing migration deadlines, and major custodians shipping PQ-capable signing in production.
None are imminent, but all would compress decision timelines.
The new status game
Post-quantum readiness is becoming an institutional credibility metric, following the same path L2 maturity took in previous cycles.
Chains without credible PQ roadmaps risk being perceived as unprepared for long-term settlement assurance, even if the immediate threat is distant.
This dynamic explains why Solana, Polkadot, and Bitcoin all have active PQ workstreams despite the absence of imminent Q-day consensus.
The arms race isn't about who flips PQ first. Instead, it's about who preserves UX, fee economics, and consensus efficiency while doing it.
Ethereum's approach bets on hash-based foundations, zk aggregation, and governance coordination.
Solana's high-throughput architecture makes signature overhead particularly acute, forcing design innovation.
Polkadot's heterogeneous sharding model allows per-chain experimentation.
Bitcoin's conservatism reflects governance constraints and a long tail of legacy outputs that can't be migrated without owner cooperation.
[ Related Reading
Bitcoin encryption isn't at risk from quantum computers for one simple reason: it doesn't actually exist
There are no secret messages on the blockchain to decrypt. The real threat is Shor's algorithm forging signatures on keys you've already revealed. Dec 19, 2025 · Liam 'Akiba' Wright](https://cryptoslate.com/bitcoin-encryption-isnt-at-risk-from-quantum-computers-for-one-simple-reason-it-doesnt-actually-exist/)
If PQ becomes the next L1 arms race, the winner won't be the chain that announces the most prizes or devnets. It will be the chain that ships a migration path normal users actually complete, preserves throughput despite multi-KB signature candidates, and replaces today's aggregation assumptions without sacrificing liveness.
The planning layer, wallet UX layer, and aggregation layer are now the real battleground, and the clock started years before most participants realized the race had begun.
Mentioned in this article
Ethereum Bitcoin Solana Polkadot Coinbase Citigroup Ethereum Foundation a16z
Posted in
Featured
Ethereum logo Ethereum Technology Web3 Quantum
Gino Matos
Reporter
• CryptoSlate
Gino Matos is a law school graduate and a seasoned journalist with six years of experience in the crypto industry. His expertise primarily focuses on the Brazilian blockchain ecosystem and developments in decentralized finance (DeFi).
X LinkedIn
View profile
Liam 'Akiba' Wright
Editor-in-Chief
• CryptoSlate
X LinkedIn
View profile
Context
Related coverage
Explore related reporting by asset, place, or topic. 
Ethereum Quantum
[ Technology
As Ethereum turns 11 years old it hosts $148B in stablecoins, but daily mainnet revenue just fell to $330k
Ethereum enters its second decade facing four tests around ETH value capture, rollup cohesion, ecosystem leadership and neutral scaling. 2 hours ago](https://cryptoslate.com/as-ethereum-turns-11-years-old-it-hosts-148b-in-stablecoins-but-daily-mainnet-revenue-just-fell-to-330k/)
[ ETF Bullish
Morgan Stanley Ethereum and Solana ETFs outperform rivals as second-day inflows reach $33 million
Morgan Stanley's MSSE beat BlackRock's dominant ETH fund while MSOL captured all inflows into US Solana ETFs. 17 hours ago](https://cryptoslate.com/morgan-stanley-ethereum-and-solana-etfs-outperform-rivals-as-second-day-inflows-reach-33-million/)
[ ETF
Morgan Stanley is using $7.4 trillion in client assets and rock-bottom fees to hijack Wall Street's crypto boom
MSSE captured more than a third of daily Ethereum ETF inflows, while both funds entered with fees below most staking rivals. 2 days ago](https://cryptoslate.com/morgan-stanley-is-using-7-4-trillion-in-client-assets-and-rock-bottom-fees-to-hijack-wall-streets-crypto-boom/)
[ Quantum
$460 billion Bitcoin risk draws BlackRock, Coinbase and Strategy into $15M quantum defense mission
The new consortium comes as falling estimates for quantum computing requirements put greater focus on Bitcoin's exposed public keys. 1 week ago](https://cryptoslate.com/460-billion-bitcoin-risk-draws-blackrock-coinbase-and-strategy-into-15m-quantum-computing-defense-push/)
[ Quantum
Galaxy puts $5 million behind Bitcoin's race to migrate before quantum risk arrives
Bitcoin is safe today, but signatures, software, custodians and users would need years to coordinate a defense. 1 week ago](https://cryptoslate.com/galaxy-puts-5-million-behind-bitcoins-race-to-migrate-before-quantum-risk-arrives/)
[ Technology
BNB Chain makes moonshot bet on 1,000,000 TPS for AI as BNB interest falls away
The BNB Chain is rebuilding its architecture as BNB trades near its lowest level since October 2024. 3 weeks ago](https://cryptoslate.com/binance-backed-network-chases-ai-agent-economy-with-1m-tps-privacy-overhaul-amid-bnbs-price-struggles/)
AI Usage Disclosure
CryptoSlate may use AI tools to support research, editing, and production workflows. Published articles remain editorially reviewed by our team. Read our full AI usage disclaimer.
Disclaimer
Our writers' opinions are solely their own and do not reflect the opinion of CryptoSlate. None of the information you read on CryptoSlate should be taken as investment advice, nor does CryptoSlate endorse any project that may be mentioned or linked to in this article. Buying and trading cryptocurrencies should be considered a high-risk activity. Please do your own due diligence before taking any action related to content within this article. Finally, CryptoSlate takes no responsibility should you lose money trading cryptocurrencies. For more information, see our company disclaimers.
Ethereum ETH
$ 1,875.50 -2.30% (24H) 2.30% (24H)
1D 7D 1M 1Y ALL
Market Cap
$ 226.34B
24H Volume
$ 8.86B
Circulating Supply
120.68M
Layer 1 Dominance
12.6%
View ETH markets In this article 
Bitcoin Bitcoin, Coin 
Solana Solana, Coin 
Polkadot Polkadot, Coin 
Coinbase Coinbase, Company 
Citigroup Citigroup, Company 
Ethereum Foundation Ethereum Foundation, Company 
a16z a16z, Company +0
Latest Guide What is Dogecoin? Learn what Dogecoin is, how DOGE mining works, why supply keeps growing, and how to weigh payment use... 1 month ago
1.5BitPay Card logo Review BitPay Card The BitPay Card no longer exists as a usable product. On May 17, 2023, BitPay emailed cardholders that... 2 days ago
7.5Playnance logo Project Report G Coin: Playnance's On-Chain Entertainment Economy An independent analysis of G Coin, covering its role in Playnance's on-chain entertainment ecosystem, token utility, tokenomics, audits,... 3 months ago
Guide Review Report
Cookie Consent
We use cookies to improve your experience on our site. By using our site, you consent to cookies.
Preferences Reject Accept All
Cookie Preferences
×
Manage your cookie preferences below:
Toggle Essential Essential [x]
Essential cookies enable basic functions and are necessary for the proper function of the website.
Name
Description
Duration
Cookie Preferences
This cookie is used to store the user's cookie consent preferences.
30 days
Cookie Preferences
This cookie is used to store the user's cookie consent preferences.
30 days
Cookie Preferences
This cookie is used to store the user's cookie consent preferences.
30 days
Cookie Preferences
This cookie is used to store the user's cookie consent preferences.
30 days
Cookie Preferences
This cookie is used to store the user's cookie consent preferences.
30 days
Cookie Preferences
This cookie is used to store the user's cookie consent preferences.
30 days
Cookie Preferences
This cookie is used to store the user's cookie consent preferences.
30 days
Cookie Preferences
This cookie is used to store the user's cookie consent preferences.
30 days
Cookie Preferences
This cookie is used to store the user's cookie consent preferences.
30 days
Cookie Preferences
This cookie is used to store the user's cookie consent preferences.
30 days
Cookie Preferences
This cookie is used to store the user's cookie consent preferences.
30 days
Cookie Preferences
This cookie is used to store the user's cookie consent preferences.
30 days
Cookie Preferences
This cookie is used to store the user's cookie consent preferences.
30 days
Cookie Preferences
This cookie is used to store the user's cookie consent preferences.
30 days
Cookie Preferences
This cookie is used to store the user's cookie consent preferences.
30 days
Cookie Preferences
This cookie is used to store the user's cookie consent preferences.
30 days
Cookie Preferences
This cookie is used to store the user's cookie consent preferences.
30 days
Cookie Preferences
This cookie is used to store the user's cookie consent preferences.
30 days
Geolocation Config
This cookie is used to store the consent settings based on the visitor's location.
30 days
Cookie Preferences
This cookie is used to store the user's cookie consent preferences.
30 days
Toggle CloudFlare CloudFlare
CloudFlare provides web performance and security solutions, enhancing site speed and protecting against threats.
Service URL: developers.cloudflare.com (opens in a new window)
Name
Description
Duration
cf_ob_info
The cf_ob_info cookie provides information on: The HTTP Status Code returned by the origin web server. The Ray ID of the original failed request. The data center serving the traffic
session
__cfseq
Sequence rules uses cookies to track the order of requests a user has made and the time between requests and makes them available via Cloudflare Rules. This allows you to write rules that match valid or invalid sequences. The specific cookies used to validate sequences are called sequence cookies.
session
cf_clearance
Whether a CAPTCHA or Javascript challenge has been solved.
session
_cfuvid
The _cfuvid cookie is only set when a site uses this option in a Rate Limiting Rule, and is only used to allow the Cloudflare WAF to distinguish individual users who share the same IP address.
session
__cflb
When enabling session affinity with Cloudflare Load Balancer, Cloudflare sets a __cflb cookie with a unique value on the first response to the requesting client. Cloudflare routes future requests to the same origin, optimizing network resource usage. In the event of a failover, Cloudflare sets a new __cflb cookie to direct future requests to the failover pool.
session
__cf_bm
Cloudflare's bot products identify and mitigate automated traffic to protect your site from bad bots. Cloudflare places the __cf_bm cookie on End User devices that access Customer sites that are protected by Bot Management or Bot Fight Mode. The __cf_bm cookie is necessary for the proper functioning of these bot solutions.
session
__cfruid
Used by the content network, Cloudflare, to identify trusted web traffic.
session
cf_chl_rc_m
These cookies are for internal use which allows Cloudflare to identify production issues on clients.
session
cf_chl_rc_ni
These cookies are for internal use which allows Cloudflare to identify production issues on clients.
session
cf_chl_rc_i
These cookies are for internal use which allows Cloudflare to identify production issues on clients.
session
__cfwaitingroom
The __cfwaitingroom cookie is only used to track visitors that access a waiting room enabled host and path combination for a zone. Visitors using a browser that does not accept cookies cannot visit the host and path combination while the waiting room is active.
session
cf_use_ob
The cf_use_ob cookie informs Cloudflare to fetch the requested resource from the Always Online cache on the designated port. Applicable values are: 0, 80, and 443. The cf_ob_info and cf_use_ob cookies are persistent cookies that expire after 30 seconds.
session
Toggle Google Analytics Google Analytics
Google Analytics is a powerful tool that tracks and analyzes website traffic for informed marketing decisions.
Service URL: policies.google.com (opens in a new window)
Name
Description
Duration
_gat
Used to monitor number of Google Analytics server requests when using Google Tag Manager
1 minute
_gid
ID used to identify users for 24 hours after last activity
24 hours
ga
ID used to identify users
2 years
_gali
Used by Google Analytics to determine which links on a page are being clicked
30 seconds
_ga
ID used to identify users
2 years
__utmx
Used to determine whether a user is included in an A / B or Multivariate test.
18 months
__utmv
Contains custom information set by the web developer via the _setCustomVar method in Google Analytics. This cookie is updated every time new data is sent to the Google Analytics server.
2 years after last activity
__utmz
Contains information about the traffic source or campaign that directed user to the website. The cookie is set when the GA.js javascript is loaded and updated when data is sent to the Google Anaytics server
6 months after last activity
__utmc
Used only with old Urchin versions of Google Analytics and not with GA.js. Was used to distinguish between new sessions and visits at the end of a session.
End of session (browser)
__utmb
Used to distinguish new sessions and visits. This cookie is set when the GA.js javascript library is loaded and there is no existing __utmb cookie. The cookie is updated every time data is sent to the Google Analytics server.
30 minutes after last activity
__utmt
Used to monitor number of Google Analytics server requests
10 minutes
__utma
ID used to identify users and sessions
2 years after last activity
gac
Contains information related to marketing campaigns of the user. These are shared with Google AdWords / Google Ads when the Google Ads and Google Analytics accounts are linked together.
90 days
Toggle Statistics Statistics [-] statistics
Statistics cookies collect information anonymously. This information helps us understand how visitors use our website.
Toggle Microsoft Clarity Microsoft Clarity
Clarity is a web analytics service that tracks and reports website traffic.
Service URL: clarity.microsoft.com (opens in a new window)
Name
Description
Duration
ANONCHK
Indicates whether MUID is transferred to ANID, a cookie used for advertising. Clarity doesn't use ANID and so this is always set to 0.
Session
CLID
Identifies the first-time Clarity saw this user on any site using Clarity.
12 months
_clsk
Connects multiple page views by a user into a single Clarity session recording.
12 months
_clck
Persists the Clarity User ID and preferences, unique to that site is attributed to the same user ID.
12 months
Toggle Cookie Policy Cookie Policy
You can find more information in our Privacy Policy and .
Accept All Close
Save and Close
CryptoSlate footer
CryptoSlate
Intelligence for the crypto economy       
Market Views
Coin Rankings
Biggest Gainers
Biggest Losers
New Cryptos
Prices
Bitcoin price
Ethereum price
XRP price
Solana price
Crypto News
Bitcoin news
Ethereum news
XRP news
Solana news
Explore
Predictions
Guides
Laws
Glossary
Reviews
Crypto Exchanges
Crypto Wallets
Prediction Markets
Crypto Casinos
Directory
Directory
Companies
Products
People
Company
About Us
Media Kit
Updates
Transparency
Help & Legal
Support
FAQ
Careers
Disclaimers
CryptoSlate Newsletter
Daily signals. Zero noise.
Get market-moving headlines, on-chain insights, and editor picks delivered in one tight read.
Email address Subscribe
We respect your privacy and will never share your email address.
Subscription confirmed
Daily signals, editor picks, and market context are on the way.
You may unsubscribe at any time.
Disclaimer: By using this website, you agree to our Terms and Conditions and Privacy Policy. CryptoSlate has no affiliation or relationship with any company or project unless explicitly stated otherwise. CryptoSlate is an informational website that provides news about coins, companies and products. None of the information you read on CryptoSlate should be taken as investment advice. Buying and trading cryptocurrencies should be considered a high-risk activity. Please do your own diligence before making any investment decisions. CryptoSlate is not accountable, directly or indirectly, for any damage or loss incurred, alleged or otherwise, in connection to the use of or reliance on any content you read on the site. Read all disclaimers
© 2026 CryptoSlate. All rights reserved. Terms & Conditions Privacy Policy Cookie Settings
×
Expand
More about
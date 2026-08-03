# Code for NIST Entropy Health Testing - Lightship Security

- **ID**: `f1028624-0f8f-4682-ba20-6d0045113dc6`
- **Tipo de Fuente**: `SOURCE_TYPE_WEB_PAGE`
- **URL**: [https://lightshipsec.com/code-nist-entropy-health-testing/](https://lightshipsec.com/code-nist-entropy-health-testing/)

---

## Contenido Extraído / Texto Completo

Code for NIST Entropy Health Testing | Lightship Security
This website uses cookies to ensure you get the best experience on our website. Privacy Policy
DeclineAllow cookies
Navigation
About
Story
Team
Partners
Testimonials
Jobs
Resources
Common Criteria
Penetration Testing
FDA Cybersecurity
FIPS 140-3
Services
Common Criteria
Medical Device Testing
FIPS 140-2/3
Security Consulting
Government Programs
Solutions
Test Utilities
Conformance Automation
Blog
Contact
Contact
Request a Quote
About
Story
Team
Partners
Testimonials
Jobs
Resources
Common Criteria
Penetration Testing
FDA Cybersecurity
FIPS 140-3
Services
Common Criteria
Medical Device Testing
FIPS 140-2/3
Security Consulting
Government Programs
Solutions
Test Utilities
Conformance Automation
Blog
Contact
Contact
Request a Quote 
Code for NIST Entropy Health Testing
Greg McLearn December 4, 2017 Entropy, Tools
[ Jan 12, 2018 update: With the final release of NIST SP 800-90B, we've updated the sample health test code to match the minor changes between rev2 and the final version. The narrative of this post with respect to requirements for Common Criteria has been updated below as well to reflect the new published status of this NIST SP.]
In Common Criteria, there has been increasing emphasis on the evaluation of the entropy used by manufacturers in the development and deployment of their systems. The following post discusses considerations and approaches for entropy health testing.
Health testing is, of course, necessary to ensure the proper functioning of the noise being provided to the critical components of the cryptographic systems. Therefore, if a vendor is investing resources in ensuring a strongly seeded DRBG, there should be some effort expended on doing some form of health testing.
When it comes to health testing, NIST SP800-90B draft 2 has two mandatory tests that any conforming implementation will need to run: the Repetition Count test (described in section 4.4.1) and the Adaptive Proportion test (described in section 4.4.2). Both of these continuous tests are described in detail in the Special Publication, so we won't describe them further in this post.
Lightship has published proof of concept C and Python code that vendors can customize to work into their noise source analytics. You can find that code over on our Github repository ( C code, Python code). While the tests themselves are relatively trivial to implement, our value-add is that we have constructed them so that they can operate continuously. The descriptions in NIST 800-90B only consider the standalone algorithms rather than how one might actually implement this in a continuous fashion. These code samples are published as-is without any warrant of fitness, but they might provide starting points for developers to include the functionality into future certifiable products.
With NIST SP 800-90B now published, we should expect to see new requirements soon come in terms of data collection, system documentation, quantitative analysis and health testing.
For more information about approaches to collecting, decoding, health testing and making sense of your entropy sources, talk to Lightship Security. 
Greg McLearn
Greg McLearn is Lightship's Technical Director. He has been doing Common Criteria and security certifications for 10+ years and enjoys getting his hands on some of the latest technology. He has authored several tools to help facilitate security testing.
Common Criteria entropy nist
Search
Recent Posts
FIPS Revalidation Scenarios: Mapping the Right Path for Your Module Changes
FIPS Validation Pitfalls—and How to Avoid Costly Delays
Jitter Entropy in OpenSSL 3.x
NDcPP v4.0 vs. v3.0e: What's Changing and How to Prepare
Accelerate Your EU Common Criteria Certification with Lightship Security & Applus+ Laboratories
LinkedIn
Copyright © 2026 Lightship Security. All rights reserved. | Privacy Policy | Website by Coracle Marketing
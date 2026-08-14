# Deployment

How this site is built and published, how the two domains fit together, and what must not be allowed to lapse.

Last updated: 2026-08-14.

## Overview

The site is a Quarto book, rendered locally and published to GitHub Pages. It is reachable at two addresses:

- **<https://inspect-sr.com>** — the canonical address. Served directly by GitHub Pages.
- **<https://inspect.sr>** — the original address. Permanently redirects (301) to `inspect-sr.com`, preserving the path and query string. Handled entirely at Cloudflare's edge; no server involved.

Both must keep working indefinitely. `inspect.sr` appears in the INSPECT-SR publication (medRxiv 2025.09.03.25334905) and in Cochrane materials, so links to it exist in print and cannot be corrected.

`inspect-sr.com` was added because `.sr` is a rare ccTLD (Suriname) that some institutional and hospital firewalls block outright, leaving a subset of users unable to reach the site at all. `inspect-sr.com` is a `.com` and does not have that problem, which is why it is the one to quote in new writing.

### Request flow

```
Reader types https://inspect-sr.com/chapters/check_4_8.html
  -> Namecheap DNS answers with GitHub Pages IPs
  -> GitHub Pages serves the page (Let's Encrypt certificate)

Reader types https://inspect.sr/chapters/check_4_8.html
  -> Cloudflare DNS answers with Cloudflare's own IPs (record is proxied)
  -> Cloudflare Redirect Rule returns 301 to
     https://inspect-sr.com/chapters/check_4_8.html
  -> as above
```

The redirect never reaches GitHub. Cloudflare answers at the edge, so no origin server is needed for `inspect.sr` and nothing breaks if GitHub Pages is reconfigured.

## Building and publishing

From the repo root:

```
cd ~/git/inspect-sr-guidance
```

Preview locally while editing:

```
quarto preview
```

Render the site, PDF, and Word versions:

```
quarto render
```

Publish to GitHub Pages. This renders, then replaces the `gh-pages` branch and pushes:

```
quarto publish gh-pages
```

To publish without re-rendering — for example when only `CNAME` or a static
resource has changed:

```
quarto publish gh-pages --no-render
```

The PDF linked from the site's toolbar is built by `quarto render`, so publish
after rendering if the PDF should be updated too.

> **Occasionally, and with care.** The following regenerates
> `static/reference.docx` from pandoc's built-in default template:
>
> ```
> quarto pandoc -o static/reference.docx --print-default-data-file reference.docx
> ```
>
> It **overwrites** the existing file, discarding any styling customisation in
> it. `_quarto.yml` uses that file as `reference-doc` for the Word output, so
> only run this if you intend to rebuild the Word styling from scratch.

## Domains

### inspect-sr.com — canonical

| | |
|---|---|
| Registrar | Namecheap |
| DNS | Namecheap BasicDNS (`dns1.registrar-servers.com`, `dns2.registrar-servers.com`) |
| Hosting | GitHub Pages, from the `gh-pages` branch of this repo |
| Certificate | Let's Encrypt, issued and auto-renewed by GitHub |

DNS records:

| Type | Host | Value |
|---|---|---|
| A | `@` | `185.199.108.153` |
| A | `@` | `185.199.109.153` |
| A | `@` | `185.199.110.153` |
| A | `@` | `185.199.111.153` |
| CNAME | `www` | `ianhussey.github.io.` |

The four A records are GitHub Pages' anycast addresses. The apex has to use A records rather than a CNAME because DNS forbids a CNAME coexisting with the `SOA` and `NS` records that every zone apex must carry. `www` has no such constraint, so it can be a CNAME; GitHub then redirects `www` to the apex automatically.

Namecheap's default email-forwarding `MX` records and the accompanying `v=spf1` `TXT` record were left in place. They are unused but harmless, and they preserve the option of email on the domain later.

### inspect.sr — redirect only

| | |
|---|---|
| Registrar | **INWX** — *not* Namecheap; Namecheap does not sell `.sr` |
| DNS | Cloudflare (free plan), nameservers `brett.ns.cloudflare.com`, `yolanda.ns.cloudflare.com` |
| Hosting | none — Cloudflare answers with a redirect |
| Certificate | Cloudflare Universal SSL (issued via Google Trust Services), auto-renewed |
| Expires | 2027-03-25 |

DNS records, **all proxied (orange cloud)**:

| Type | Name | Content |
|---|---|---|
| A | `inspect.sr` | `185.199.108.153` |
| A | `inspect.sr` | `185.199.109.153` |
| A | `inspect.sr` | `185.199.110.153` |
| A | `inspect.sr` | `185.199.111.153` |
| CNAME | `www` | `ianhussey.github.io` |

The record *values* are vestigial. They still point at GitHub from when `inspect.sr` was the live site, but nothing ever follows them: the redirect rule fires at the edge before the origin is contacted. What matters is that the records exist and are **proxied**, because that is what makes Cloudflare answer for the hostname at all. A redirect rule cannot fire on a hostname Cloudflare does not terminate.

> **Where to change the nameservers at INWX.** Domain List → gear icon next to `inspect.sr` → **External Nameservers**. This is the delegation filed with the `.sr` registry, and it is the setting that matters.
>
> It is *not* the **DNS records** entry in the same menu. That opens the zone editor, which also contains `NS` records — editing those changes nothing about who is authoritative, because resolvers follow the delegation held by the registry, not the copy inside the zone. This is an easy and confusing mistake to make.

`.sr` is operated by a small registry (`nic.sr` / Datasur) and nameserver changes are slow — the migration took roughly a day to propagate. Budget days, not minutes, for anything touching `.sr` delegation.

## The redirect

A Cloudflare **Redirect Rule** on the `inspect.sr` zone (Rules → Redirect Rules). Redirect Rules are the current product; Page Rules are legacy and should not be used for this.

- **Name:** `inspect.sr → inspect-sr.com`
- **When incoming requests match** — custom filter expression:

  ```
  (http.host eq "inspect.sr") or (http.host eq "www.inspect.sr")
  ```

- **Then** — Type `Dynamic`, expression:

  ```
  concat("https://inspect-sr.com", http.request.uri.path)
  ```

- **Status code:** `301` (Permanent Redirect)
- **Preserve query string:** enabled

`http.request.uri.path` supplies the path alone; the *Preserve query string* checkbox re-attaches anything after `?`. Do **not** use `http.request.uri` with that checkbox enabled — `uri` already includes the query string, so the two together duplicate it.

Other Cloudflare settings:

- **SSL/TLS mode: Full (strict).** Largely moot, since the rule answers at the edge and Cloudflare never contacts an origin for this zone. But *Flexible* must never be selected: it fetches the origin over plain HTTP and, against an HTTPS-enforcing origin, produces an infinite redirect loop.
- **Always Use HTTPS: off.** The redirect rule already fires on plain HTTP and already targets an `https://` URL, so `http://inspect.sr/x` reaches `https://inspect-sr.com/x` in one hop. Enabling it would add a pointless intermediate redirect.
- **DNSSEC: off**, on both the domain and at Cloudflare. Turning it on is fine in principle but must never be left enabled while nameservers are being changed — a stale `DS` record at the registry makes the domain fail to resolve *everywhere*, in a way that looks identical to the domain having been deleted.

## GitHub Pages

Published from the **`gh-pages` branch** (root), which `quarto publish gh-pages` replaces wholesale on every publish. There is no GitHub Actions workflow; publishing happens manually from a local machine.

**The repo-root `CNAME` file is the source of truth for the custom domain.** It contains:

```
inspect-sr.com
```

It survives into the published output only because `_quarto.yml` lists it under `project: resources:`:

```yaml
project:
  type: book
  resources:
    - "CNAME"
```

Without that line, Quarto's wipe of `_book/` would drop it and GitHub Pages would lose the custom domain on the next publish.

Two consequences worth remembering:

1. Editing `CNAME` and republishing **is** how you change the custom domain. No GitHub settings change is needed.
2. If you change the domain in the GitHub UI but leave `CNAME` stale, **the next publish silently reverts it.**

GitHub Pages supports only **one** custom domain per repository. That is the whole reason the `inspect.sr` redirect has to live at Cloudflare rather than at GitHub.

`.nojekyll` is not in this repo; `quarto publish gh-pages` writes it into the branch automatically.

**Enforce HTTPS** is enabled in Settings → Pages. It can be greyed out for the first few minutes after a custom domain change, while GitHub provisions the certificate.

`site-url` in `_quarto.yml` must match the canonical domain — it generates `sitemap.xml`, `robots.txt`, and (with `open-graph: true`) the canonical and social-preview metadata:

```yaml
book:
  site-url: "https://inspect-sr.com/"
```

## Things that must not lapse

Everything else here is recoverable. These are not.

- **Domain registrations.** Both must stay renewed. `inspect.sr` expires **2027-03-25**. A lapsed rare ccTLD gets picked up quickly, and no amount of redirect configuration survives losing the registration — the URL in the published paper would be dead permanently. Confirm auto-renew is on and the payment card is current at both INWX and Namecheap.
- **The Cloudflare account.** If the zone is deleted, `inspect.sr` stops resolving. Rebuilding it means re-adding the zone, re-pointing nameservers at INWX, and waiting out `.sr` propagation again.

Certificates renew themselves — GitHub's Let's Encrypt cert and Cloudflare's Universal SSL both auto-renew with no action required.

## Verifying it all works

```bash
# canonical domain serves
curl -sI https://inspect-sr.com | head -1                       # HTTP/2 200

# www redirects to apex
curl -sI https://www.inspect-sr.com | grep -i location          # https://inspect-sr.com/

# old domain redirects, preserving path AND query string
curl -sI "https://inspect.sr/chapters/check_4_8.html?utm=test" | grep -iE "^HTTP|^location"
# HTTP/2 301
# location: https://inspect-sr.com/chapters/check_4_8.html?utm=test

# plain HTTP also redirects, in a single hop
curl -sI http://inspect.sr/ | grep -iE "^HTTP|^location"        # 301 -> https://inspect-sr.com/

# end to end
curl -sIL https://inspect.sr/ | grep -iE "^HTTP|^server"        # 301 cloudflare, then 200 GitHub.com

# certificates
echo | openssl s_client -connect inspect.sr:443 -servername inspect.sr 2>/dev/null \
  | openssl x509 -noout -subject -issuer -dates
# subject CN=inspect.sr, issuer Google Trust Services  (this is Cloudflare's Universal SSL)

echo | openssl s_client -connect inspect-sr.com:443 -servername inspect-sr.com 2>/dev/null \
  | openssl x509 -noout -subject -issuer -dates
# subject CN=inspect-sr.com, issuer Let's Encrypt  (GitHub's)

# who is authoritative for inspect.sr, read straight from the .sr registry
# (bypasses all caching — useful when a delegation change is in flight)
dig NS inspect.sr @ns1.nic.sr +noall +authority +norecurse
```

## Troubleshooting

**`quarto publish gh-pages` fails with `invalid peer certificate: NotValidForName`.**
The push succeeded. After pushing, Quarto polls `https://<site-url>/.nojekyll` to confirm the deploy; if GitHub has not yet issued the certificate for a newly-set custom domain, that check fails while the deploy itself is fine. Confirm with `git log origin/gh-pages` and a `curl -sI https://inspect-sr.com`. Do not re-run the publish.

**GitHub Pages says "domain's DNS record could not be retrieved".**
Usually a transient check failure. Verify DNS independently with `dig +short A inspect-sr.com` — if the four GitHub IPs come back, the DNS is fine and the check can simply be re-run.

**A DNS change doesn't seem to have taken effect.**
Query the authoritative server directly to bypass caching:

```bash
dig +short A inspect-sr.com @dns1.registrar-servers.com   # Namecheap
dig +short A inspect.sr @brett.ns.cloudflare.com          # Cloudflare
```

If the authoritative answer is correct, the change is live and any stale result is a cached copy elsewhere expiring. Note that the wait is governed by the **old** record's TTL, not the new one.

**A Cloudflare rule warns "this rule may not apply to your traffic".**
The hostname's DNS record is not proxied. Turn the cloud orange in DNS → Records. Do not accept Cloudflare's offer to create a new proxied record — the existing records only need proxying.

**`inspect.sr` returns 404 instead of redirecting.**
The DNS records have reverted to DNS-only (grey), so traffic is bypassing Cloudflare and hitting GitHub, which no longer recognises that hostname. Set all five records back to Proxied.

## Security notes

The architecture above is public information — `whois`, `dig NS`, and `dig A` reveal the registrar, DNS provider, and host to anyone who asks. Documenting it here leaks nothing new.

Deliberately **not** recorded in this file, and never to be added: account or customer numbers, login emails, service/support PINs, API tokens, Cloudflare account or zone IDs, and recovery contacts.

The realistic threat is targeted phishing — knowing which providers are in use makes a convincing forged "your domain is expiring" email easier to write. Accordingly:

- Two-factor authentication on the INWX, Namecheap, Cloudflare, and GitHub accounts.
- Registrar transfer lock enabled on both domains (INWX: gear menu → Transfer Lock).
- Treat renewal and account-security emails as suspect. Log in by typing the registrar's address directly rather than following links.

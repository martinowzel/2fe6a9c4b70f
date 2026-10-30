# 11 — Risks and Legal Considerations

> This document is not legal advice. Its purpose is to make the technical, account, and legal risks of jailbreaking explicit so you can make an informed decision.

---

## 1. Technical risks

| Risk | Description | Mitigation |
|---|---|---|
| **Data loss** | Save/data corruption due to an incompatible AIO fix or a crash | Back up saves; use 1.2+/HENloader; minimize plugins |
| **Instability/crashes** | Most jailbreaks live in memory and are not 100% stable | Restart after a failure; use tested builds |
| **Console brick** | Low but real risk, especially when modifying `system_ex`/firmware | Avoid BD-JB-EX and system-partition modification |
| **Unwanted update** | Loss of the exploit | Disable auto-updates; block network updates |
| **Malicious payload** | A payload has full access to the system | Use official sources; verify hashes; antivirus |
| **Hardware issues** | Bad burn/disc → unreadable disc | Valid BD-R/BD-RE; low speed; Verify |

---

## 2. Account/online risks

- **PSN ban:** Sony may restrict a console or account if it detects modification/cheating. Online use with your main account is not recommended on a jailbroken console.
- **Online cheating:** using cheat plugins in online games violates service terms and harms other players. This project does not cover it.
- **Remote Play/network:** do not expose payload ports to the internet.
- **Accounts/personal data:** no legitimate tool should ask for your PSN password or personal information.

---

## 3. Legal risks

### 3.1 Jailbreaking a personally owned console

The legality of jailbreaking and software modification varies by country/region. In some jurisdictions it is acceptable for personal/research use; in others it is restricted. It may also violate **Sony's Terms of Service**, even where it is legal. Check local law and the ToS before acting.

### 3.2 Copyright and DRM

This project covers homebrew and jailbreaking a personally owned console. The following are out of scope and may be illegal:

- downloading/distributing pirated games;
- using keys/firmware/protected files without authorization;
- DRM circumvention for sale or sharing;
- selling a console with illegal content.

### 3.3 Warranty

Jailbreaking usually **voids the console warranty**. Consider this if your console still has active warranty coverage.

---

## 4. Payload and source risks

- **Unknown forks:** may contain malicious code. Prefer the original/author repository.
- **Pre-burned discs:** the content cannot be inspected; only use a trusted seller.
- **"One-click jailbreak" offers on Telegram/Discord:** often scams or malware.
- **Shortened links/password-protected files:** do not open or run them.
- **Requests for personal information:** no legitimate tool needs your password/account.

---

## 5. 13.x and BD-JB-EX risks

- **BD-JB-EX** requires writing to `system_ex`, a protected system partition; modifying it can lead to a brick or a required firmware reinstall.
- PSDevWiki warns that after corruption/reinstall, the injection is erased and the console may need a firmware reinstall.
- Kernel exploits for 13.02–13.04 are less documented/tested; they may cause instability or data loss.
- If your console is on 13.50+, **do not treat disc BD-JB as the main route**; check the current WebKit/Relapse status from up-to-date sources.

---

## 6. Decision checklist

Before starting, ask yourself:

- [ ] Is this my own console, and is it out of warranty?
- [ ] Am I aware of the PSN ban risk?
- [ ] Do I have backups of important saves?
- [ ] Is my firmware in a supported range?
- [ ] Is the ISO/payload source official and trusted?
- [ ] Can I prevent firmware updates?
- [ ] Am I aware of local laws and the ToS?
- [ ] Is my goal homebrew/research, not piracy/cheating?

If any answer is "no", gather more information before proceeding.

---

## 7. This project's position

- This project is **educational/research documentation**.
- It does not distribute exploit binaries, firmware, keys, or copyrighted content.
- It does not teach DRM circumvention for piracy or online cheating.
- Each user is responsible for their own actions.

---

## 8. Sources

- ConsoleMods — PS4:BD-JB and FAQ (warranty/use): <https://consolemods.org/wiki/PS4:BD-JB>
- PSDevWiki — BD-JB-EX (system-partition warning): <https://www.psdevwiki.com/ps4/Vulnerabilities>
- PSN/Sony Terms of Service: refer to the official PlayStation website.

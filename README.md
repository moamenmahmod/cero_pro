#  Recursive Cero Automation Script

Automate deep recursive subdomain enumeration using [cero](https://github.com/glebarez/cero) with logging, target folders, and colored terminal output.

![demo](https://img.shields.io/badge/bash-automation-green) ![demo](https://img.shields.io/badge/recursive-subdomain--finder-blue)

---

## 📜 Features

- ✅ Fully recursive enumeration (depth customizable)
- ✅ Saves results per **target** in structured folders
- ✅ **Color-coded** terminal output (green = found, yellow = scanning, red = warning)
- ✅ Logs every scan with timestamp (`log_YYYYMMDD_HHMMSS.txt`)
- ✅ Deduplicates automatically
- ✅ Clean and ready for bug bounty recon workflows

---

## 🚀 Usage

```bash
./recursive_cero.sh -t TARGET_NAME [-d DEPTH]
```

### ✅ Example 1 (default depth 10):
```bash
./recursive_cero.sh -t google
```

### ✅ Example 2 (custom depth 15):
```bash
./recursive_cero.sh -t facebook -d 15
```

---

## 📂 Output Directory Structure

Results are saved inside your home directory under:
```
~/bugbounty/targets/TARGET_NAME/subdomains/cero/
```

### Example:
```
~/bugbounty/targets/google/subdomains/cero/
├── all_domains.txt       # All unique subdomains found
├── log_20250502_142233.txt  # Full scan log with timestamps
```

---

## 🔄 How it works

- The script starts with your target (e.g., `google.com`).
- Runs `cero` and grabs new subdomains.
- Recursively runs `cero` again on every **new** subdomain found.
- Saves everything cleanly in your bug bounty folder structure.

---

## ⚙️ Requirements

- ✅ [cero](https://github.com/glebarez/cero) installed and in your `$PATH`
- ✅ `bash` (tested on Linux and macOS)
- ✅ `sed`, `sort`, `comm`, `mktemp` (standard UNIX tools)

---

## 📫 Author

- Twitter: [@moaammeeen](https://twitter.com/yourhandle)

---

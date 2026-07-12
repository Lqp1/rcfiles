#!/usr/bin/env python3
import argparse
import json
import os
import re
import urllib.request
import urllib.error
import hashlib

# ANSI colors for nice terminal output
COLOR_GREEN = "\033[92m"
COLOR_YELLOW = "\033[93m"
COLOR_RED = "\033[91m"
COLOR_CYAN = "\033[96m"
COLOR_BOLD = "\033[1m"
COLOR_RESET = "\033[0m"

DEFINITIONS = [
    {
        "name": "zsh-autoenv",
        "file": "roles/common/defaults/main.yml",
        "repo": "Tarrasch/zsh-autoenv",
        "fetch_type": "commit",
        "branch": "master",
        "extract": r"common_zsh_autoenv_version:\s*([a-f0-9]{40})",
        "replace": lambda line, old, new: line.replace(f"common_zsh_autoenv_version: {old}", f"common_zsh_autoenv_version: {new}"),
        "format_tag": lambda t, cur: t
    },
    {
        "name": "ohmyzsh",
        "file": "roles/common/defaults/main.yml",
        "repo": "ohmyzsh/ohmyzsh",
        "fetch_type": "commit",
        "branch": "master",
        "extract": r"common_ohmyzsh_version:\s*([a-f0-9]{40})",
        "replace": lambda line, old, new: line.replace(f"common_ohmyzsh_version: {old}", f"common_ohmyzsh_version: {new}"),
        "format_tag": lambda t, cur: t
    },
    {
        "name": "zsh-autosuggestions",
        "file": "roles/common/defaults/main.yml",
        "repo": "zsh-users/zsh-autosuggestions",
        "fetch_type": "commit",
        "branch": "master",
        "extract": r"common_zsh_autosuggestions_version:\s*([a-f0-9]{40})",
        "replace": lambda line, old, new: line.replace(f"common_zsh_autosuggestions_version: {old}", f"common_zsh_autosuggestions_version: {new}"),
        "format_tag": lambda t, cur: t
    },
    {
        "name": "zsh-syntax-highlighting",
        "file": "roles/common/defaults/main.yml",
        "repo": "zsh-users/zsh-syntax-highlighting",
        "fetch_type": "commit",
        "branch": "master",
        "extract": r"common_zsh_syntax_highlighting_version:\s*([a-f0-9]{40})",
        "replace": lambda line, old, new: line.replace(f"common_zsh_syntax_highlighting_version: {old}", f"common_zsh_syntax_highlighting_version: {new}"),
        "format_tag": lambda t, cur: t
    },
    {
        "name": "eza",
        "file": "roles/common/defaults/main.yml",
        "repo": "eza-community/eza",
        "extract": r"common_eza_version:\s*([v\d\.]+)",
        "replace": lambda line, old, new: f"common_eza_version: {new}",
        "format_tag": lambda t, cur: t.lstrip("v") if not cur.startswith("v") else t
    },
    {
        "name": "noto-emoji",
        "file": "roles/common_ui/defaults/main.yml",
        "repo": "googlefonts/noto-emoji",
        "extract": r"emoji:\s*([v\d\.]+)",
        "replace": lambda line, old, new: line.replace(f"emoji: {old}", f"emoji: {new}"),
        "format_tag": lambda t, cur: t if cur.startswith("v") else t.lstrip("v"),
        "hash_url": lambda new_ver: f"https://github.com/googlefonts/noto-emoji/raw/{new_ver}/fonts/NotoColorEmoji.ttf",
        "hash_extract": r"emoji:\s*([a-f0-9]{64})",
        "hash_replace": lambda line, old, new: line.replace(f"emoji: {old}", f"emoji: {new}"),
    },
    {
        "name": "nerd-fonts",
        "file": "roles/common_ui/defaults/main.yml",
        "repo": "ryanoasis/nerd-fonts",
        "extract": r"nerdfonts:\s*([v\d\.]+)",
        "replace": lambda line, old, new: line.replace(f"nerdfonts: {old}", f"nerdfonts: {new}"),
        "format_tag": lambda t, cur: t if cur.startswith("v") else t.lstrip("v"),
        "hash_url": lambda new_ver: f"https://github.com/ryanoasis/nerd-fonts/raw/{new_ver}/patched-fonts/FiraCode/Regular/FiraCodeNerdFontMono-Regular.ttf",
        "hash_extract": r"nerdfonts:\s*([a-f0-9]{64})",
        "hash_replace": lambda line, old, new: line.replace(f"nerdfonts: {old}", f"nerdfonts: {new}"),
    },
    {
        "name": "FiraCode",
        "file": "roles/common_ui/defaults/main.yml",
        "repo": "tonsky/FiraCode",
        "extract": r'fira:\s*["\']?([v\d\.]+)["\']?',
        "replace": lambda line, old, new: line.replace(f"fira: \"{old}\"", f"fira: \"{new}\"").replace(f"fira: '{old}'", f"fira: '{new}'").replace(f"fira: {old}", f"fira: {new}"),
        "format_tag": lambda t, cur: t.lstrip("v") if not cur.startswith("v") else t,
        "hash_url": lambda new_ver: f"https://github.com/tonsky/FiraCode/releases/download/{new_ver}/Fira_Code_v{new_ver}.zip",
        "hash_extract": r"fira:\s*([a-f0-9]{64})",
        "hash_replace": lambda line, old, new: line.replace(f"fira: {old}", f"fira: {new}"),
    },
    {
        "name": "latin-greek-cyrillic (noto)",
        "file": "roles/common_ui/defaults/main.yml",
        "repo": "notofonts/latin-greek-cyrillic",
        "extract": r"noto:\s*([v\d\.]+)",
        "replace": lambda line, old, new: line.replace(f"noto: {old}", f"noto: {new}"),
        "tag_prefix": "NotoSansMono-",
        "format_tag": lambda t, cur: t.replace("NotoSansMono-", ""),
        "hash_url": lambda new_ver: f"https://github.com/notofonts/latin-greek-cyrillic/releases/download/NotoSansMono-{new_ver}/NotoSansMono-{new_ver}.zip",
        "hash_extract": r"noto:\s*([a-f0-9]{64})",
        "hash_replace": lambda line, old, new: line.replace(f"noto: {old}", f"noto: {new}"),
    },
    {
        "name": "cliclick",
        "file": "roles/common/tasks/main.yml",
        "repo": "BlueM/cliclick",
        "extract": r"https://github\.com/BlueM/cliclick/releases/download/([^/]+)/cliclick\.zip",
        "replace": lambda line, old, new: line.replace(f"download/{old}", f"download/{new}"),
        "format_tag": lambda t, cur: t.lstrip("v") if not cur.startswith("v") else t,
        "hash_url": lambda new_ver: f"https://github.com/BlueM/cliclick/releases/download/{new_ver}/cliclick.zip",
        "hash_extract": r"checksum:\s*\"sha256:([a-f0-9]{64})\"",
        "hash_replace": lambda line, old, new: line.replace(f"sha256:{old}", f"sha256:{new}"),
    }
]

def fetch_latest_version(repo, tag_prefix=None, fetch_type="release", branch="master"):
    headers = {"User-Agent": "Mozilla/5.0"}
    token = os.environ.get("GITHUB_TOKEN")
    if token:
        headers["Authorization"] = f"token {token}"

    if fetch_type == "commit":
        url = f"https://api.github.com/repos/{repo}/commits/{branch}"
    elif tag_prefix:
        url = f"https://api.github.com/repos/{repo}/releases?per_page=50"
    else:
        url = f"https://api.github.com/repos/{repo}/releases/latest"

    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode())
            if fetch_type == "commit":
                return data.get("sha")
            elif tag_prefix:
                for release in data:
                    tag = release.get("tag_name", "")
                    if tag.startswith(tag_prefix):
                        return tag
                # Fallback to checking tags if not found in first page of releases
                return None
            else:
                return data.get("tag_name")
    except urllib.error.HTTPError as e:
        if e.code == 403 and "rate limit exceeded" in str(e.read()):
            raise RuntimeError("GitHub API rate limit exceeded. Set GITHUB_TOKEN environment variable.")
        raise RuntimeError(f"HTTP Error {e.code}: {e.reason}")
    except Exception as e:
        raise RuntimeError(f"Network error: {e}")

def fetch_hash(url):
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    try:
        with urllib.request.urlopen(req) as response:
            hasher = hashlib.sha256()
            while chunk := response.read(8192):
                hasher.update(chunk)
            return hasher.hexdigest()
    except Exception as e:
        raise RuntimeError(f"Hash fetch error: {e}")

def main():
    parser = argparse.ArgumentParser(description="Detect and bump hardcoded versions in the repository.")
    parser.add_argument("--write", action="store_true", help="Write changes to files in place.")
    args = parser.parse_args()

    repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    
    results = []
    any_outdated = False

    print(f"{COLOR_BOLD}Scanning repository for hardcoded versions...{COLOR_RESET}\n")

    for df in DEFINITIONS:
        file_path = os.path.join(repo_root, df["file"])
        if not os.path.exists(file_path):
            print(f"{COLOR_RED}File not found: {df['file']}{COLOR_RESET}")
            continue

        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()

        match = re.search(df["extract"], content)
        if not match:
            print(f"{COLOR_RED}Could not extract version for '{df['name']}' in {df['file']}{COLOR_RESET}")
            continue

        current_ver = match.group(1)
        
        current_hash = None
        if "hash_extract" in df:
            h_match = re.search(df["hash_extract"], content)
            if h_match:
                current_hash = h_match.group(1)
            else:
                print(f"{COLOR_RED}Could not extract hash for '{df['name']}' in {df['file']}{COLOR_RESET}")
                continue

        print(f"Checking {COLOR_CYAN}{df['name']}{COLOR_RESET} (current: {current_ver})...", end="", flush=True)

        try:
            latest_tag = fetch_latest_version(df["repo"], df.get("tag_prefix"), df.get("fetch_type", "release"), df.get("branch", "master"))
            if not latest_tag:
                print(f" {COLOR_RED}Failed (no matching tag/commit found on GitHub){COLOR_RESET}")
                continue

            latest_ver = df["format_tag"](latest_tag, current_ver)
            is_outdated = current_ver != latest_ver
            latest_hash = None

            if is_outdated:
                any_outdated = True
                print(f" {COLOR_YELLOW}Outdated! Latest is {latest_ver}{COLOR_RESET}", end="", flush=True)
                if "hash_url" in df:
                    print(f" {COLOR_CYAN}(Fetching hash...){COLOR_RESET}", end="", flush=True)
                    latest_hash = fetch_hash(df["hash_url"](latest_ver))
                print()
            else:
                print(f" {COLOR_GREEN}Up-to-date ({latest_ver}){COLOR_RESET}")

            results.append({
                "def": df,
                "file_path": file_path,
                "current": current_ver,
                "latest": latest_ver,
                "is_outdated": is_outdated,
                "current_hash": current_hash,
                "latest_hash": latest_hash
            })

        except Exception as e:
            print(f" {COLOR_RED}Error: {e}{COLOR_RESET}")

    # Output table summary
    print(f"\n{COLOR_BOLD}Summary Table:{COLOR_RESET}")
    print(f"{'-'*90}")
    print(f"{'Package/Asset':<28} | {'File':<35} | {'Current':<10} | {'Latest':<10}")
    print(f"{'-'*90}")
    for res in results:
        df = res["def"]
        color = COLOR_YELLOW if res["is_outdated"] else COLOR_GREEN
        print(f"{df['name']:<28} | {df['file']:<35} | {res['current']:<10} | {color}{res['latest']:<10}{COLOR_RESET}")
    print(f"{'-'*90}\n")

    if args.write:
        if not any_outdated:
            print(f"{COLOR_GREEN}All packages are already up-to-date. No changes written.{COLOR_RESET}")
            return

        print(f"{COLOR_BOLD}Writing updates to files...{COLOR_RESET}")
        for res in results:
            if not res["is_outdated"]:
                continue

            df = res["def"]
            with open(res["file_path"], "r", encoding="utf-8") as f:
                content = f.read()

            # Split into lines to replace precisely to keep comments intact
            lines = content.splitlines()
            pattern = re.compile(df["extract"])
            hash_pattern = re.compile(df["hash_extract"]) if "hash_extract" in df else None
            
            new_lines = []
            updated = False
            hash_updated = False
            
            for line in lines:
                if pattern.search(line):
                    new_line = df["replace"](line, res["current"], res["latest"])
                    new_lines.append(new_line)
                    updated = True
                elif hash_pattern and hash_pattern.search(line) and res["latest_hash"] and res["current_hash"]:
                    new_line = df["hash_replace"](line, res["current_hash"], res["latest_hash"])
                    new_lines.append(new_line)
                    hash_updated = True
                else:
                    new_lines.append(line)

            if updated:
                new_content = "\n".join(new_lines) + ("\n" if content.endswith("\n") else "")
                with open(res["file_path"], "w", encoding="utf-8") as f:
                    f.write(new_content)
                print(f"Updated {COLOR_GREEN}{df['name']}{COLOR_RESET} in {df['file']}: {res['current']} -> {res['latest']}")
                if "hash_extract" in df:
                    if hash_updated:
                        print(f"  └─ Updated hash for {COLOR_GREEN}{df['name']}{COLOR_RESET}: {res['latest_hash'][:8]}...")
                    else:
                        print(f"  └─ {COLOR_RED}Failed to write hash for {df['name']} (pattern mismatch){COLOR_RESET}")
            else:
                print(f"{COLOR_RED}Failed to write update for {df['name']} (pattern mismatch on write){COLOR_RESET}")

    else:
        if any_outdated:
            print(f"Run this script with {COLOR_BOLD}--write{COLOR_RESET} to automatically bump the versions in place.")
        else:
            print(f"{COLOR_GREEN}All versions are up-to-date!{COLOR_RESET}")

if __name__ == "__main__":
    main()

#!/usr/bin/env python3
import argparse
import json
import os
import re
import urllib.request
import urllib.error

# ANSI colors for nice terminal output
COLOR_GREEN = "\033[92m"
COLOR_YELLOW = "\033[93m"
COLOR_RED = "\033[91m"
COLOR_CYAN = "\033[96m"
COLOR_BOLD = "\033[1m"
COLOR_RESET = "\033[0m"

DEFINITIONS = [
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
        "format_tag": lambda t, cur: t if cur.startswith("v") else t.lstrip("v")
    },
    {
        "name": "nerd-fonts",
        "file": "roles/common_ui/defaults/main.yml",
        "repo": "ryanoasis/nerd-fonts",
        "extract": r"nerdfonts:\s*([v\d\.]+)",
        "replace": lambda line, old, new: line.replace(f"nerdfonts: {old}", f"nerdfonts: {new}"),
        "format_tag": lambda t, cur: t if cur.startswith("v") else t.lstrip("v")
    },
    {
        "name": "FiraCode",
        "file": "roles/common_ui/defaults/main.yml",
        "repo": "tonsky/FiraCode",
        "extract": r'fira:\s*["\']?([v\d\.]+)["\']?',
        "replace": lambda line, old, new: line.replace(f"fira: \"{old}\"", f"fira: \"{new}\"").replace(f"fira: '{old}'", f"fira: '{new}'").replace(f"fira: {old}", f"fira: {new}"),
        "format_tag": lambda t, cur: t.lstrip("v") if not cur.startswith("v") else t
    },
    {
        "name": "latin-greek-cyrillic (noto)",
        "file": "roles/common_ui/defaults/main.yml",
        "repo": "notofonts/latin-greek-cyrillic",
        "extract": r"noto:\s*([v\d\.]+)",
        "replace": lambda line, old, new: line.replace(f"noto: {old}", f"noto: {new}"),
        "tag_prefix": "NotoSansMono-",
        "format_tag": lambda t, cur: t.replace("NotoSansMono-", "")
    },
    {
        "name": "cliclick",
        "file": "roles/common/tasks/main.yml",
        "repo": "BlueM/cliclick",
        "extract": r"https://github\.com/BlueM/cliclick/releases/download/([^/]+)/cliclick\.zip",
        "replace": lambda line, old, new: line.replace(f"download/{old}", f"download/{new}"),
        "format_tag": lambda t, cur: t.lstrip("v") if not cur.startswith("v") else t
    },
    {
        "name": "git-delta",
        "file": "roles/debian/tasks/main.yml",
        "repo": "dandavison/delta",
        "extract": r"https://github\.com/dandavison/delta/releases/download/([^/]+)/git-delta_.*\.deb",
        "replace": lambda line, old, new: line.replace(f"download/{old}", f"download/{new}").replace(f"git-delta_{old}", f"git-delta_{new}"),
        "format_tag": lambda t, cur: t.lstrip("v") if not cur.startswith("v") else t
    },
    {
        "name": "vgrep",
        "file": "roles/debian_user/tasks/main.yml",
        "repo": "vrothberg/vgrep",
        "extract": r"https://github\.com/vrothberg/vgrep/releases/download/([^/]+)/vgrep_.*",
        "replace": lambda line, old, new: line.replace(f"download/{old}", f"download/{new}").replace(f"vgrep_{old.lstrip('v')}", f"vgrep_{new.lstrip('v')}"),
        "format_tag": lambda t, cur: t if cur.startswith("v") else t.lstrip("v")
    }
]

def fetch_latest_version(repo, tag_prefix=None):
    headers = {"User-Agent": "Mozilla/5.0"}
    token = os.environ.get("GITHUB_TOKEN")
    if token:
        headers["Authorization"] = f"token {token}"

    if tag_prefix:
        url = f"https://api.github.com/repos/{repo}/releases?per_page=50"
    else:
        url = f"https://api.github.com/repos/{repo}/releases/latest"

    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode())
            if tag_prefix:
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

def main():
    parser = argparse.ArgumentParser(description="Detect and bump hardcoded versions in the repository.")
    parser.add_argument("--write", action="store_true", help="Write changes to files in place.")
    args = parser.parse_args()

    repo_root = os.path.dirname(os.path.abspath(__file__))
    
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

        print(f"Checking {COLOR_CYAN}{df['name']}{COLOR_RESET} (current: {current_ver})...", end="", flush=True)

        try:
            latest_tag = fetch_latest_version(df["repo"], df.get("tag_prefix"))
            if not latest_tag:
                print(f" {COLOR_RED}Failed (no matching tag found on GitHub){COLOR_RESET}")
                continue

            latest_ver = df["format_tag"](latest_tag, current_ver)
            is_outdated = current_ver != latest_ver

            if is_outdated:
                any_outdated = True
                print(f" {COLOR_YELLOW}Outdated! Latest is {latest_ver}{COLOR_RESET}")
            else:
                print(f" {COLOR_GREEN}Up-to-date ({latest_ver}){COLOR_RESET}")

            results.append({
                "def": df,
                "file_path": file_path,
                "current": current_ver,
                "latest": latest_ver,
                "is_outdated": is_outdated
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
            new_lines = []
            updated = False
            for line in lines:
                if pattern.search(line):
                    new_line = df["replace"](line, res["current"], res["latest"])
                    new_lines.append(new_line)
                    updated = True
                else:
                    new_lines.append(line)

            if updated:
                new_content = "\n".join(new_lines) + ("\n" if content.endswith("\n") else "")
                with open(res["file_path"], "w", encoding="utf-8") as f:
                    f.write(new_content)
                print(f"Updated {COLOR_GREEN}{df['name']}{COLOR_RESET} in {df['file']}: {res['current']} -> {res['latest']}")
            else:
                print(f"{COLOR_RED}Failed to write update for {df['name']} (pattern mismatch on write){COLOR_RESET}")

    else:
        if any_outdated:
            print(f"Run this script with {COLOR_BOLD}--write{COLOR_RESET} to automatically bump the versions in place.")
        else:
            print(f"{COLOR_GREEN}All versions are up-to-date!{COLOR_RESET}")

if __name__ == "__main__":
    main()

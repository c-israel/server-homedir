#!/usr/bin/env python3
import argparse
import difflib
import os
import sys

def get_color_diff(diff):
    """Adds color to the diff output."""
    for line in diff:
        if line.startswith('+'):
            sys.stdout.write('\033[92m' + line + '\033[0m')  # Green for additions
        elif line.startswith('-'):
            sys.stdout.write('\033[91m' + line + '\033[0m')  # Red for deletions
        elif line.startswith('@@'):
            sys.stdout.write('\033[96m' + line + '\033[0m')  # Cyan for context
        else:
            sys.stdout.write(line)

def main():
    """Main function to parse arguments and process files."""
    parser = argparse.ArgumentParser(
        description='Update tool versions across multiple files.',
        formatter_class=argparse.RawTextHelpFormatter
    )
    parser.add_argument('tool', help='The name of the tool to update (e.g., "lsd").')
    parser.add_argument('old_version', help='The old version string (e.g., "v1.1.5").')
    parser.add_argument('new_version', help='The new version string (e.g., "v1.2.0").')
    parser.add_argument('action', choices=['preview', 'change'], help="Either 'preview' or 'change'.")
    args = parser.parse_args()

    files_to_process = [
        'fetch_tools/urls-env-arm64.sh',
        'fetch_tools/urls-env-amd64.sh',
        'fetch_tools/fetch_licenses.sh',
        'README.md'
    ]

    for filename in files_to_process:
        if not os.path.exists(filename):
            print(f"Warning: File '{filename}' not found. Skipping.", file=sys.stderr)
            continue

        try:
            with open(filename, 'r', encoding='utf-8') as f:
                original_lines = f.readlines()
        except IOError as e:
            print(f"Error reading file {filename}: {e}", file=sys.stderr)
            continue

        modified_lines = []
        has_changed = False
        for line in original_lines:
            # Case-insensitive check for the tool name
            if args.tool.lower() in line.lower():
                new_line = line.replace(args.old_version, args.new_version)
                if new_line != line:
                    has_changed = True
                modified_lines.append(new_line)
            else:
                modified_lines.append(line)

        if has_changed:
            print(f"--- Changes for {filename} ---")
            diff = difflib.unified_diff(
                original_lines,
                modified_lines,
                fromfile=f'a/{filename}',
                tofile=f'b/{filename}'
            )
            get_color_diff(diff)

            if args.action == 'change':
                try:
                    with open(filename, 'w', encoding='utf-8') as f:
                        f.writelines(modified_lines)
                    print(f"\nApplied changes to {filename}\n")
                except IOError as e:
                    print(f"Error writing to file {filename}: {e}", file=sys.stderr)
        else:
            print(f"--- No changes for {filename} ---")

if __name__ == '__main__':
    main()

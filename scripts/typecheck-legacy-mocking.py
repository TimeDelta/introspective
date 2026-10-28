#!/usr/bin/env python3
"""Check the actual legacy mocking library against the selected iOS SDK early."""
import platform
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]


def main():
    sources = sorted((ROOT / "Pods/SwiftyMocky/Sources/SwiftyMocky").rglob("*.swift"))
    if not sources:
        raise FileNotFoundError("Run pod install --deployment before checking SwiftyMocky")
    sdk = subprocess.check_output(["xcrun", "--sdk", "iphonesimulator", "--show-sdk-path"], text=True).strip()
    developer_platform = subprocess.check_output(
        ["xcrun", "--sdk", "iphonesimulator", "--show-sdk-platform-path"], text=True).strip()
    architecture = platform.machine()
    if architecture not in ("arm64", "x86_64"):
        raise RuntimeError(f"Unsupported simulator architecture: {architecture}")
    subprocess.run([
        "xcrun", "--sdk", "iphonesimulator", "swiftc", "-typecheck", "-swift-version", "5",
        "-module-name", "SwiftyMocky", "-sdk", sdk,
        "-target", f"{architecture}-apple-ios12.0-simulator",
        "-F", str(Path(developer_platform) / "Developer/Library/Frameworks"),
        "-I", str(Path(developer_platform) / "Developer/usr/lib"),
        *map(str, sources),
    ], cwd=ROOT, check=True)


if __name__ == "__main__":
    main()

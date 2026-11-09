#!/usr/bin/env python3
"""Download and safely extract an arXiv source archive."""

from __future__ import annotations

import argparse
import gzip
import json
import os
import re
import shutil
import sys
import tarfile
import tempfile
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path, PurePosixPath


ARXIV_ID = re.compile(
    r"^(?:\d{4}\.\d{4,5}|[a-z][a-z0-9.-]*/\d{7})(?:v\d+)?$", re.IGNORECASE
)
MAX_DOWNLOAD = 100 * 1024 * 1024
MAX_EXTRACTED = 500 * 1024 * 1024


def normalize_arxiv_id(value: str) -> str:
    candidate = value.strip()
    if candidate.lower().startswith("arxiv:"):
        candidate = candidate[6:].strip()
    if "://" in candidate:
        parsed = urllib.parse.urlparse(candidate)
        host = (parsed.hostname or "").lower()
        if host not in {"arxiv.org", "www.arxiv.org", "export.arxiv.org"}:
            raise ValueError(f"not an arXiv host: {host or '(missing host)'}")
        path = urllib.parse.unquote(parsed.path).strip("/")
        for prefix in ("abs/", "pdf/", "src/", "e-print/"):
            if path.startswith(prefix):
                path = path[len(prefix) :]
                break
        candidate = path.removesuffix(".pdf")
    candidate = candidate.strip("/")
    if not ARXIV_ID.fullmatch(candidate):
        raise ValueError(f"invalid arXiv identifier: {candidate!r}")
    return candidate


def cache_root() -> Path:
    base = os.environ.get("XDG_CACHE_HOME")
    return Path(base).expanduser() / "study-ml-paper" if base else Path.home() / ".cache" / "study-ml-paper"


def download(url: str, destination: Path, max_bytes: int) -> None:
    request = urllib.request.Request(url, headers={"User-Agent": "study-ml-paper/1.0"})
    with urllib.request.urlopen(request, timeout=60) as response, destination.open("wb") as output:
        declared = response.headers.get("Content-Length")
        if declared and int(declared) > max_bytes:
            raise ValueError(f"download is larger than {max_bytes} bytes")
        total = 0
        while chunk := response.read(1024 * 1024):
            total += len(chunk)
            if total > max_bytes:
                raise ValueError(f"download exceeded {max_bytes} bytes")
            output.write(chunk)


def safe_member_path(root: Path, name: str) -> Path:
    pure = PurePosixPath(name)
    if pure.is_absolute() or ".." in pure.parts:
        raise ValueError(f"unsafe archive path: {name!r}")
    target = (root / Path(*pure.parts)).resolve()
    try:
        target.relative_to(root.resolve())
    except ValueError as error:
        raise ValueError(f"archive path escapes destination: {name!r}") from error
    return target


def extract_tar(archive_path: Path, destination: Path, max_bytes: int) -> None:
    total = 0
    with tarfile.open(archive_path, mode="r:*") as archive:
        for member in archive:
            target = safe_member_path(destination, member.name)
            if member.issym() or member.islnk() or member.isdev() or member.isfifo():
                raise ValueError(f"unsupported archive member: {member.name!r}")
            if member.isdir():
                target.mkdir(parents=True, exist_ok=True)
                continue
            if not member.isfile():
                continue
            total += member.size
            if total > max_bytes:
                raise ValueError(f"extracted content exceeded {max_bytes} bytes")
            target.parent.mkdir(parents=True, exist_ok=True)
            source = archive.extractfile(member)
            if source is None:
                raise ValueError(f"could not read archive member: {member.name!r}")
            with source, target.open("wb") as output:
                shutil.copyfileobj(source, output, length=1024 * 1024)


def extract_source(archive_path: Path, destination: Path) -> None:
    try:
        extract_tar(archive_path, destination, MAX_EXTRACTED)
        return
    except tarfile.ReadError:
        pass

    # Some older submissions are a single gzip-compressed TeX file rather than a tarball.
    try:
        with gzip.open(archive_path, "rb") as source, (destination / "main.tex").open("wb") as output:
            total = 0
            while chunk := source.read(1024 * 1024):
                total += len(chunk)
                if total > MAX_EXTRACTED:
                    raise ValueError(f"extracted content exceeded {MAX_EXTRACTED} bytes")
                output.write(chunk)
    except (gzip.BadGzipFile, EOFError) as error:
        raise ValueError("arXiv response was neither a tar archive nor gzip-compressed TeX") from error


def find_entrypoints(source_dir: Path) -> list[str]:
    scored: list[tuple[int, int, str]] = []
    for path in source_dir.rglob("*.tex"):
        try:
            sample = path.read_text(encoding="utf-8", errors="replace")[:200_000]
        except OSError:
            continue
        score = 0
        if "\\documentclass" in sample:
            score += 100
        if "\\begin{document}" in sample:
            score += 30
        if path.stem.lower() in {"main", "paper", "article", "manuscript"}:
            score += 15
        depth = len(path.relative_to(source_dir).parts)
        scored.append((-score, depth, str(path.relative_to(source_dir))))
    scored.sort()
    return [item[2] for item in scored[:10]]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("paper", help="arXiv URL or identifier")
    parser.add_argument("--cache-dir", type=Path, default=cache_root(), help="source cache directory")
    parser.add_argument("--force", action="store_true", help="replace this paper's existing cache")
    parser.add_argument("--json", action="store_true", help="print machine-readable output")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        paper_id = normalize_arxiv_id(args.paper)
        cache_dir = args.cache_dir.expanduser().resolve()
        slug = paper_id.replace("/", "--")
        paper_dir = cache_dir / slug
        source_dir = paper_dir / "source"
        archive_path = paper_dir / "source.tar"

        if source_dir.is_dir() and not args.force:
            status = "cached"
        else:
            cache_dir.mkdir(parents=True, exist_ok=True)
            temporary = Path(tempfile.mkdtemp(prefix=f".{slug}-", dir=cache_dir))
            try:
                temporary_archive = temporary / "source.tar"
                temporary_source = temporary / "source"
                temporary_source.mkdir()
                quoted_id = urllib.parse.quote(paper_id, safe="/.")
                download(f"https://arxiv.org/src/{quoted_id}", temporary_archive, MAX_DOWNLOAD)
                extract_source(temporary_archive, temporary_source)
                if paper_dir.exists():
                    shutil.rmtree(paper_dir)
                temporary.rename(paper_dir)
                status = "downloaded"
            except Exception:
                shutil.rmtree(temporary, ignore_errors=True)
                raise

        result = {
            "arxiv_id": paper_id,
            "status": status,
            "source_dir": str(source_dir),
            "archive": str(archive_path),
            "entrypoint_candidates": find_entrypoints(source_dir),
        }
        if args.json:
            print(json.dumps(result, indent=2))
        else:
            print(f"arXiv: {paper_id}")
            print(f"Status: {status}")
            print(f"Source: {source_dir}")
            print("Entrypoint candidates:")
            for candidate in result["entrypoint_candidates"]:
                print(f"  - {candidate}")
        return 0
    except (ValueError, OSError, urllib.error.URLError) as error:
        print(f"error: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())

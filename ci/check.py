"""CI check for the Git hands-on repo.

Usage: python ci/check.py queries/<your-name>.sql [...]

For every query it:
  1. looks for leftover conflict markers,
  2. lints the SQL with sqlfluff (settings in .sqlfluff),
  3. runs it on the sample data in data/ and compares the result
     with ci/expected/<your-name>.csv.
"""

from __future__ import annotations

import csv
import datetime as dt
import decimal
import sys
from pathlib import Path

import duckdb

MARKERS = ("<<<<<<<", "=======", ">>>>>>>")


def find_conflict_markers(sql: str) -> list[int]:
    return [
        i
        for i, line in enumerate(sql.splitlines(), start=1)
        if line.startswith(MARKERS)
    ]


def _connect(data_dir: Path) -> duckdb.DuckDBPyConnection:
    con = duckdb.connect()
    for f in sorted(Path(data_dir).glob("*.csv")):
        con.execute(
            f'CREATE TABLE "{f.stem}" AS SELECT * FROM read_csv_auto(?, header = true)',
            [str(f)],
        )
    return con


def run_query(sql: str, data_dir: Path) -> tuple[list[str], list[tuple]]:
    con = _connect(data_dir)
    cur = con.execute(sql.strip().rstrip(";"))
    cols = [d[0] for d in cur.description]
    return cols, cur.fetchall()


def read_expected(path: Path) -> tuple[list[str], list[tuple]]:
    cur = duckdb.connect().execute(
        "SELECT * FROM read_csv_auto(?, header = true)", [str(path)]
    )
    return [d[0] for d in cur.description], cur.fetchall()


def _norm(v):
    if isinstance(v, bool) or v is None or isinstance(v, str):
        return v
    if isinstance(v, (int, float, decimal.Decimal)):
        return round(float(v), 2) + 0.0
    if isinstance(v, (dt.date, dt.datetime)):
        return v.isoformat()
    return str(v)


def _table(result: tuple[list[str], list[tuple]], order: list[str]) -> list[tuple]:
    cols = [c.lower() for c in result[0]]
    idx = [cols.index(c) for c in order]
    rows = [tuple(_norm(r[i]) for i in idx) for r in result[1]]
    return sorted(rows, key=lambda r: tuple((x is None, str(x)) for x in r))


def compare(actual, expected) -> list[str]:
    a_cols = [c.lower() for c in actual[0]]
    e_cols = [c.lower() for c in expected[0]]
    msgs = []
    missing = [c for c in e_cols if c not in a_cols]
    extra = [c for c in a_cols if c not in e_cols]
    if missing:
        msgs.append(f"missing column(s): {', '.join(missing)}")
    if extra:
        msgs.append(f"unexpected column(s): {', '.join(extra)}")
    if len(actual[1]) != len(expected[1]):
        msgs.append(f"expected {len(expected[1])} rows, got {len(actual[1])}")
    if msgs:
        return msgs
    a, e = _table(actual, e_cols), _table(expected, e_cols)
    if a == e:
        return []
    msgs.append("the result is different from the expected one")
    msgs.append(f"columns: {', '.join(e_cols)}")
    shown = 0
    for got, want in zip(a, e):
        if got != want and shown < 3:
            msgs.append(f"  expected {want}")
            msgs.append(f"  got      {got}")
            shown += 1
    return msgs


def write_expected(sql: str, data_dir: Path, path: Path) -> None:
    cols, rows = run_query(sql, data_dir)
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f, lineterminator="\n")
        w.writerow(cols)
        w.writerows(_table((cols, rows), [c.lower() for c in cols]))


def lint(sql: str, root: Path) -> list[str]:
    import sqlfluff

    cfg = root / ".sqlfluff"
    found = sqlfluff.lint(sql, config_path=str(cfg) if cfg.exists() else None)
    return [
        f"line {v['start_line_no']}: {v['code']} {v['description']}" for v in found
    ]


def check_file(path: Path, root: Path) -> bool:
    print(f"\n== {path}")
    sql = path.read_text(encoding="utf-8-sig")

    markers = find_conflict_markers(sql)
    if markers:
        lines = ", ".join(f"line {n}" for n in markers)
        print(f"FAIL  conflict markers are still in the file ({lines}).")
        print("      Remove the <<<<<<< ======= >>>>>>> lines and keep the right code.")
        return False

    ok = True
    problems = lint(sql, root)
    if problems:
        ok = False
        print("FAIL  SQL style/syntax (sqlfluff):")
        for p in problems:
            print(f"      {p}")
        if any(" PRS " in f" {p.split(': ', 1)[1]} " for p in problems):
            print("      Fix the syntax first, then the result will be checked.")
            return False
    else:
        print("OK    SQL style/syntax")

    expected_path = root / "ci" / "expected" / f"{path.stem}.csv"
    if not expected_path.exists():
        print(f"FAIL  no expected result for this file ({expected_path.name}).")
        return False
    try:
        actual = run_query(sql, root / "data")
    except duckdb.Error as e:
        print(f"FAIL  the query does not run: {str(e).splitlines()[0]}")
        return False
    diff = compare(actual, read_expected(expected_path))
    if diff:
        print("FAIL  result:")
        for m in diff:
            print(f"      {m}")
        return False
    print("OK    result matches the expected one")
    return ok


def main(argv: list[str]) -> int:
    root = Path.cwd()
    files = [Path(a) for a in argv if a.strip()]
    if not files:
        print("no queries changed, nothing to check")
        return 0
    results = [check_file(f, root) for f in files]
    print()
    if all(results):
        print("All checks passed.")
        return 0
    print("Some checks failed. Read the messages above, fix, commit and push again.")
    return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

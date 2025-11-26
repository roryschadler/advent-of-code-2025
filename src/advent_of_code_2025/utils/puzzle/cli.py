import logging
from pathlib import Path

import click
from mdformat import text

from advent_of_code_2025.utils.puzzle._utils import (
    day_argument,
    puzzle_argument,
    year_argument,
)
from advent_of_code_2025.utils.puzzle.get import get_input, get_soup, get_title
from advent_of_code_2025.utils.puzzle.parser import parse_file, parse_soup
from advent_of_code_2025.utils.puzzle.write import write

SESSION_FILE = Path(__file__).parent / "session.txt"

session = ""


@click.group
@click.option("-v", "--verbose", count=True, type=int)
def aoc(verbose: int):
    global session

    logging.basicConfig(level=(max(logging.WARNING - min(verbose, 2) * 10, 10)))

    if not SESSION_FILE.exists():
        raise RuntimeError("No session.txt file found")

    with SESSION_FILE.open("r") as fr:
        session = fr.read().strip()


@aoc.command
@day_argument
@year_argument
@puzzle_argument
def get(day: int, year: int, puzzle: int):
    global session

    soup = get_soup(year, day, session)
    title = get_title(soup)
    parsed_soup = parse_soup(soup, puzzle)
    puzzle_text = text("\n".join(parsed_soup))
    input_text = get_input(year, day, session)

    write(puzzle_text, input_text, title, day, puzzle)


@aoc.command
@click.argument(
    "file_path", type=click.Path(exists=True, dir_okay=False, path_type=Path)
)
@puzzle_argument
def parse_html(file_path: Path, puzzle: int, verbose: int):
    if not (file_path.exists() and file_path.is_file()):
        raise FileNotFoundError(f"File {file_path} does not exist")

    if not file_path.suffix == ".html":
        raise ValueError(f"File {file_path} is not an HTML file")

    print(parse_file(file_path, puzzle))

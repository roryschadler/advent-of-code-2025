import logging
from pathlib import Path

PACKAGE_ROOT = Path(__file__).parent.parent.parent

PUZZLE_TEXT_FILENAME = "README.md"
PUZZLE_INPUT_FILENAME = "input.txt"

logger = logging.getLogger(__name__)


def write_puzzle(day_directory: Path, text: str, puzzle_number: int):
    path = day_directory / PUZZLE_TEXT_FILENAME
    if path.is_dir():
        raise RuntimeError(f"{path} exists and is a directory")

    if puzzle_number == 1:
        if path.exists():
            logger.warning(f"{path} exists, overwriting")

        with path.open("w") as fw:
            fw.write(text)
    elif puzzle_number == 2:
        if not path.exists():
            raise RuntimeError(
                f"Attempting to write puzzle {puzzle_number}, but {path} does not exist. Get puzzle 1 first."
            )

        with path.open("a") as fw:
            fw.write(text)
    else:
        raise RuntimeError(f"Invalid puzzle number {puzzle_number}")


def write_input(day_directory: Path, text: str):
    path = day_directory / PUZZLE_INPUT_FILENAME

    if path.is_dir():
        raise RuntimeError(f"{path} exists and is a directory")

    if path.exists():
        logger.warning(f"{path} exists, overwriting")

    with path.open("w") as fw:
        fw.write(text)


def write(puzzle_text: str, input_text: str, title: str, day: int, puzzle_number: int):
    day_directory = PACKAGE_ROOT / f"day_{day:02d}_{'_'.join(title.lower().split(' '))}"

    if not day_directory.exists():
        day_directory.mkdir(parents=True)
    elif not day_directory.is_dir():
        raise RuntimeError(f"{day_directory} exists but is not a directory")

    write_puzzle(day_directory, puzzle_text, puzzle_number)

    write_input(day_directory, input_text)

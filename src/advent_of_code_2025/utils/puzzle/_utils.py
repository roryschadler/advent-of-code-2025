from datetime import datetime
from zoneinfo import ZoneInfo

import click

AOC_TZ = ZoneInfo("America/New_York")
AOC_NOW = datetime.now(AOC_TZ)

CURRENT_AOC_YEAR = AOC_NOW.year if AOC_NOW.month == 12 else AOC_NOW.year - 1
FIRST_AOC_YEAR = 2015

PUZZLE_CHOICES = [1, 2]


def validate_day(ctx: click.Context, param: click.Parameter, value: int) -> int:
    if value < 1:
        raise ValueError("The day must be at least 1")
    elif value > 25:
        raise ValueError("The day must be less than 25")
    return value


def validate_year(ctx: click.Context, param: click.Parameter, value: int) -> int:
    if value > CURRENT_AOC_YEAR:
        raise ValueError(
            f"The most recent puzzles are from {CURRENT_AOC_YEAR}, pick a new year"
        )
    elif value < FIRST_AOC_YEAR:
        raise ValueError(
            f"The first puzzles are from {FIRST_AOC_YEAR}, pick a new year"
        )
    return value


def validate_puzzle(ctx: click.Context, param: click.Parameter, value: int) -> int:
    if value not in PUZZLE_CHOICES:
        raise ValueError(f"The puzzle number must be one of {PUZZLE_CHOICES}")
    return value


day_argument = click.argument(
    "day",
    default=min(AOC_NOW.day, 25) if AOC_NOW.month == 12 else 1,
    type=int,
    callback=validate_day,
)
year_argument = click.argument(
    "year", default=CURRENT_AOC_YEAR, type=int, callback=validate_year
)
puzzle_argument = click.argument(
    "puzzle", default=1, type=int, callback=validate_puzzle
)

from re import compile

from bs4 import BeautifulSoup
from httpx import Client

URL = "https://adventofcode.com/{year}/day/{day}"
http_client = Client(headers={"User-Agent": "github.com/roryschadler"})

TITLE_REGEX = compile(r"--- Day \d+: (?P<title_text>[\w -]+) ---")


def get_soup(year: int, day: int, session: str) -> BeautifulSoup:
    if not session:
        cookies = {}
    else:
        cookies = {"session": session}

    resp = http_client.get(URL.format(year=year, day=day), cookies=cookies)

    return BeautifulSoup(resp.read(), features="html.parser")


def get_title(soup: BeautifulSoup):
    heading = soup.h2
    if heading is None:
        raise RuntimeError("Title heading not found")

    title_match = TITLE_REGEX.fullmatch(heading.text.strip())

    if title_match is None:
        raise RuntimeError("Title does not match regex")

    title_text = title_match.group("title_text")

    if not title_text:
        raise ValueError("Title text is empty")

    return title_text


def get_input(year: int, day: int, session: str):
    if not session:
        cookies = {}
    else:
        cookies = {"session": session}

    resp = http_client.get(URL.format(year=year, day=day) + "/input", cookies=cookies)

    return resp.read().decode("utf-8")

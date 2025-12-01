import logging
from pathlib import Path
from re import sub
from textwrap import wrap

from bs4 import BeautifulSoup, ResultSet, Tag
from bs4.element import PageElement

logger = logging.getLogger(__name__)


def read_file(file_path):
    logger.info(f"Reading file {file_path}")
    with open(file_path, "r") as file:
        contents = file.read()
    return BeautifulSoup(contents, features="html.parser")


def parse_children(children: list[PageElement]):
    parsed_children = []
    for child in children:
        if isinstance(child, Tag):
            logger.debug("Parsing %s, containing %s", child.name, child.text)
            parsed_children.extend(parser_map[child.name](child))
        else:
            logger.debug("Parsing %s", child)
            parsed_children.append(child)
    return parsed_children


def parse_h2(header: Tag):
    if header.attrs.get("id") == "part2":
        return ["", f"## {header.text.strip('- ')}", ""]
    else:
        return [f"# {header.text.strip('- ')}", "", "## Part One", ""]


def parse_a(a: Tag):
    if (href := str(a.attrs["href"])).startswith("#") or href.startswith("/"):
        logger.debug("Parsing internal link %s", href)
        href = "https://adventofcode.com" + href
    return [f"[{a.text}]({href})"]


def parse_em(em: Tag):
    if em.attrs.get("class") == ["star"]:
        return [em.text]
    else:
        return [f"_{em.text}_"]


def parse_code(code: Tag):
    return [
        f"_`{child.text}`_"
        if isinstance(child, Tag) and child.name == "em"
        else f"`{child.text}`"
        for child in code.contents
    ]


def parse_pre(pre: Tag):
    # ignore the internal code tag
    stripped_text = pre.text.strip("\n")
    return [f"```text\n{stripped_text}\n```", ""]


def parse_li(li: Tag):
    li_children = parse_children(li.contents)
    return wrap("- " + "".join(li_children), width=80, subsequent_indent="  ")


def parse_ul(ul: Tag):
    return parse_children(ul.contents) + [""]


def parse_p(p: Tag):
    parsed_children = parse_children(p.contents)
    return wrap(
        sub(r"\*", "\\*", sub(r"\s{2,}", " ", "".join(parsed_children))), width=80
    ) + [""]


def parse_span(s: Tag):
    return s.text


parser_map = {
    "h2": parse_h2,
    "em": parse_em,
    "code": parse_code,
    "pre": parse_pre,
    "a": parse_a,
    "p": parse_p,
    "ul": parse_ul,
    "li": parse_li,
    "span": parse_span,
}


def parse_soup(soup: BeautifulSoup, puzzle_number: int):
    puzzle_articles: ResultSet[Tag] = soup.find_all("article", {"class": "day-desc"})
    if len(puzzle_articles) < puzzle_number:
        raise ValueError(
            f"Puzzle article {puzzle_number} not found. Are you sure you "
            "got the right page?"
        )
    puzzle_article = puzzle_articles[puzzle_number - 1]
    parsed_puzzle_article = parse_children(puzzle_article.contents)

    literal_newlines_removed = list(
        filter(lambda item: item != "\n", parsed_puzzle_article)
    )
    if literal_newlines_removed[-1] == "":
        literal_newlines_removed = literal_newlines_removed[:-1]

    stripped_items = map(lambda s: s.strip(), literal_newlines_removed)

    return stripped_items


def parse_file(file_path: Path, puzzle_number: int):
    soup = read_file(file_path)

    parsed_puzzle_article = parse_soup(soup, puzzle_number)

    return "\n".join(parsed_puzzle_article)

default:
  just --list

@get PUZZLE DAY=datetime('%d') YEAR='2025':
  uv run aoc get {{DAY}} {{YEAR}} {{PUZZLE}}

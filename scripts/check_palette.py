#!/usr/bin/env python3
"""Validate Lumiere's palette and deterministic visual snapshot."""

from __future__ import annotations

import argparse
import json
import math
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
PALETTE_PATH = ROOT / "palette.json"
SNAPSHOT_PATH = ROOT / "tests" / "snapshots" / "palette.svg"

ACCENTS = ("red", "orange", "yellow", "green", "cyan", "blue", "magenta")
ANSI_NAMES = (
    "ansi_black",
    "ansi_red",
    "ansi_green",
    "ansi_yellow",
    "ansi_blue",
    "ansi_magenta",
    "ansi_cyan",
    "ansi_white",
    "ansi_bright_black",
    "ansi_bright_red",
    "ansi_bright_green",
    "ansi_bright_yellow",
    "ansi_bright_blue",
    "ansi_bright_magenta",
    "ansi_bright_cyan",
    "ansi_bright_white",
)
SEMANTIC_NAMES = (
    "none",
    "black",
    "white",
    "background",
    "background_inactive",
    "background_error",
    "surface",
    "surface_subtle",
    "surface_raised",
    "surface_selected",
    "surface_overlay",
    "text",
    "text_strong",
    "text_secondary",
    "text_muted",
    "text_faint",
    "text_invisible",
    "text_on_accent",
    "punctuation",
    "border",
    "border_strong",
    "red",
    "red_bg",
    "orange",
    "orange_bg",
    "yellow",
    "yellow_bg",
    "green",
    "green_bg",
    "cyan",
    "cyan_bg",
    "blue",
    "blue_bg",
    "magenta",
    "magenta_bg",
    "search_bg",
)
EXPECTED_NAMES = frozenset((*SEMANTIC_NAMES, *ANSI_NAMES))
HEX = re.compile(r"^#[0-9a-f]{6}$")
LEGACY_NAMES = frozenset(
    {
        "bg",
        "bg_nc",
        "bg_error",
        "fg",
        "strong_fg",
        "on_yellow",
        "comment",
        "secondary_fg",
    }
)

CVD_MATRICES = {
    "protanopia": (
        (0.152286, 1.052583, -0.204868),
        (0.114503, 0.786281, 0.099216),
        (-0.003882, -0.048116, 1.051998),
    ),
    "deuteranopia": (
        (0.367322, 0.860646, -0.227968),
        (0.280085, 0.672501, 0.047413),
        (-0.011820, 0.042940, 0.968881),
    ),
    "tritanopia": (
        (1.255528, -0.076749, -0.178779),
        (-0.078411, 0.930809, 0.147602),
        (0.004733, 0.691367, 0.303900),
    ),
}


def srgb_to_linear(channel: float) -> float:
    if channel <= 0.04045:
        return channel / 12.92
    return ((channel + 0.055) / 1.055) ** 2.4


def linear_rgb(value: str) -> tuple[float, float, float]:
    return tuple(
        srgb_to_linear(int(value[index : index + 2], 16) / 255)
        for index in (1, 3, 5)
    )


def luminance(rgb: tuple[float, float, float]) -> float:
    return (0.2126 * rgb[0]) + (0.7152 * rgb[1]) + (0.0722 * rgb[2])


def contrast(first: str, second: str) -> float:
    first_luminance = luminance(linear_rgb(first))
    second_luminance = luminance(linear_rgb(second))
    lighter = max(first_luminance, second_luminance)
    darker = min(first_luminance, second_luminance)
    return (lighter + 0.05) / (darker + 0.05)


def oklab(rgb: tuple[float, float, float]) -> tuple[float, float, float]:
    red, green, blue = rgb
    lightness = (0.4122214708 * red) + (0.5363325363 * green) + (0.0514459929 * blue)
    medium = (0.2119034982 * red) + (0.6806995451 * green) + (0.1073969566 * blue)
    short = (0.0883024619 * red) + (0.2817188376 * green) + (0.6299787005 * blue)
    lightness = math.copysign(abs(lightness) ** (1 / 3), lightness)
    medium = math.copysign(abs(medium) ** (1 / 3), medium)
    short = math.copysign(abs(short) ** (1 / 3), short)
    return (
        (0.2104542553 * lightness) + (0.7936177850 * medium) - (0.0040720468 * short),
        (1.9779984951 * lightness) - (2.4285922050 * medium) + (0.4505937099 * short),
        (0.0259040371 * lightness) + (0.7827717662 * medium) - (0.8086757660 * short),
    )


def oklch(value: str) -> tuple[float, float, float]:
    lightness, a_axis, b_axis = oklab(linear_rgb(value))
    chroma = math.hypot(a_axis, b_axis)
    hue = math.degrees(math.atan2(b_axis, a_axis)) % 360
    return lightness, chroma, hue


def hue_distance(first: float, second: float) -> float:
    difference = abs(first - second) % 360
    return min(difference, 360 - difference)


def simulate_cvd(
    rgb: tuple[float, float, float], matrix: tuple[tuple[float, float, float], ...]
) -> tuple[float, float, float]:
    return tuple(
        max(0, min(1, sum(row[index] * rgb[index] for index in range(3))))
        for row in matrix
    )


def rgb_contrast(
    first: tuple[float, float, float], second: tuple[float, float, float]
) -> float:
    first_luminance = luminance(first)
    second_luminance = luminance(second)
    lighter = max(first_luminance, second_luminance)
    darker = min(first_luminance, second_luminance)
    return (lighter + 0.05) / (darker + 0.05)


def validate(palettes: dict[str, dict[str, str]]) -> list[str]:
    failures: list[str] = []

    def check(condition: bool, message: str) -> None:
        if not condition:
            failures.append(message)

    check(set(palettes) == {"light", "dark"}, "palette must contain exactly light and dark")
    if set(palettes) != {"light", "dark"}:
        return failures

    for mode, colors in palettes.items():
        names = set(colors)
        check(names == EXPECTED_NAMES, f"{mode}: schema differs from the quality contract")
        check(not any(name.startswith(("gray_", "ui_")) for name in names), f"{mode}: numbered roles returned")
        check(not names.intersection(LEGACY_NAMES), f"{mode}: legacy role names returned")
        for name, value in colors.items():
            if name == "none":
                check(value == "NONE", f"{mode}.{name}: expected NONE")
            else:
                check(bool(HEX.fullmatch(value)), f"{mode}.{name}: expected lowercase #rrggbb")

    if failures:
        return failures

    light_names = set(palettes["light"])
    dark_names = set(palettes["dark"])
    check(light_names == dark_names, "light and dark schemas differ")

    text_targets = {"light": (8.0, 10.0), "dark": (10.0, 12.0)}
    for mode, colors in palettes.items():
        background = colors["background"]

        def page_contrast(name: str) -> float:
            return contrast(colors[name], background)

        minimum, maximum = text_targets[mode]
        text_contrast = page_contrast("text")
        check(minimum <= text_contrast <= maximum, f"{mode}.text contrast {text_contrast:.2f} outside {minimum:.1f}-{maximum:.1f}")

        muted_contrast = page_contrast("text_muted")
        check(4.5 <= muted_contrast <= 5.5, f"{mode}.text_muted contrast {muted_contrast:.2f} outside 4.5-5.5")

        punctuation_contrast = page_contrast("punctuation")
        check(5.0 <= punctuation_contrast <= 7.5, f"{mode}.punctuation contrast {punctuation_contrast:.2f} outside 5.0-7.5")

        border_contrast = page_contrast("border")
        check(2.5 <= border_contrast <= 3.2, f"{mode}.border contrast {border_contrast:.2f} outside 2.5-3.2")

        inactive_contrast = page_contrast("background_inactive")
        check(1.08 <= inactive_contrast <= 1.20, f"{mode}.background_inactive contrast {inactive_contrast:.2f} outside 1.08-1.20")

        surface_ranges = {
            "surface": (1.02, 1.10),
            "surface_subtle": (1.15, 1.35),
            "surface_raised": (1.10, 1.35),
            "surface_selected": (1.30, 1.70),
            "surface_overlay": (1.15, 1.35),
        }
        for name, (lower, upper) in surface_ranges.items():
            value = page_contrast(name)
            check(lower <= value <= upper, f"{mode}.{name} contrast {value:.2f} outside {lower:.2f}-{upper:.2f}")

        accent_contrasts = [page_contrast(name) for name in ACCENTS]
        check(min(accent_contrasts) >= 4.5, f"{mode}: an accent falls below 4.5:1")
        check(max(accent_contrasts) - min(accent_contrasts) <= 1.0, f"{mode}: accent contrast spread exceeds 1.0")

        accent_lightness = [oklch(colors[name])[0] for name in ACCENTS]
        check(max(accent_lightness) - min(accent_lightness) <= 0.015, f"{mode}: accent OKLCH lightness spread exceeds 0.015")
        for name in ACCENTS:
            pair_contrast = contrast(colors[name], colors[f"{name}_bg"])
            check(pair_contrast >= 4.5, f"{mode}.{name}/{name}_bg contrast {pair_contrast:.2f} below 4.5")

        search_contrast = contrast(colors["text_on_accent"], colors["search_bg"])
        check(search_contrast >= 7.0, f"{mode}: search contrast {search_contrast:.2f} below 7.0")

        ansi_values = [colors[name] for name in ANSI_NAMES]
        check(len(set(ansi_values)) == 16, f"{mode}: ANSI slots are not distinct")
        for normal, bright in zip(ANSI_NAMES[1:7], ANSI_NAMES[9:15], strict=True):
            check(colors[normal] != colors[bright], f"{mode}: {normal} duplicates {bright}")
        for name in (*ANSI_NAMES[1:8], *ANSI_NAMES[9:16]):
            value = page_contrast(name)
            check(value >= 4.5, f"{mode}.{name} contrast {value:.2f} below 4.5")
        bright_black_contrast = page_contrast("ansi_bright_black")
        check(bright_black_contrast >= 3.0, f"{mode}.ansi_bright_black contrast {bright_black_contrast:.2f} below 3.0")

        background_rgb = linear_rgb(background)
        for vision, matrix in CVD_MATRICES.items():
            simulated_background = simulate_cvd(background_rgb, matrix)
            for name in ACCENTS:
                simulated_accent = simulate_cvd(linear_rgb(colors[name]), matrix)
                value = rgb_contrast(simulated_accent, simulated_background)
                check(value >= 4.5, f"{mode}.{name} contrast under {vision} is {value:.2f}")

    for name in ACCENTS:
        light_hue = oklch(palettes["light"][name])[2]
        dark_hue = oklch(palettes["dark"][name])[2]
        check(hue_distance(light_hue, dark_hue) <= 3.0, f"{name}: light/dark OKLCH hues diverge")

    for name in ("background", "surface", "text", "text_muted"):
        dark_red, dark_green, dark_blue = (
            int(palettes["dark"][name][index : index + 2], 16) for index in (1, 3, 5)
        )
        check(dark_red >= dark_green >= dark_blue, f"dark.{name}: expected a warm-neutral RGB ordering")

    return failures


def render_preview(palettes: dict[str, dict[str, str]]) -> str:
    width = 1200
    height = 780
    output = [
        '<?xml version="1.0" encoding="UTF-8"?>',
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
        '<rect width="1200" height="780" fill="#b9b4aa"/>',
    ]

    for panel_index, mode in enumerate(("light", "dark")):
        colors = palettes[mode]
        x = 20 + (panel_index * 590)
        output.append(
            f'<rect x="{x}" y="20" width="570" height="740" rx="18" fill="{colors["background"]}" stroke="{colors["border"]}" stroke-width="2"/>'
        )
        output.append(
            f'<text x="{x + 28}" y="62" fill="{colors["text_strong"]}" font-family="ui-monospace, monospace" font-size="25" font-weight="700">Lumiere {mode}</text>'
        )
        output.append(
            f'<text x="{x + 28}" y="88" fill="{colors["text_muted"]}" font-family="ui-monospace, monospace" font-size="14">warm restraint / semantic hierarchy</text>'
        )

        sample_x = x + 28
        output.append(
            f'<rect x="{sample_x}" y="112" width="514" height="198" rx="10" fill="{colors["surface"]}" stroke="{colors["border"]}"/>'
        )
        code_lines = (
            ("declaration", "class Palette:", colors["blue"], "700"),
            ("comment", "-- color supports meaning, never noise", colors["text_muted"], "400"),
            ("control", "if palette.ready:", colors["magenta"], "700"),
            ("string", "  name = 'lumiere'", colors["green"], "400"),
            ("type", "  variant: Theme", colors["cyan"], "400"),
            ("number", "  contrast = 8.9", colors["orange"], "400"),
        )
        for line_index, (_, label, color, weight) in enumerate(code_lines):
            y = 143 + (line_index * 27)
            output.append(
                f'<text x="{sample_x + 20}" y="{y}" fill="{color}" font-family="ui-monospace, monospace" font-size="15" font-weight="{weight}">{label}</text>'
            )
        output.append(
            f'<text x="{sample_x}" y="344" fill="{colors["text_secondary"]}" font-family="ui-monospace, monospace" font-size="13">ACCENTS + DIFF SURFACES</text>'
        )
        swatch_width = 68
        for accent_index, name in enumerate(ACCENTS):
            swatch_x = sample_x + (accent_index * 73)
            output.append(
                f'<rect x="{swatch_x}" y="360" width="{swatch_width}" height="64" rx="8" fill="{colors[name + "_bg"]}" stroke="{colors[name]}"/>'
            )
            output.append(
                f'<circle cx="{swatch_x + 34}" cy="382" r="9" fill="{colors[name]}"/>'
            )
            output.append(
                f'<text x="{swatch_x + 34}" y="411" text-anchor="middle" fill="{colors[name]}" font-family="ui-monospace, monospace" font-size="10">{name}</text>'
            )

        output.append(
            f'<text x="{sample_x}" y="460" fill="{colors["text_secondary"]}" font-family="ui-monospace, monospace" font-size="13">TEXT + SURFACE DEPTH</text>'
        )
        hierarchy = (
            ("strong", "text_strong"),
            ("body", "text"),
            ("secondary", "text_secondary"),
            ("comment", "text_muted"),
            ("faint", "text_faint"),
        )
        for hierarchy_index, (label, name) in enumerate(hierarchy):
            item_x = sample_x + ((hierarchy_index % 3) * 170)
            item_y = 488 + ((hierarchy_index // 3) * 34)
            output.append(
                f'<text x="{item_x}" y="{item_y}" fill="{colors[name]}" font-family="ui-monospace, monospace" font-size="14">{label}</text>'
            )
        surfaces = ("surface", "surface_subtle", "surface_raised", "surface_selected")
        for surface_index, name in enumerate(surfaces):
            surface_x = sample_x + (surface_index * 128)
            output.append(
                f'<rect x="{surface_x}" y="548" width="118" height="48" rx="6" fill="{colors[name]}" stroke="{colors["border"]}"/>'
            )
            output.append(
                f'<text x="{surface_x + 59}" y="577" text-anchor="middle" fill="{colors["text"]}" font-family="ui-monospace, monospace" font-size="9">{name.removeprefix("surface_")}</text>'
            )

        output.append(
            f'<text x="{sample_x}" y="632" fill="{colors["text_secondary"]}" font-family="ui-monospace, monospace" font-size="13">ANSI 0-15</text>'
        )
        for ansi_index, name in enumerate(ANSI_NAMES):
            ansi_x = sample_x + ((ansi_index % 8) * 64)
            ansi_y = 649 + ((ansi_index // 8) * 45)
            output.append(
                f'<rect x="{ansi_x}" y="{ansi_y}" width="56" height="28" rx="4" fill="{colors[name]}"/>'
            )
            output.append(
                f'<text x="{ansi_x + 28}" y="{ansi_y + 41}" text-anchor="middle" fill="{colors["text_faint"]}" font-family="ui-monospace, monospace" font-size="9">{ansi_index}</text>'
            )

    output.append("</svg>")
    return "\n".join(output) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--update-snapshot",
        action="store_true",
        help="rewrite the deterministic SVG snapshot after intentional review",
    )
    args = parser.parse_args()

    palettes = json.loads(PALETTE_PATH.read_text(encoding="utf-8"))
    failures = validate(palettes)
    if failures:
        for failure in failures:
            print(f"palette check: {failure}", file=sys.stderr)
        return 1

    preview = render_preview(palettes)
    if args.update_snapshot:
        SNAPSHOT_PATH.parent.mkdir(parents=True, exist_ok=True)
        SNAPSHOT_PATH.write_text(preview, encoding="utf-8")
        print(f"updated {SNAPSHOT_PATH.relative_to(ROOT)}")
    elif not SNAPSHOT_PATH.exists() or SNAPSHOT_PATH.read_text(encoding="utf-8") != preview:
        print(
            "palette check: visual snapshot is stale; inspect the palette, then run "
            "uv run scripts/check_palette.py --update-snapshot",
            file=sys.stderr,
        )
        return 1

    print("palette, contrast, OKLCH, CVD, ANSI, and visual snapshot checks passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

# Math-Adventure v2.7 — Level System Foundation

## Implemented
- Data-driven catalog with 42 levels in `data/levels.json`.
- 3 worlds × 14 levels each:
  - Tutorial: 1
  - Introduction: 3
  - Challenge: 4
  - Advanced: 4
  - Boss: 2
- Level selection overlay in the main menu with world tabs and grouped level cards.
- Only level 1 starts unlocked; each victory unlocks the next level.
- Stars are saved locally; replaying a level preserves the best star result.
- Victory result screen offers a Next Level button when another level exists.
- Level configuration controls world, class band, difficulty, wave enemy counts, and reward metadata.
- World 1 questions: addition/subtraction.
- World 2 questions: multiplication/division.
- World 3 questions: introductory fractions/percentages.
- Enemy HP scales by level and world; movement pace remains based on the existing slower PvZ-style tuning.

## Star rules
- 1 star: win the level.
- 2 stars: win with Core HP at least 60.
- 3 stars: win with Core HP at least 90 and answer at least one question with 75% or better accuracy.

## Save data
Local save path: `user://math_adventure_progress.cfg`.
The save stores highest unlocked level and best star count per level.

## Important scope notes
- This is the first foundation pass, not all 42 levels fully hand-designed.
- Boss levels currently use the available special enemy roster; a unique Zero King boss encounter remains future content.
- Class bands are an initial mapping (World 1: classes 1–2, World 2: classes 3–4, World 3: classes 5–6) and should be aligned with the target curriculum before educational release.
- Run the project in Godot 4.7.2 and inspect Debugger before exporting APK; code has not been runtime-tested in this environment.

## Manual test checklist
1. Launch the main menu; the level selector should show World 1 and 14 level cards grouped by tier.
2. Level 1 should be enabled; all later levels should be locked.
3. Complete Level 1; verify the result screen grants stars and shows Next Level.
4. Return to menu; Level 2 should be unlocked and saved after restart.
5. Check that each world generates its corresponding question operations.
6. Confirm wave segment count and wave progression change with the selected level.

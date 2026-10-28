# Math-Adventure v2.8 — Simple Level Selection and Tutorial

## Changes
- One global Tutorial level (ID 1), available from the level selector regardless of the selected map.
- Three maps with 13 numbered levels each: Addition Forest, Multiplication Desert, and Fraction Castle.
- 40 total levels: 1 global tutorial + 39 map levels.
- Level selection now shows only the map names, numbered square level buttons, one Tutorial button, and a close button. Tier names, class bands, descriptions, star labels, and completion counts are hidden from the selector.
- Level buttons use fixed square dimensions and adapt grid columns to the viewport width.
- The tutorial is a six-page introduction. The battle does not spawn enemies until the player finishes the tutorial.
- Progress migration maps the old 42-level save layout into the new 40-level layout, preserving best stars and the nearest equivalent unlocked level.

## Tutorial flow
1. Protect the Core.
2. Select a Guardian and understand its energy cost.
3. Place the Guardian on the grid.
4. Earn energy by answering math questions and using Plusy.
5. Watch all lanes because monsters can spawn in any row.
6. Start the first wave.

## Level layout
- Tutorial: ID 1, world ID 0, addition/subtraction questions.
- Addition Forest: IDs 2–14, local levels 1–13.
- Multiplication Desert: IDs 15–27, local levels 1–13.
- Fraction Castle: IDs 28–40, local levels 1–13.

## Test checklist
- [ ] Level selector has one Tutorial button only.
- [ ] Switching maps changes only the map name and its numbered grid.
- [ ] Numbered level buttons are square and show no extra text.
- [ ] Level 1 opens the tutorial pages and does not spawn enemies before the final button.
- [ ] Completing the tutorial unlocks map level 1 in Addition Forest (global level ID 2).
- [ ] Completing level 13 in a map unlocks the first level in the next map.
- [ ] Progress and stars survive restart, including migration from the old save.

## Validation note
The archive and JSON catalog can be checked statically. Run the project in Godot 4.7.2 and inspect the Debugger before exporting an APK; runtime testing was not available in this build environment.

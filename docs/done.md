# What we have done

# (26/09/2026)

Done — Dynamic Month & Calendar Logic
- Added real calendar dates to every contribution square.
- Grid now rolls automatically week-by-week using the current date.
- Current week only displays days that have actually occurred.
- Replaced hardcoded month names with dynamic month labels based on grid dates.
- Month labels attach to their first full week and move with the grid.
- Added incoming month logic:
  - New month label stays hidden until at least 2 columns are visible.
  - Prevents labels getting cramped against the right edge.
- Added outgoing month / left-edge clamping:
  - Oldest month label stays pinned to the left edge as its original position moves off-screen.
  - Label disappears once the following month's label gets too close.
- Tested calendar movement using temporary future dates, advancing week-by-week.
- Confirmed both left-edge clamping and incoming month behaviour work correctly.
- Restored Date() for normal live calendar behaviour.
- Kept temporary date-testing code commented out for future debugging.
Result: Month/date positioning logic is now working dynamically across the 24-week contribution grid. ✅

----------------------------------------
# (26/09/2026)

- Added left edge month identifier helper.

---------------------------------------
# (25/09/2026)

- Added widget labelling logiic

--------------------------------------
# (24/09/2026)

- Added dynamic month labels attached to the first full week of the month

----------------------------------------

# (22/09/2026)

- Added dates to all squares dynamically

---------------------------------------
# (17/09/2026)

- Added baseline hardcoded color shades

--------------------------------------------
# (16/09/2026)

- Added month labels and made spacing better

-----------------------------------------
# (16/09/2026)

- Made grid and grid color

------------------------------------------
# (15/09/2026)

- Made first hardcoded yearly contributions tracker and moved it to the top of the widget.

----------------------------------------------------
# (15/09/2026)

- Set up project and git hub repository.
# Grandfather Paradox — game concept

> A working notebook for the game's premise, story, and design. Ideas marked
> **Open** are intentionally undecided; this is not a fixed specification.

## One-sentence pitch

You travel through time to prevent humanity's disasters, but every successful
intervention makes the world worse in a new way. The player can keep pushing
forward—or recognize the pattern and undo the interventions.

## Core time-travel rule

The game's defining rule is that information can travel to the past, but matter
cannot. The player can transfer/overwrite a person's consciousness, but cannot
send a physical object—such as a watch—to 1920.

If the player creates a spacetime paradox, the timeline snaps back to its last
stable moment. For example, if one run passes through a door opened by a
particular person, then a later run kills that person before they can open the
door, the contradiction triggers a rollback. A grandfather-paradox example:
travelling to the past and killing one's grandfather would return the timeline
to the moment before the time travel.

One concrete, deterministic rollback rule: killing someone the player
previously overwrote as a host always sends time back to the moment of that
takeover. It does not depend on whether the player can infer a separate
contradiction. This lets the player effectively undo mistakes by retrying from
the point where they entered that person, and keeps the rule easy to follow.

Other paradoxes should also trigger a rewind in principle, but the story
should minimize or avoid them where possible. One proposed way to do that is
to allow downstream events to happen for a different reason: for example, if
the player kills a guard who would later kill another host, that host might
instead die by suicide. This could preserve the later outcome without forcing
an annoying rewind.

This automatic rollback is the proposed way to handle contradictory actions
across runs, rather than letting an impossible timeline persist. The exact
rules for what counts as "stable" are still open. The in-game character is not
aware of the rollback; the design focus is the experience and understanding of
the person playing, not the character's memory.

**Open:** Ideally, the player discovers the rollback rule naturally through
gameplay. A mission could make a first example more likely, but the teaching
moment is not designed yet.

## Creative direction

- **Themes:** time travel, unintended consequences, human destructiveness,
  responsibility, and whether intervention is always better than inaction.
- **Tone:** darkish overall. Early on, the missions should feel worthwhile or
  even classically heroic; the darker conclusion should emerge gradually.
- **Inspirations:** *Travelers*, *Steins;Gate*, *Inception*, and *Undertale*.
  These are references for direction, not a commitment to copy their stories
  or mechanics.
- **Platform:** PC first.
- **Prototype technology:** Godot or Pygame; undecided.
- **Structure:** seven defined missions; the player cannot leave a mission to
  explore the wider world.

## Player experience

The player initially believes they are saving people and protecting humanity.
As missions accumulate, the consequences of those interventions make the world
worse. The player should have a chance to notice the pattern and choose to
reverse course rather than simply complete every objective.

Prefer teaching timeline rules through what happens during play rather than
over-explaining them with dialogue or exposition.

The intended recurring pattern is that an intervention makes the targeted
disaster disappear, but the changed world later produces a different, more
destructive disaster—roughly ten years afterward is one current estimate.
Without the earlier disaster, humanity avoids one horror but fails to learn or
change in a way that prevents another.

The intended "correct" choice may be to stop playing/proceeding. There is also
an in-game alternative: undo earlier timeline fixes. Undoing the opening
intervention (tentatively, an attempt to kill Hitler) is envisioned as a
"goodish" ending.

The player can voluntarily resign and revert earlier interventions at any point
in the campaign. Resigning is the route to the "goodish" ending.

The opening mission has two intended outcomes:

- **Success:** the player carries out the intervention and changes the
  timeline. The exact success conditions and immediate consequences are open.
- **Resignation:** the player abandons the intervention and chooses not to
  change the timeline. This leads to the "goodish" ending; the same option to
  resign remains available after later interventions.

**Open:** How can the game communicate that continuing is causing harm without
making the pattern obvious too early or making the player feel tricked?

## Core gameplay idea

### Mission play

- A twin-stick shooter is the current starting point; whether the second stick
  is needed is undecided.
- Missions are expected to be difficult to finish in one life.
- Each host has a strict, short time horizon measured in **game time**, not
  real time (around three minutes is one example). This makes solving a
  mission through a single host suboptimal or impossible.
- Taking over a host from an earlier point in time turns the mission clock
  back, giving the player another stretch of in-world time with a different
  host. The player may need to leave a host after completing a task, such as
  opening a door for another host to pass through.
- If the host's time runs out before the objective is completed, the target
  escapes and can no longer be killed in that attempt. The timeline remains
  unchanged and the mission fails, sending the player to the tactical screen.
- From there, the player can restart the mission by taking over the initial
  host again. Because this transfer is earlier, the butterfly effect cancels
  all later actions; a separate restart button is not needed.
- Dying—or deliberately ending the current life—takes the player to a tactical
  screen where they can manipulate time.

### Time manipulation and host selection

- A level begins with one host, though the reason the player can enter that
  first host is still to be invented.
- The player can transfer their consciousness into a person encountered during
  previous gameplay, in the spirit of *Travelers*.
- In the game's terminology, the person whose body is occupied is a **host**.
- Later transfers require a precise position for the target (currently
  described as a "TELL"). During gameplay, the player would need to encounter
  potential hosts to learn that position. Cameras might provide a way to find
  targets in later periods.
- A person encountered in an isolated place (a restroom is one example) can
  be a valid target; someone in a crowd is not a straightforward target. This
  is intended to stop the player from switching into anyone at will and making
  mission objectives trivial.
- The wider world has civilians, but the game stays within its seven defined
  missions; people encountered as potential hosts in those missions are armed.
- A transfer produces a conspicuous, unmistakably unnatural event. It might
  look like a blast or sound like a scream; it is visible/audible but not
  dangerous in itself, and its exact form is undecided. After the first
  mission, government agencies know that a sudden change in behavior may
  indicate a new host, and train people to kill that person immediately. This
  makes transfers in crowded, armed mission spaces dangerous and helps keep
  host-switching from trivializing objectives.
- The high-profile assassination attempt in the first mission is how this
  becomes known: the attacker appears to be an ordinary/random person whose
  behavior suddenly changes, drawing attention from authorities.
- A risky transfer might still be useful as a distraction.
- A transfer has a time/coordinate: taking over someone from before the most
  recent transfer undoes all later transfers. The butterfly effect is the
  in-world explanation for why those later transfers no longer fit.
- There is no total lifetime limit on consciousness transfers. At most four
  people can be overridden concurrently.
- Replaying or restarting a mission segment is therefore part of the intended
  gameplay loop, not merely a punishment.

### Tactical screen

- The screen should feel like a replay of the mission with a full-map view and
  fog of war.
- The player can inspect actions from previous runs and choose to override
  only a person they saw during a previous run.
- The player uses this view to plan what to do next and whom to override.
- Choosing an earlier takeover cancels later overrides and their actions. For
  example, taking over someone at minute 2 cancels an override at minute 2:30.

**Open:** What technical rule limits how far back in time the player can
transfer?

## Opening mission framing

- The player should regard the opening intervention as morally dubious, but
  probably justified: killing Hitler during the war seems to offer a way to
  prevent the horrors of World War II and its estimated 70 million deaths.
- The chosen date is 1939, during the war, rather than killing Hitler as a
  child. The intention is to avoid making the opening choice cruel in that way.
- A technical limit on how far back the player can travel could help justify
  the chosen date; the rule is undecided.
- The mission's short host time horizon could force the player to leave one
  host after doing something useful, such as opening a route for another host.
- A difficult one-host solution should be possible, but most players should
  be encouraged to use multiple hosts. The opening mission should introduce
  host transfers and the butterfly-effect rule that taking over at an earlier
  point cancels later transfers.
- The opening intervention counts as a success if the player either kills
  Hitler or transfers into/overwrites him and then causes that host to die by
  suicide. The detailed steps for either route are still open.

### Successful intervention: current alternate-history outline

If the opening assassination succeeds:

- World War II as the player knows it never happens. Instead, a shorter war
  ends with the partition of Poland.
- A new German government seeks peace with the Western powers and agrees to
  disarm after regaining its former possessions.
- Another great power becomes aggressive, leading to a new world war about ten
  years later.
- This later war is even more destructive because both sides use primitive
  nuclear weapons.

This is a rough story outline; the political sequence and the link from one
change to the next still need development.

**Open:** What should the player understand about the consequences of the
opening intervention before deciding whether to make it?

## Story and mission seeds

The player's initial goal is to prevent World War II, regarded by the
characters as the twentieth century's greatest catastrophe. After each
intervention, the next newly emerged disaster is introduced in the next
mission's description/briefing. The chain of briefings shows that there is
always another catastrophe to prevent.

The main story is still a rough sketch. These are candidate historical or
history-inspired crises; the final order is not yet confirmed:

1. **Hitler assassination — 8 November 1939, Munich.** An opening intervention
   based on a failed assassination attempt. The player currently imagines
   trying to kill Hitler or otherwise change the event.
2. **Presidential assassination.** JFK is a motive/reference point, but timeline
   changes would make the event similar rather than identical.
3. **Cuban nuclear crisis.**
4. **Chernobyl nuclear disaster.**
5. **Massive terrorist attack.**
6. **Global pandemic.**
7. **AI singularity.**

**Open:** What links these events, and how does each intervention directly
create or worsen the next state of the world?

## Ending shape

- Completing the seventh mission leads to the bad ending. It is the only
  forced endpoint; the player can resign and revert earlier interventions at
  any point before then.
- The apparently heroic route should initially feel like progress.
- Discovering and undoing earlier fixes offers a better, but still possibly
  bittersweet, ending.
- Choosing to resign rather than continue changing the timeline leads to the
  "goodish" ending. This is thematically important and may be the true
  "correct" choice.

**Open:** What does "not playing" mean in practice—refusing a mission, closing
the game, or an explicit in-game choice that carries the same meaning?

## Design questions to resolve over time

- What is the player's role, identity, and reason for making the first
  intervention?
- What is the smallest fun, testable version of the shooter and transfer loop?
- What rules govern transfer range, host selection, and the transfer limit?
- What other actions, if any, trigger an automatic paradox rollback?
- How will the player see the world worsening between missions?
- Which consequences are caused by the player's actions, and which expose
  existing human behavior?
- How should real tragedies be represented respectfully while keeping the
  alternate-history story clear?
- Which engine best supports the intended prototype and the developer's
  workflow?


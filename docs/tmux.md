# tmux for beginners

tmux keeps terminal work running after you disconnect and lets one session contain
multiple windows and panes.

## The three objects

- **Session**: the whole workspace, usually one per project.
- **Window**: like a terminal tab inside the session.
- **Pane**: a split region inside a window.

## The prefix rule

Inside tmux, shortcuts start with the prefix. This configuration uses `Ctrl-a`.

Do **not** hold every key together. Press `Ctrl-a`, release both keys, and then press
the action key. The notation `prefix d` below means exactly that sequence.

## Start, leave, and return

Run these in a normal terminal:

```sh
tmux new -s cyan-eval       # create a named session
tmux ls                     # list sessions
tmux attach -t cyan-eval    # attach to one
tmux new -As cyan-eval      # attach if it exists, otherwise create it
tmux kill-session -t cyan-eval  # permanently stop that session
```

From inside tmux:

- `prefix d`: detach. Everything keeps running.
- `exit`: close the current pane. The session ends only after its last pane closes.

Detaching is not quitting. This is why tmux is useful over SSH: detach before leaving,
then attach again later.

## Panes

- `prefix |`: create panes side by side.
- `prefix -`: create panes above and below.
- `prefix h/j/k/l`: move left/down/up/right.
- `prefix z`: zoom the current pane; repeat to return.
- `prefix x`: close the current pane after confirmation.

Mouse support is enabled, so clicking a pane and dragging a divider also work.

## Windows

- `prefix c`: create a window in the current directory.
- `prefix n` / `prefix p`: next / previous window.
- `prefix 1` through `prefix 9`: jump directly to a window.
- `prefix ,`: rename the current window.
- `prefix w`: show an interactive window list.

## Scrolling and copying

- `prefix [`: enter copy/scroll mode.
- Arrow keys or Vim movement keys scroll.
- `v`: begin selecting in copy mode.
- `y`: copy the selection into tmux's buffer.
- `q` or `Escape`: leave copy mode.

The mouse wheel can also enter scroll mode. System clipboard integration is not
forced, because it differs between local macOS and remote Linux terminals.

## Configuration and help

- `prefix r`: reload `~/.tmux.conf` after an edit.
- `prefix ?`: show all current key bindings.

## A five-minute practice session

```sh
tmux new -s practice
```

Then:

1. Press `Ctrl-a`, release, then `|`.
2. Move between panes with `prefix h` and `prefix l`.
3. Create a window with `prefix c`; return with `prefix 1`.
4. Detach with `prefix d`.
5. Run `tmux attach -t practice` and confirm everything is still there.
6. When finished, run `tmux kill-session -t practice` outside tmux.

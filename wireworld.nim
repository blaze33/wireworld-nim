type
  State = enum
    ground, wire, head, tail

  Pos = tuple
    x, y: int

  Neighbor = enum
    nw, n, ne, e, se, s, sw, w

  World[N: static[int]] = array[N, array[N, State]]

proc `$`[N](world: World[N]): string =
  result = ""
  for row in world:
    for col in row:
      case col:
        of ground: result.add(" ")
        of wire: result.add("-")
        of head: result.add("+")
        of tail: result.add("=")
    result.add("\n")

template get[N](world: World[N], x, y: int): State =
  world[y][x]

proc neighbors[N](world: World[N], x, y: int): array[State, int] =
  # Returns a array with the count of each state in the neighboring cells
  result[world.get(x, y)] -= 1
  for i in [x - 1, x, x + 1]:
    for j in [y - 1, y, y + 1]:
      if i >= 0 and i < N and j >= 0 and j < N:
        result[world.get(i, j)] += 1

proc newState[N](world: World[N], x, y: int): State =
  # Return the new state for the cell after its update
  let
    current = world.get(x, y)
    neighbors = world.neighbors(x, y)
    headcount = neighbors[head]

  case current:
    of ground: result = ground
    of head: result = tail
    of tail: result = wire
    of wire:
      if headcount == 1 or headcount == 2:
        result = head
      else:
        result = wire

proc process[N](world: var World[N]) =
  for x in 0..<N:
    for y in 0..<N:
      world.get(x, y) = world.newState(x, y)

if isMainModule:
  var world: World[3] = [[wire, ground, head],
                         [wire, ground, ground],
                         [tail, head, head]]

  for _ in 1..5:
    echo world
    world.process
  echo world

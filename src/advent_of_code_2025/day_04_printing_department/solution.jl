import Utils

test_input1 = """
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
"""

ROLL = '@'
EMPTY = '.'

function parseinput(input::AbstractString)
    map = Utils.textblocktomatrix(input, Char)
    return map
end

function addtoneighbors!(
    map::Matrix{Union{Missing,Char}},
    adjacency::Matrix{Int},
    loc::CartesianIndex{2},
)
    neighbors = [
        loc + CartesianIndex{2}(-1, -1),
        loc + CartesianIndex{2}(-1, 0),
        loc + CartesianIndex{2}(-1, 1),
        loc + CartesianIndex{2}(0, -1),
        loc + CartesianIndex{2}(0, 1),
        loc + CartesianIndex{2}(1, -1),
        loc + CartesianIndex{2}(1, 0),
        loc + CartesianIndex{2}(1, 1),
    ]
    for n in neighbors
        if checkbounds(Bool, map, n) && map[n] == ROLL
            adjacency[n] += 1
        end
    end
end

function puzzle1(input::AbstractString)
    map = parseinput(input)

    adjacency = zeros(Int, size(map))

    for i in CartesianIndices(map)
        if map[i] == ROLL
            addtoneighbors!(map, adjacency, i)
        end
    end

    movable = 0

    for i in CartesianIndices(map)
        if map[i] == ROLL && adjacency[i] < 4
            movable += 1
        end
    end
    return movable
end

function puzzle2(input::AbstractString)
    map = parseinput(input)

    removed = 0
    removed_this_pass = nothing

    while isnothing(removed_this_pass) || removed_this_pass > 0
        removed_this_pass = 0
        adjacency = zeros(Int, size(map))

        for i in CartesianIndices(map)
            if map[i] == ROLL
                addtoneighbors!(map, adjacency, i)
            end
        end

        for i in CartesianIndices(map)
            if map[i] == ROLL && adjacency[i] < 4
                map[i] = EMPTY
                removed_this_pass += 1
            end
        end

        removed += removed_this_pass
    end

    return removed
end

# input = test_input1
input = Utils.readinput()

println("Puzzle 1: $(puzzle1(input))")
println("Puzzle 2: $(puzzle2(input))")

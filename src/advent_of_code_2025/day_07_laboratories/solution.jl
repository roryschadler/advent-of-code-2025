import Utils
import DataStructures

test_input1 = """
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
"""

const LEFT = CartesianIndex{2}(-1, 0)
const RIGHT = CartesianIndex{2}(1, 0)
const DOWN = CartesianIndex{2}(0, 1)

const START = 'S'
const FREE = '.'
const SPLITTER = '^'
const BEAM = '|'

function parseinput(input::AbstractString)::Matrix{Char}
    return Utils.textblocktomatrix(input)
end

function puzzle1(input::AbstractString)::Int
    stack = Vector{CartesianIndex{2}}()
    splits = 0

    manifold = parseinput(input)
    push!(stack, findfirst(isequal(START), manifold))

    while !isempty(stack)
        loc = pop!(stack)
        if !checkbounds(Bool, manifold, loc)
            @debug "$loc out of bounds"
            continue
        end

        loc_char = manifold[loc]

        if loc_char == START || loc_char == FREE
            @debug "Beam continues down from $loc"
            push!(stack, loc + DOWN)
        elseif loc_char == SPLITTER
            @debug "Split at $loc"
            push!(stack, loc + LEFT)
            push!(stack, loc + RIGHT)
            splits += 1
        end

        manifold[loc] = BEAM
    end

    @debug Utils.matrixtotextblock(manifold)

    return splits
end

function puzzle2(input::AbstractString)::Int
    to_visit = DataStructures.DefaultDict{CartesianIndex{2},Int}(0)
    manifold = parseinput(input)
    (_, max_y) = size(manifold)

    function dfs(loc::CartesianIndex{2})
        if !checkbounds(Bool, manifold, loc)
            return
        end

        if loc[2] >= max_y
            to_visit[loc] = 1
        else
            to_visit[loc] = 0
        end


        loc_char = manifold[loc]

        if loc_char == START || loc_char == FREE
            @debug "Beam continues down from $loc"
            if !haskey(to_visit, loc + DOWN)
                dfs(loc + DOWN)
            end
            to_visit[loc] += to_visit[loc+DOWN]
        elseif loc_char == SPLITTER
            @debug "Split at $loc"
            if !haskey(to_visit, loc + LEFT)
                dfs(loc + LEFT)
            end
            if !haskey(to_visit, loc + RIGHT)
                dfs(loc + RIGHT)
            end

            to_visit[loc] += to_visit[loc+LEFT] + to_visit[loc+RIGHT]
        end
    end

    starting_point = findfirst(isequal(START), manifold)

    dfs(starting_point)

    return to_visit[starting_point]
end

# input = test_input1
input = Utils.readinput()

println("Puzzle 1: $(puzzle1(input))")
println("Puzzle 2: $(puzzle2(input))")

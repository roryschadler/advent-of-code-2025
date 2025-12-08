import Utils
import Memoization

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
    # seen = DataStructures.DefaultDict{CartesianIndex{2},Int}(0)
    to_visit = Set{CartesianIndex{2}}()
    manifold = parseinput(input)
    (_, max_y) = size(manifold)
    paths = 0

    function dfs(loc::CartesianIndex{2})
        if !checkbounds(Bool, manifold, loc)
            return 0
        end

        if loc[2] >= max_y
            return 1
        end

        push!(to_visit, loc)

        loc_char = manifold[loc]

        if loc_char == START || loc_char == FREE
            @debug "Beam continues down from $loc"
            if (loc + DOWN) ∉ to_visit
                return dfs(loc + DOWN)
            end
        elseif loc_char == SPLITTER
            @debug "Split at $loc"
            total = 0
            if (loc + LEFT) ∉ to_visit
                total += dfs(loc + LEFT)
            end
            if (loc + RIGHT) ∉ to_visit
                total += dfs(loc + RIGHT)
            end

            return total
        end

        pop!(to_visit, loc)

        return 0
    end

    return dfs(findfirst(isequal(START), manifold))

    # return paths
end

input = test_input1
# input = Utils.readinput()

println("Puzzle 1: $(puzzle1(input))")
println("Puzzle 2: $(puzzle2(input))")

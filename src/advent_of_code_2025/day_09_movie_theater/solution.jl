import Combinatorics
import IterTools
import Utils

test_input1 = """
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
"""

function parseinput(input::AbstractString)::Vector{Vector{Int}}
    return map(x -> parse.(Int, split(x, ',')), Utils.textblocktolines(input))
end

function sizeofrectangle(c1::Vector{Int}, c2::Vector{Int})::Int
    x = abs(c1[1] - c2[1]) + 1
    y = abs(c1[2] - c2[2]) + 1

    return x * y
end

function puzzle1(input::AbstractString)::Int
    reds = parseinput(input)

    sizes = Vector{Int}()

    for (c1, c2) in Combinatorics.combinations(reds, 2)
        push!(sizes, sizeofrectangle(c1, c2))
    end
    return maximum(sizes)
end

function areaisless(a::Vector{Vector{Int}}, b::Vector{Vector{Int}})
    (c1a, c2a) = a
    (c1b, c2b) = b

    return isless(sizeofrectangle(c1a, c2a), sizeofrectangle(c1b, c2b))
end

function orderedcorners(c1::Vector{Int}, c2::Vector{Int})
    (c1x, c1y) = c1
    (c2x, c2y) = c2
    return [[min(c1x, c2x), min(c1y, c2y)], [max(c1x, c2x), max(c1y, c2y)]]
end


# https://www.reddit.com/r/adventofcode/comments/1phywvn/comment/nt64t2d/
# sort the rectangles and edges by area (edges have a width of 1, area == length)
# sorting edges by length because longer edges are more likely to intersect
# then iterate over rectangles in decreasing area order
# if an edge intersects with the rectangle, part of it must be outside
# if no edge intersects with the rectangle, it is either fully included or fully
# excluded. luckily for this input, the largest non-intersected rectangle is
# included :)

function puzzle2(input::AbstractString)::Int
    reds = parseinput(input)
    cycled_reds = [reds..., reds[1]]

    rectangles = sort(
        [orderedcorners(c1, c2) for (c1, c2) in Combinatorics.combinations(reds, 2)],
        lt = areaisless,
        rev = true,
    )

    green_lines = sort(
        [orderedcorners(c1, c2) for (c1, c2) in IterTools.partition(cycled_reds, 2, 1)],
        lt = areaisless,
        rev = true,
    )

    for ((r1x, r1y), (r2x, r2y)) in rectangles
        intersects = false
        for ((l1x, l1y), (l2x, l2y)) in green_lines
            if l1x < r2x && l1y < r2y && l2x > r1x && l2y > r1y
                intersects = true
                break
            end
        end
        if !intersects
            return sizeofrectangle([r1x, r1y], [r2x, r2y])
        end
    end

    return -1
end

# input = test_input1
input = Utils.readinput()

println("Puzzle 1: $(puzzle1(input))")
println("Puzzle 2: $(puzzle2(input))")

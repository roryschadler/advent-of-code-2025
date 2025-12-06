import Utils

test_input1 = """
3-5
10-14
16-20
12-18

1
5
8
11
17
32
"""

function parseinput(input::AbstractString)::Tuple{Vector{NTuple{2,Int}},Vector{Int}}
    range_block, ingredient_block = split(input, "\n\n")
    ranges = map(
        x -> (parse(Int, x[1]), parse(Int, x[2])),
        split.(Utils.textblocktolines(range_block), '-'),
    )
    ingredients = map(x -> parse(Int, x), Utils.textblocktolines(ingredient_block))

    return ranges, ingredients
end

function coalesce_ranges(ranges::Vector{NTuple{2,Int}})::Vector{NTuple{2,Int}}
    sorted_ranges = sort(ranges, by = x -> x[1])
    coalesced_ranges = Vector{NTuple{2,Int}}()
    current_range = sorted_ranges[1]
    for r in sorted_ranges[2:end]
        if r[1] > current_range[2]
            @debug "Disjoint range $r"
            push!(coalesced_ranges, current_range)
            current_range = r
        elseif r[2] > current_range[2]
            @debug "Extending range $r"
            current_range = (current_range[1], r[2])
        end
    end

    push!(coalesced_ranges, current_range)

    return coalesced_ranges
end

function puzzle1(input::AbstractString)::Int
    ranges, ingredients = parseinput(input)

    collected_ranges = coalesce_ranges(ranges)
    sort!(ingredients)

    #=
    for each range
        collect as many ingredients as possible:
        while i <= max_ingredient_idx
            if ingredient < range
                next ingredient
            elseif ingredient > range
                next range (break while)
            else
                ingredient in range! increment
                next ingredient
            end
        end
    end
    =#

    ingredient_idx = 1
    ingredient_count = length(ingredients)
    fresh_ingredients = 0

    for r in collected_ranges
        while ingredient_idx <= ingredient_count
            current_ingredient = ingredients[ingredient_idx]
            if current_ingredient < r[1]
                @debug "Current ingredient $current_ingredient less than range"
                ingredient_idx += 1
            elseif current_ingredient > r[2]
                @debug "Current ingredient $current_ingredient more than range"
                break
            else

                fresh_ingredients += 1
                ingredient_idx += 1
            end
        end
    end
    return fresh_ingredients
end

function puzzle2(input::AbstractString)
    ranges, _ = parseinput(input)

    collected_ranges = coalesce_ranges(ranges)

    total_fresh = 0
    for r in collected_ranges
        total_fresh += r[2] - r[1] + 1
    end

    return total_fresh
end

# input = test_input1
input = Utils.readinput()

println("Puzzle 1: $(puzzle1(input))")
println("Puzzle 2: $(puzzle2(input))")

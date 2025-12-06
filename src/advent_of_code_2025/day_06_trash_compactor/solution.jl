import Utils

test_input1 = join(
    [
        "123 328  51 64 "
        " 45 64  387 23 "
        "  6 98  215 314"
        "*   +   *   +  "
    ],
    "\n",
)

function parseinput1(input::AbstractString)::Tuple{Vector{Vector{Int}},Vector{Char}}
    lines = Utils.textblocktolines(input)

    numbers = map(x -> parse.(Int, x), split.(lines[1:end-1], ' ', keepempty = false))
    operations = map(x -> x[1], split(lines[end], ' ', keepempty = false))

    return [[l[i] for l in numbers] for i = 1:length(numbers[1])], operations
end

function parseinput2(input::AbstractString)::Tuple{Vector{Vector{Int}},Vector{Char}}
    lines = Utils.textblocktolines(input)

    operations = Vector{Char}()
    cephalopod_numbers = Vector{Vector{Int}}()

    numbers = Vector{Int}()
    for (i, c) in Iterators.reverse(enumerate(lines[end]))
        n = 0
        for l in lines[1:end-1]
            if !isspace(l[i])
                n = n * 10 + parse(Int, l[i])
            end
        end

        if n > 0
            @debug "Got number $n"
            push!(numbers, n)
        end

        if !isspace(c)
            @debug "Group: $c, $numbers"
            push!(cephalopod_numbers, numbers)
            push!(operations, c)
            numbers = Vector{Int}()
        end
    end

    return cephalopod_numbers, operations
end

function puzzle(numbers::Vector{Vector{Int}}, operations::Vector{Char})::Int
    m = length(operations)
    @assert length(numbers) == m

    total = 0

    for i = 1:m
        if operations[i] == '+'
            total += sum(numbers[i])
        elseif operations[i] == '*'
            total += prod(numbers[i])
        end
    end
    return total
end

# input = test_input1
input = Utils.readinput()

numbers1, operations1 = parseinput1(input)
numbers2, operations2 = parseinput2(input)

println("Puzzle 1: $(puzzle(numbers1, operations1))")
println("Puzzle 2: $(puzzle(numbers2, operations2))")

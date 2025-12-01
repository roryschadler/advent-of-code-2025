import Utils

test_input1 = """
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
"""

test_input2 = """
L50
R100
L300
"""

function parseinputline(input::AbstractString)::Int
    if length(input) < 2
        error("Invalid line $input")
    end

    dir = input[1] == 'L' ? -1 : 1
    steps = parse(Int, input[2:end])

    return dir * steps
end

function puzzle1(input::AbstractString)
    steps = map(parseinputline, Utils.textblocktolines(input))

    loc = 50
    zero_hits = 0

    for s in steps
        loc = mod(loc + s, 100)
        @debug "Step $s, new_location $loc"

        if loc == 0
            @debug "Landed on zero"
            zero_hits += 1
        end
    end

    return zero_hits
end

function countzeropasses(start_loc::Int, end_loc::Int)::Int
    zero_passes = 0

    if end_loc <= 0 && start_loc != 0
        @debug "At or past zero"
        zero_passes += 1
    end

    overflow = abs(end_loc ÷ 100)

    @debug "Overflow passes $overflow"

    zero_passes += overflow

    return zero_passes
end


function puzzle2(input::AbstractString)
    steps = map(parseinputline, Utils.textblocktolines(input))

    loc = 50
    zero_hits = 0

    for s in steps
        new_loc = loc + s
        @debug "Step $s, new location $new_loc"

        zero_passes = countzeropasses(loc, new_loc)

        loc = new_loc

        @debug "Step included $zero_passes zero passes"

        loc = mod(loc, 100)

        @debug "Location normalized $loc"

        zero_hits += zero_passes
    end

    return zero_hits
end

# input = test_input1
# input = test_input2
input = Utils.readinput()

println("Puzzle 1: $(puzzle1(input))")
println("Puzzle 2: $(puzzle2(input))")

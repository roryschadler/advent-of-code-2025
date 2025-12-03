import Utils

test_input1 = """
987654321111111
811111111111119
234234234234278
818181911112111
"""

function parseinput(input::AbstractString)
    return Utils.textblocktomatrix(input, Int)
end

function puzzle1(input::AbstractString)::Int
    batteries = parseinput(input)
    sum = 0

    for row in eachcol(batteries)
        ind1 = argmax(row[1:end-1])
        ind2 = argmax(row[ind1+1:end])
        d1 = row[ind1]
        d2 = row[ind1+ind2]
        @debug "Turning on $d1 and $d2"
        sum += 10 * d1 + d2
    end

    return sum
end

function puzzle2(input::AbstractString)::Int
    batteries = parseinput(input)
    sum = 0

    for row in eachcol(batteries)
        @debug "Checking row $row"
        last_ind = 0
        for i = 11:-1:0
            ind = argmax(row[last_ind+1:end-i])
            d = row[ind+last_ind]
            @debug "Turning on $d (last_ind $last_ind, i $i)"
            sum += 10^i * d
            last_ind = ind + last_ind
        end
    end

    return sum
end

# input = test_input1
input = Utils.readinput()

println("Puzzle 1: $(puzzle1(input))")
println("Puzzle 2: $(puzzle2(input))")

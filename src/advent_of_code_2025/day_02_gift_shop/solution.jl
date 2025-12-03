import Utils

test_input1 = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

function parseinput(input::AbstractString)::Vector{Vector{Int}}
    return map(i -> parse.(Int, split(i, '-')), split(input, ','))
end


function puzzle1(input::AbstractString)::Int
    ranges = parseinput(input)
    total = 0

    for (r1, r2) in ranges
        @debug "Testing $r1, $r2"
        om1 = floor(log10(r1))
        om2 = floor(log10(r2))
        if om1 == om2 && iseven(om1)
            @warn "OoM is even - odd number of digits for entire span $r1 -> $r2. Skipping"
            continue
        end
        if om1 < om2
            @debug "OoM mismatch - shrinking range to only valid options"
            if iseven(om1)
                r1 = 10^(om1 + 1)
                om1 += 1
                @debug "OoM for r1 is even - odd number of digits up to $r1, increasing range start"
            end
            if iseven(om2)
                r2 = 10^om2 - 1
                om2 -= 1
                @debug "OoM for r2 is even, odd number of digits down to $r2, decreasing range end"
            end
        end

        factor_options = Set{Int}()
        for i = om1:om2
            push!(factor_options, 10^(i ÷ 2 + 1) + 1)
        end

        @debug "Factor options $factor_options"

        for factor in factor_options
            factor_magnitude = floor(log10(factor))
            for i = 10^(factor_magnitude-1):(10^factor_magnitude)-1
                @debug "Checking $(i * factor)"
                if i * factor < r1
                    continue
                end
                if i * factor > r2
                    break
                end
                @debug "Adding $(i * factor)"
                total += i * factor
            end
        end
    end
    return total
end


# 11, 111, 1111
# sum from j=0 to (1, 2, 3, ..., om2) of 10^j
# multiply by 1:9

# 10101, 1010101
# sum from j=0 to floor((1, 2, 3, ..., om2) / 2) of 10^2j
# multiply by 10:99

# 1001001, 1001001001
# sum from j=0 to floor((1, 2, 3, ..., om2) / 3) of 10^3j
# multiply by 100:999

# all combined:
# for k in (1, 2, 3, ..., om2)
# sum from j=0 to floor((1, 2, 3, ..., om2) / k) of 10^(k * j)
# multiply by 10^(k-1) : (10^k) - 1


function puzzle2(input::AbstractString)::Int
    ranges = parseinput(input)
    total = 0

    for (ii, (r1, r2)) in enumerate(ranges)
        @debug "Testing $r1, $r2"
        om1 = floor(log10(r1))
        om2 = floor(log10(r2))
        matches = Set{Int}()

        for i = 1:om2
            factor_options = Set{Int}()

            for k = 0:om2÷i
                f = 0
                for j = 0:k
                    f += 10^(i * j)
                end
                if f > r2
                    break
                end
                if f > 1
                    push!(factor_options, f)
                end
            end

            @debug "Factor options: $factor_options"

            for factor in factor_options
                for x = 10^(i-1):(10^i)-1
                    if x * factor < r1
                        continue
                    end
                    if x * factor > r2
                        break
                    end
                    @debug "Adding $(x * factor)"
                    push!(matches, x * factor)
                end
            end
        end

        total += sum(matches)
    end
    return total
end

input = test_input1
input = Utils.readinput()

println("Puzzle 1: $(puzzle1(input))")
println("Puzzle 2: $(puzzle2(input))")

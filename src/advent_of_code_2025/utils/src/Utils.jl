# This file contains utility functions for Advent of Code 2025.
module Utils

export readinput, textblocktolines, textblocktomatrix, matrixtotextblock, transposelines

function readinput(path::String = "input.txt", T = String)
    dir = length(PROGRAM_FILE) > 0 ? dirname(PROGRAM_FILE) : pwd()
    return open(f -> read(f, T), "$dir/$path")
end

function textblocktolines(textblock::AbstractString)::Vector{String}
    return String.(filter(l -> length(l) > 0, split(textblock, "\n")))
end

function textblocktomatrix(textblock::AbstractString, T = Char; default = missing)
    lines = textblocktolines(textblock)
    m = length(lines[1])
    n = length(lines)
    @assert all(l -> length(l) == m, lines)

    function local_parse(c)
        if T <: Number
            try
                return parse(T, c)
            catch
                return default
            end
        else
            return T(c)
        end
    end
    mtx = Matrix{Union{T,Missing}}(undef, m, n)
    for i in eachindex(lines)
        for (j, c) in enumerate(lines[i])
            mtx[j, i] = local_parse(c)
        end
    end
    return mtx
end

function matrixtotextblock(mtx::Matrix{Char})::String
    return join(transposelines([String(c) for c in eachrow(mtx)]), "\n")
end

function transposelines(lines::Vector{String})::Vector{String}
    return [join([lines[i][j] for i = 1:length(lines)]) for j = 1:length(lines[1])]
end

end

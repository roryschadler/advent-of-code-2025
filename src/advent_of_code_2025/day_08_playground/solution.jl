import Combinatorics
import Graphs
import LinearAlgebra
import Utils

test_input1 = """
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689
"""

function parseinput(input::AbstractString)::Vector{Vector{Int}}
    return map(x -> parse.(Int, split(x, ',')), Utils.textblocktolines(input))
end

function puzzle1(input::AbstractString, num_connections::Int)::Int
    boxes = parseinput(input)

    edges = Dict{NTuple{2,Vector{Int}},Number}()

    for (b1, b2) in Combinatorics.combinations(boxes, 2)
        edges[(b1, b2)] = LinearAlgebra.norm(b1 - b2)
    end

    sorted_edges = sort(collect(edges), by = x -> x.second)

    graph = Graphs.SimpleGraph(Int)
    vertices = Vector{Vector{Int}}()

    for i = 1:num_connections
        ((b1, b2), _) = sorted_edges[i]
        b1_idx = findfirst(isequal(b1), vertices)
        b2_idx = findfirst(isequal(b2), vertices)

        if isnothing(b1_idx)
            Graphs.add_vertex!(graph)
            push!(vertices, b1)
            b1_idx = length(vertices)
        end

        if isnothing(b2_idx)
            Graphs.add_vertex!(graph)
            push!(vertices, b2)
            b2_idx = length(vertices)
        end

        Graphs.add_edge!(graph, b1_idx, b2_idx)
    end

    return prod(sort(map(length, Graphs.connected_components(graph)), rev = true)[1:3])
end

function puzzle2(input::AbstractString)::Int
    boxes = parseinput(input)

    edges = Dict{NTuple{2,Vector{Int}},Number}()

    for (b1, b2) in Combinatorics.combinations(boxes, 2)
        edges[(b1, b2)] = LinearAlgebra.norm(b1 - b2)
    end

    sorted_edges = sort(collect(edges), by = x -> x.second)

    graph = Graphs.SimpleGraph(Int)
    vertices = Vector{Vector{Int}}()

    for box in boxes
        Graphs.add_vertex!(graph)
        push!(vertices, box)
    end

    for e in sorted_edges
        ((b1, b2), _) = e
        b1_idx = findfirst(isequal(b1), vertices)
        b2_idx = findfirst(isequal(b2), vertices)

        Graphs.add_edge!(graph, b1_idx, b2_idx)

        if Graphs.is_connected(graph)
            return b1[1] * b2[1]
        end
    end
end

# input, num_connections = test_input1, 10
input, num_connections = Utils.readinput(), 1000

println("Puzzle 1: $(puzzle1(input, num_connections))")
println("Puzzle 2: $(puzzle2(input))")

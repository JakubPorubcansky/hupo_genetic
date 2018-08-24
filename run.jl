include("hupo.jl")

const net_top_move = Chain(
    Dense(72, 100, relu),
    Dense(100, 20, relu),
    Dense(20, 20, relu),
    Dense(20, 4),
    softmax)
const net_top_pass = Chain(
    Dense(72, 100, relu),
    Dense(100, 20, relu),
    Dense(20, 20, relu),
    Dense(20, 6),
    softmax)

state = [3; 2; 1; 2; 3; 2; 3; 2; 3; 2; 3; 2; -1; 2; -1; -1; -1; -1]

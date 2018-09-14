include("UnicodeGrids.jl")
include("printing.jl")
using .UnicodeGrids
# using Statistics
using Flux
using Flux: onehot

@enum Move up = 1 right = 2 down = 3 left = 4
moveDict = Dict("up" => [-1, 0], "right" => [0, 1], "down" => [1, 0], "left" => [0, -1])

get_position(state, active_stone) = [state[active_stone*2 - 1]; state[active_stone*2]]


function make_move!(agent, state, active_stone)
    p = agent(state).data .+ 1e-6

    stone_position = get_position(state, active_stone)

    p ./= sum(p)
    r = rand()
    move = Move(findfirst(x -> x >= r, cumsum(p)))
    stone_position .+= moveDict[string(move)]

    state[active_stone*2 - 1 : active_stone*2] .= stone_position
end

function pass!(state, stoneFrom, stoneTo)
    state[12 + stoneFrom] = 1
    state[12 + stoneTo] = 2
end

is_valid_position(pos, oponent_pos) = pos == [3; 2] ||
                              pos[1] ∈ [0; 6] || pos[2] ∈ [0; 4] ||
                              pos == oponent_pos? false : true

is_winning_position(pos, stone) = stone <= 3 ? pos == [4, 2] : pos == [2, 2]

# evaluate_position(pos, stone) = stone <= 3 ? 4 - sum(abs.(pos .- [4, 2])) : 4 - sum(abs.(pos .- [2, 2]))

function game(agent1, agent2, begin_state)
    a1Stone = 2
    a2Stone = 5

    state = begin_state[:]
    game_len = 1

    while true
        make_move!(agent1, state, a1Stone)
        pos1 = get_position(state, a1Stone)
        pos2 = get_position(state, a2Stone)
        # !is_valid_position(pos1, pos2) || is_winning_position(pos1, a1Stone) && return [evaluate_position(pos1, a1Stone), evaluate_position(pos2, a2Stone)]
        !is_valid_position(pos1, pos2) && return [0, 1]
        is_winning_position(pos1, a1Stone) && return [30, 0]

        pass!(state, a1Stone, a2Stone)

        println(state)

        make_move!(agent2, state, a2Stone)
        pos2 = get_position(state, a2Stone)
        pos1 = get_position(state, a1Stone)
        # !is_valid_position(pos2, pos1) || is_winning_position(pos2, a2Stone) && return [evaluate_position(pos1, a1Stone), evaluate_position(pos2, a2Stone)]
        !is_valid_position(pos2, pos1) && return [1, 0]
        is_winning_position(pos2, a2Stone) && return [0, 30]

        pass!(state, a2Stone, a1Stone)

        println(state)

        game_len > 50 && return [0, 0]
        game_len += 1
    end
end

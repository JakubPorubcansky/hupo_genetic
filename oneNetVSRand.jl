include("UnicodeGrids.jl")
include("printing.jl")
using .UnicodeGrids
# using Statistics
using Flux
using Flux: onehot

@enum Move up = 1 right = 2 down = 3 left = 4
moveDict = Dict("up" => [-1, 0], "right" => [0, 1], "down" => [1, 0], "left" => [0, -1])

get_position(state, active_stone) = [state[active_stone*2 - 1]; state[active_stone*2]]


function make_move!(agent, active_stone, state)
    p = agent(state).data .+ 1e-6

    stone_position = get_position(state, active_stone)

    p ./= sum(p)
    r = rand()
    move = Move(findfirst(x -> x >= r, cumsum(p)))
    stone_position .+= moveDict[string(move)]

    state[active_stone*2 - 1 : active_stone*2] .= stone_position
end

function opponent_move!(stone, state)
    position = get_position(state, stone)

    all_positions = [position .+ moveDict[string(Move(i))] for i in 1:4]
    possible_positions_idcs = [i for i in eachindex(all_positions) if is_valid_position(all_positions[i], [0, 0])]

    state[stone*2 - 1 : stone*2] .= all_positions[rand(possible_positions_idcs)]
end

is_valid_position(pos, o_pos) = pos == [3; 2] ||
                              pos[1] ∈ [0; 6] || pos[2] ∈ [0; 4] ||
                              pos == o_pos? false : true

is_winning_position(pos) = pos == [4; 2] ? true : false

# game_over(gr) = findfirst(x -> x == 0, view(gr, :, 1)) == nothing ? true : false
game_over(gr) = findfirst(x -> x == 0, view(gr, :, 1)) == 0 ? true : false

function game(agents, begin_state, game_len)
    N = length(agents)

    states = [begin_state[:] for _ in 1:N]

    game_results = zeros(N, 2)
    active_stone = 2
    oponent_stone = 5
    game_length = 0

    while true
      game_length += 1

      for (i, (ag, st)) in enumerate(zip(agents, states))
           game_results[i, 1] != 0 && continue
           make_move!(ag, active_stone, st)
           opponent_move!(oponent_stone, st)
           pos = get_position(st, active_stone)
           oponent_pos = get_position(st, oponent_stone)

           if !is_valid_position(pos, oponent_pos) || game_length >= game_len
               game_results[i, :] .= [game_length, false]
           end
           if is_winning_position(pos)
               game_results[i, :] .= [game_length, true]
           end
       end

       if game_over(game_results)
          return game_results
       end
    end
end


function game_show(agent, begin_state, game_len)
    state = begin_state[:]

    active_stone = 2
    oponent_stone = 5
    round_number = 1

    println()
    println("Round $(round_number)")
    print_state(state)
    println("press <Enter>")

    while true
        readline()
        clear(16)

        make_move!(agent, active_stone, state)
        opponent_move!(oponent_stone, state)
        pos = get_position(state, active_stone)
        oponent_pos = get_position(state, oponent_stone)

        if !is_valid_position(pos, oponent_pos)
            println("INVALID POSITION")
            break
        end
        if is_winning_position(pos)
            println("WINNING POSITION")
            break
        end

        println("Round $(round_number)")
        print_state(state)

        round_number += 1
    end
end

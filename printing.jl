@enum Move up = 1 right = 2 down = 3 left = 4 out = 5
const d_moves = Dict(up => "↑", right => "→", down => "↓", left => "←", out => "~")

userMV = Dict("\e[C" => "right", "\e[A" => "up", "\e[B" => "down", "\e[D" => "left")

function game_show(agents, begin_state)
    stones = [2, 5]

    state = begin_state[:]
    game_len = 1

    active = 1

    println()
    println("Round $(game_len)")
    print_state(state)
    println("press <Enter>")

    while true
        readline()
        clear(14)

        make_move!(agents[active], state, stones[active])
        pos1 = get_position(state, stones[active])
        pos2 = get_position(state, stones[3-active])
        !is_valid_position(pos1, pos2) && return [0, 1]
        is_winning_position(pos1, stones[active]) && return [1, 0]

        if !is_valid_position(pos1, pos2)
            println("INVALID POSITION")
            break
        end
        if is_winning_position(pos1, stones[active])
            println("WINNING POSITION")
            break
        end

        game_len > 50 && break

        println("Round $(game_len)")
        print_state(state)

        active = 3-active
        game_len += 1
    end
end

function interact(agent, begin_state)
    stones = [2, 5]

    state = begin_state[:]
    game_len = 1

    active = 1

    println()
    println("Round $(game_len)")
    print_state(state)

    while true
        if active == 1
            println("Opponent's turn (press <Enter>)")
            readline()

            make_move!(agents[active], state, stones[active])

            pos1 = get_position(state, stones[active])
            pos2 = get_position(state, stones[3-active])
            !is_valid_position(pos1, pos2) && break
            is_winning_position(pos1, stones[active]) && break
        else
            println("Your turn (use keys to move)")
            key = chomp(readline())

            state[stones[active]*2 - 1 : stones[active]*2] .+= moveDict[userMV[key]]
            pos2 = get_position(state, stones[active])
            pos1 = get_position(state, stones[3-active])

            !is_valid_position(pos2, pos1) && break
            is_winning_position(pos2, stones[active]) && break

        end

        clear(14)

        game_len > 50 && break

        println("Round $(game_len)")
        print_state(state)

        active = 3-active
        game_len += 1
    end
end

function print_state(state::Array{Int})
    M = fill(" ", 5, 3)
    M[3,2] = "x"
    for i in 1:6
        state[12+i] == -1 && continue
        c = string(i)
        state[12+i] == 1 && (c = aesRed * c * aesClear)
        state[12+i] == 2 && (c = aesBold * aesYellow * c * aesClear)
        id = i*2-1
        M[state[id],state[id+1]] = c
    end
    print_grid(M)
end


"Clear `n` lines above cursor."
function clear(n::Int)
    println("\033[$(n)A" * "\033[K\n" ^ n * "\033[$(n)A")
end

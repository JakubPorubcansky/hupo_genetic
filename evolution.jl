include("oneNetMoveOnly.jl")

Nagents = 100
Ngames = 100
game_len = 10
select = 1/3

beginning_state = [3; 2; 1; 2; 3; 2; 3; 2; 3; 2; 3; 2; -1; 2; -1; -1; -1; -1]
agents = [Chain(Dense(18, 14), Dense(14, 4)) for _ in 1:Nagents]

result = zeros(Nagents, 3)
for epoch in 1:20
    result[:, 3] = 1:Nagents
    for i in 1:Ngames
        result[:, 1:2] .+= game(agents, beginning_state, game_len)
    end

    result[:, 1:2] ./= Ngames
    result .= sortslices(result, dims = 1, rev = true, by = x -> (x[2], x[1]))

    ### selection
    n_sel = Int(round(select*100))
    idcs = convert.(Int, result[1:n_sel, 3])

    for i in setdiff(1:Nagents, idcs)
        agents[i] = deepcopy(agents[rand(idcs)])
    end
    println(epoch)
    println(result[1:5, 2])
end

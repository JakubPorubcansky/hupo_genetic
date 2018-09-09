
for epoch in 1:Nepochs
    result[:, 1:2] .= 0
    result[:, 3] = 1:Nagents
    for i in 1:Ngames
        result[:, 1:2] .+= game(agents, beginning_state, game_len)
    end

    result[:, 1:2] ./= Ngames
    # result .= sortslices(result, dims = 1, rev = true, by = x -> (x[2], x[1]))
    result .= sortrows(result, rev = true, by = x -> (x[2], x[1]))

    ### selection
    n_sel = Int(round(select * 100))
    idcs = convert.(Int, result[1:n_sel, 3])

    for i in setdiff(1:Nagents, idcs)
        ### crossover
        # agents[i] = deepcopy(agents[rand(idcs)])
        ridx = rand(idcs)
        params(agents[i])[1].data .= params(agents[ridx])[1].data
        params(agents[i])[2].data .= params(agents[ridx])[2].data
        params(agents[i])[3].data .= params(agents[ridx])[3].data
        params(agents[i])[4].data .= params(agents[ridx])[4].data

        ### mutation
        for k in 1:Nmutations
            params(agents[i])[1].data[rand(1:hidden), rand(1:input)] = rand() - 0.5
            params(agents[i])[2].data[rand(1:hidden)] = rand() - 0.5
            params(agents[i])[3].data[rand(1:output), rand(1:hidden)] = rand() - 0.5
            params(agents[i])[4].data[rand(1:output)] = rand() - 0.5
        end
    end
    println(epoch)
    println(result[1:5, 2])
end

# function evolution_train!(restab, Ngames, Nepochs, game_len, select, Nmutations, beginning_state, input, hidden, output)


# for agent in agents
#     println([maximum(params(agent)[i].data[:]) for i in 1:4])
# end

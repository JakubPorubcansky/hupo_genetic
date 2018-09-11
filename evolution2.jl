
for epoch in 1:Nepochs
    result[:, 2] .= 0
    result[:, 1] = 1:Nagents
    for i in 1:Nagents
        for j in 1:Nagents
            i == j && continue
            res = game(agents[i], agents[j], beginning_state)
            result[i, 2] .+= res[1]
            result[j, 2] .+= res[2]
        end
    end

    # result .= sortslices(result, dims = 1, rev = true, by = x -> (x[2], x[1]))
    result .= sortrows(result, rev = true, by = x -> x[2])

    ### selection
    n_sel = Int(round(select * 100))
    idcs = convert.(Int, result[1:n_sel, 1])

    for (idx, i) in enumerate(setdiff(1:Nagents, idcs))
        ### crossover
        ridx = rand(idcs)
        for j in 1:length(params(agents[i]))
            params(agents[i])[j].data .= params(agents[ridx])[j].data
        end

        ### mutation
        for k = 1:Nmutations
            ridx = rand(1:length(params(agents[i])))
            dims = size(params(agents[i])[ridx].data)
            if length(dims) == 2
                params(agents[i])[ridx].data[rand(1:dims[1]), rand(1:dims[2])] = rand() - 0.5
            else
                params(agents[i])[ridx].data[rand(1:dims[1])] = rand() - 0.5
            end
        end
    end
    println(epoch)
    println(result[1:5, 2])
    println(result[1:5, 1])
end

# function evolution_train!(restab, Ngames, Nepochs, game_len, select, Nmutations, beginning_state, input, hidden, output)


# for agent in agents
#     println([maximum(params(agent)[i].data[:]) for i in 1:4])
# end

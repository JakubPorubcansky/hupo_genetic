
for epoch in 1:Nepochs
    result[:, 3] .= 0
    result[:, 2] .= 0
    result[:, 1] = 1:Nagents
    for i in 1:Nagents
        for j in 1:Nagents
            i == j && continue
            res = game(agents[i], agents[j], beginning_state)
            result[i, 2] .+= res[1]
            result[j, 2] .+= res[2]
            result[i, 3] .+= res[1] == winReward ? 1 : 0
            result[j, 3] .+= res[2] == winReward ? 1 : 0
        end
    end

    # result .= sortslices(result, dims = 1, rev = true, by = x -> (x[2], x[1]))
    result .= sortrows(result, rev = true, by = x -> x[2])

    ### selection
    n_sel = Int(round(select * 100))
    idcs = convert.(Int, result[1:n_sel, 1])
    weights = result[1:n_sel, 2] ./ sum(result[1:n_sel, 2])
    items = 1:n_sel

    for (idx, i) in enumerate(setdiff(1:Nagents, idcs))
        ### crossover
        
        # ridx1 = sample(items, Weights(weights))
        # ridx2 = sample(items, Weights(weights))
        #
        # for j in 1:length(params(agents[i]))
        #     if j <= length(params(agents[i])) / 2
        #         params(agents[i])[j].data .= params(agents[ridx1])[j].data
        #     else
        #         params(agents[i])[j].data .= params(agents[ridx2])[j].data
        #     end
        # end

        ridx = sample(items, Weights(weights))
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
    println("NWinPos", result[1:5, 3])
    println("NWin", result[1:5, 2])
    println("Idcs", convert.(Int, result[1:5, 1]))
end

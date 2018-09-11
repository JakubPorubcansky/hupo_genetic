include("tournament.jl")

Nagents = 100
Nepochs = 20
select = 1/3

Nmutations = 5

beginning_state = [3; 2; 1; 2; 3; 2; 3; 2; 5; 2; 3; 2; -1; 2; -1; -1; 1; -1]
# input = 18
# hidden1 = 14
# hidden2 = 14
# output = 4
# agents = [Chain(Dense(input, hidden1, relu), Dense(hidden1, hidden2, relu), Dense(hidden2, output, relu)) for _ in 1:Nagents]
# for a in agents
#     params(a)[2].data .= rand(hidden1) .- 0.5
#     params(a)[4].data .= rand(hidden2) .- 0.5
#     params(a)[6].data .= rand(output) .- 0.5
# end
# result = zeros(Nagents, 3)

input = 18
hidden = 14
output = 4
agents = [Chain(Dense(input, hidden, relu), Dense(hidden, output, relu)) for _ in 1:Nagents]
for a in agents
    params(a)[2].data .= rand(hidden) .- 0.5
    params(a)[4].data .= rand(output) .- 0.5
end
result = zeros(Nagents, 2)

include("oneNetVSRand.jl")

Nagents = 100
Ngames = 50
Nepochs = 20
game_len = 10
select = 1/3

Nmutations = 2

beginning_state = [3; 2; 1; 2; 3; 2; 3; 2; 5; 2; 3; 2; -1; 2; -1; -1; 1; -1]
input = 18
hidden = 14
output = 4
agents = [Chain(Dense(input, hidden, relu), Dense(hidden, output, relu)) for _ in 1:Nagents]
for a in agents
    params(a)[2].data .= rand(hidden) .- 0.5
    params(a)[4].data .= rand(output) .- 0.5
end
result = zeros(Nagents, 3)

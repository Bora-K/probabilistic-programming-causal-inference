using DrWatson
@quickactivate "Master Thesis"
using DataFrames
using GLM

function coinflip(n::Int)
    """Does an n number of coinflips. 
    Input: Integer
    Output: Two arrays. First one is the coinflips. Second one gives 1 if any of the coinflips are heads (1), 0 otherwise."""
    flips = []
    outcome = []
    for i in range(1, n) 
        coin1 = rand((0,1))
        coin2 = rand((0,1))
        push!(flips, (coin1, coin2))
        if coin1 == 1 || coin2 == 1
            append!(outcome, 1)
        else
            append!(outcome, 0)
        end 
    end
    return flips, outcome
end

a, b = coinflip(100000)
cf_df = DataFrame(coins=a, if_heads=b)
only_heads = filter(row -> row.if_heads == 1, cf_df)
coinflips_head = DataFrame(coin1=map(x -> getindex(x, 1), only_heads.coins), coin2=map(x -> getindex(x, 2), only_heads.coins))
coinflips_all = DataFrame(coin1=map(x -> getindex(x, 1), cf_df.coins), coin2=map(x -> getindex(x, 2), cf_df.coins))
fm = @formula(coin2 ~ coin1)
# Once you stratify the dataset for for if_heads the logistic regression model thinks that there is an association between the coinflips.
# On the non_stratified one the model it only gives ~0.5
logreg_heads = glm(fm, coinflips_head, Binomial())
logreg_all = glm(fm, coinflips_all, Binomial())
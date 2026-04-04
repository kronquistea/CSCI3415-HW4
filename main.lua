local wordPattern = "[^,]*,"
local scorePattern = ",.*,"

local f = assert(io.open("socialsent.csv", "r"))
local wordsAndScores = {}

for line in f:lines() do
    local i, j = string.find(line, wordPattern)
    local word = string.sub(line, i, j-1)
    local k, x = string.find(line, scorePattern)
    local score = string.sub(line, k+1, x-2)
    print(word, score)
    wordsAndScores[word] = score
end

f:close()
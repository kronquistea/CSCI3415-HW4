local f = assert(io.open("socialsent.csv", "r"))
local t = f:read("*line")
t = f:read("*line")
f:close()

local wordPattern = ".*,"
local scorePattern = ",.+,"
i, j = string.find(t, wordPattern)
local word = 

print(t)
print(#t)
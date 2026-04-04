-- Create global empty table to store parsed "words" and "scores"
SocialSentimentScores = {}

-- Function that builds the SocialSentimentScores table from the socialsent.csv file
function buildSocialSentimentTable(filename)
    -- Create pattern to match "words" starting with any character other than a comma, then "ending" with a comma
    local wordPattern = "[^,]*,"

    -- Create pattern to match "scores" starting with a command, then any number of characters then ending with a comma
    local scorePattern = ",.*,"

    -- Open social score file in read mode
    local f = assert(io.open(filename, "r"))

    -- Loop through each line in the file 
    for line in f:lines() do
        -- Get starting and ending index of part of line that fulfills the word pattern (inclusive)
        local i, j = string.find(line, wordPattern)
        -- Get the substring of the word without ending comma and save it to "word" variable
        local word = string.sub(line, i, j-1)

        -- Get starting and ending index of part of line that fulfills the score pattern (inclusive)
        local k, x = string.find(line, scorePattern)
        -- Get the substring of the score without starting command and two ending commas and save it to "score" variable
        local score = string.sub(line, k+1, x-2)

        -- print(word, score)

        -- Store key (word) and value (score) in the wordsAndScores table (as a map)
        SocialSentimentScores[word] = score
    end

    -- Close to the file for best practice
    f:close()
end

-- Function that takes the input file and generates a social sent score based on the SocialSentimentScores table
function getSocialSentimentScore(filename)

end

-- Function that generates the star rating for 
function getStarRating()

end
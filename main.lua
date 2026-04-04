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

    -- Read and discard the first line of the file (stanford link stuff)
    print("Removing: ", f:read())

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
    -- Open file to analyze for scores
    local f = assert(io.open(filename, "r"))

    local t = f:read("*all")

    -- Pattern to match at least one alphanumeric character
    local wordPattern = "%w+"

    -- Index for starting pattern matching from
    local startPatternIndex = 1

    -- Loop control counter
    local i = 1
    -- Loop through entire "file" (text string), singling out all words and putting them into a table (as an array)
    while i ~= #t do
        -- Find a word (or number) starting from index i in the string
        local j, k = string.find(t, wordPattern, startPatternIndex)
        print("i, j: ", j, k)
        
        -- Create empty string to be populated as substring from text file
        local word = ""
        -- Make sure i is populated (not nil)
        if j then
            -- Set word variable to be substring of text file according to matched pattern
            word = string.sub(t, j, k)
        end

        -- Make sure k is populated (not nil)
        if k then
            -- Set starting index for pattern searching to end of current word/number found + 1 (next character)
            startPatternIndex = k + 1

            -- Set i (while loop control counter) to character after k
            i = k + 1
        -- If k was not a number (meaning no pattern was found), increment i
        else
            -- Increment i
            i = i + 1
        end

        print("Word: ", word, "\n")
    end
end

-- Function that generates the star rating for 
function getStarRating()

end

buildSocialSentimentTable("socialsent.csv")

getSocialSentimentScore("good.txt")
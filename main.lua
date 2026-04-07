-- Global variable as dictionary to store parsed "words" and "scores"
local gSocialSentimentScores = {}

-- Glocal variable to store social sent score of a given file
local gAccumulatedSocialSentScore = 0

-- Global variable to store start rating based on social sent score of given file
local gStarRating = 0

-- Global variables to store total word count from input file
local gTotalWordCount = 0

-- Global variable to store number of words with scores found
local gWordsWithScoresFound = 0

-- Function that builds the SocialSentimentScores table from the socialsent.csv file
function buildSocialSentimentTable(filename)
    -- Create pattern to match "words" starting with any character other than a comma, then "ending" with a comma
    local wordPattern = "[^,]*,"

    -- Create pattern to match "scores" starting with a command, then any number of characters then ending with a comma
    local scorePattern = ",.*,"

    -- Open social score file in read mode
    local f = assert(io.open(filename, "r"))

    -- Read and discard the first line of the file (stanford link stuff)
    print(string.format("Removing: %s", f:read()))
    print()

    -- Loop through each line in the file 
    for line in f:lines() do
        -- Get starting and ending index of part of line that fulfills the word pattern (inclusive)
        local i, j = string.find(line, wordPattern)
        -- Get the substring of the word without ending comma and save it to "word" variable
        local word = ""
        -- Make sure the string.find function returned an index
        if i ~= nil then
            word = string.sub(line, i, j-1)
        end
        
        -- Get starting and ending index of part of line that fulfills the score pattern (inclusive)
        local k, x = string.find(line, scorePattern)
        -- Get the substring of the score without starting command and two ending commas and save it to "score" variable
        local score = ""
        -- Make sure the string.find function returned an index
        if k ~= nil then
            score = string.sub(line, k+1, x-2)
        end

        -- print(word, score)

        -- Store key (word) and value (score) in the wordsAndScores table (as a dictionary)
        gSocialSentimentScores[word] = score
    end

    -- Close to the file for best practice
    f:close()
end

-- Function that takes the input file and generates a social sent score based on the SocialSentimentScores table
function getSocialSentimentScore(inputfile)
    -- Populate the scores for the words from the given input file
    -- print("Generate Word Scores")
    -- local wordsAndOccurrences = generateWordScores(inputfile)
    -- print()

    print("Generating Word Scores")
    local wordsAndOccurrences = generateWordScoresgMatch(inputfile)
    print()

    -- Calculate the social sent score for the given input file
    print("Calculate Social Sentiment Score")
    local socialSentScore = calculateSocialSentimentScore(wordsAndOccurrences, inputfile)

    -- Assign global variable
    gAccumulatedSocialSentScore = socialSentScore
end

-- Function that generates scores for words based on SocialSentimentScores table
function generateWordScores(inputfile)
    -- Open file to analyze for scores
    local f = assert(io.open(inputfile, "r"))

    -- Read entire file and set to string variable t
    local t = f:read("*all")

    -- Table containing words and the number of occurrences for that word <word, occurrences>
    local wordsAndOccurrences = {}

    -- Pattern to match at strings with alphanumeric characters, apostrophes and right-side single quotes
    local wordPattern = "[%w'‘’]+"

    -- Index for starting pattern matching from
    local startPatternIndex = 1

    -- Loop control counter
    local i = 1
    -- Loop through entire "file" (text string), singling out all words and putting them into a table (as an array)
    while i ~= #t do
        -- Find a word (or number) starting from index i in the string
        local j, k = string.find(t, wordPattern, startPatternIndex)

        -- print("i, j: ", j, k)
        
        -- Create empty string to be populated as substring from text file
        local word = ""
        -- If j is populated (starting index was found) set word variable to substring from text "t"
        if j then
            -- Set word variable to be substring of text file according to matched pattern
            word = string.sub(t, j, k)

            -- Convert word to lowercase to ensure all words are matched properly with global SocialSentimentScores table
            word = string.lower(word)
        end

        -- If k is populated (ending index was found) set new starting pattern index and increment i
        if k then
            -- Set starting index for pattern searching to end of current word/number found + 1 (next character)
            startPatternIndex = k + 1

            -- Set i (while loop control counter) to character after k
            i = k + 1

            -- If the word has a score, add the word and score to the list of wordsAndScores, otherwise skip the word,
            -- For example, the word "this" has no score in the socialsent.csv file
            if gSocialSentimentScores[word] then
                -- If the number of occurrences is at least one (meaning not nil) then increment the number of occurrences for the word
                -- wordsAndScores[word] will initally be nil (which results in false) until the else statement is executed
                if wordsAndOccurrences[word] then
                    -- Increment value for the word
                    wordsAndOccurrences[word] = wordsAndOccurrences[word] + 1
                else
                    -- Set the number of occurrences for the word to 1 (first occurrence of word was found)
                    wordsAndOccurrences[word] = 1
                end

                -- Increment the number of words with scores found (for end of output file purposes)
                gWordsWithScoresFound = gWordsWithScoresFound + 1
            end

            -- Increment the number of total words found (with or without scores) (for end of output file purposes)
            gTotalWordCount = gTotalWordCount + 1
        -- If k was not a number (meaning no pattern was found), increment i
        else
            -- Increment i
            i = i + 1
        end
    end

    -- Return dictionary containing words from text file and number of occurrences
    return wordsAndOccurrences
end

function generateWordScoresgMatch(inputfile)
    -- Open input file in read mode
    local f = assert(io.open(inputfile, "r"))

    -- Read the entire input file as one big string
    local t = f:read("*all")

    -- Dictionary to store a word and how many times it occurred in the input text file
    local wordsAndOccurrences = {}

    -- Loop through each word in the input text file finding all "words" with numbers, letters, apostrophes, single quotes (left and right) 
    for word in string.gmatch(t, "[%d%a'‘’]+") do
        -- Set word to lowercase because all words in socialsent.csv are in lowercase
        word = string.lower(word)

        -- If the found word has a score in the social sentiment table then process the wordsAndOccurrences dictionary
        if gSocialSentimentScores[word] then
            -- If the word (which has a known corresponding score) has not yet been found, set the number of occurrences to 1
            if wordsAndOccurrences[word] == nil then
                -- Set number of occurrences to 1
                wordsAndOccurrences[word] = 1
            -- if the word (which has a known corresponding score) has been found fore, increment the number of occurrences
            else
                wordsAndOccurrences[word] = wordsAndOccurrences[word] + 1
            end

            -- Increment number of words found that also have a score for file writing purposes
            gWordsWithScoresFound = gWordsWithScoresFound + 1
        end

        -- Increment total word count for file writing purposes
        gTotalWordCount = gTotalWordCount + 1
    end

    -- Return words and occurrences dictionary
    return wordsAndOccurrences
end

-- Function that calculated the actual sentiment score the input file
function calculateSocialSentimentScore(wordsAndOccurrences, inputfile)
    -- Create output file with "output_" concatenated to front of filename
    local outputfile = "output_"..inputfile
    local f = assert(io.open(outputfile, "w"))

    -- Variable to store total sentiment score
    local totalSentimentScore = 0

    -- Print and write to output file the format for output
    print("[word: word_score, accumulated_score]")
    f:write("[word: word_score, accumulated_score]\n")
    
    for word, occurences in pairs(wordsAndOccurrences) do
        -- If the number of occurrences for the word is at least 1, process the score
        while occurences > 0 do
            -- Add sentiment score based on previous sentiment score and score of the word
            totalSentimentScore = totalSentimentScore + gSocialSentimentScores[word]

            -- Decrement the number of occurrences for the word
            occurences = occurences - 1

            -- Create formatted string to print and save to output file
            local formattedString = string.format("%s: %.2f, %.2f", word, gSocialSentimentScores[word], totalSentimentScore)
            print(formattedString)
            f:write(formattedString, "\n")
        end
    end

    -- Close the output file
    f:close()

    return totalSentimentScore
end

-- Function that generates the star rating for 
function getStarRating()
    -- Variable to store star rating
    local starRating = 0

    -- Variable to avoid constantly referencing global variable
    local socialSentScore = gAccumulatedSocialSentScore

    -- Exact star ranking scale provided by HW4 instructions
    -- There is no Lua switch/case statement so if-elseif-else is my easiest implementation option
    if socialSentScore < -5 then
        starRating = 1
    elseif socialSentScore >= -5 and socialSentScore < -1 then
        starRating = 2
    elseif socialSentScore >= -1 and socialSentScore < 1 then
        starRating = 3
    elseif socialSentScore >= 1 and socialSentScore < 5 then
        starRating = 4
    else
        starRating = 5
    end

    -- Set global star rating to calcualted local star rating
    gStarRating = starRating
end

function outputAnalysisDetails(inputfile)
    -- Formatted score variable
    local formattedScore = string.format("%s score: %.2f", inputfile, gAccumulatedSocialSentScore)
    -- Formatter rating variable
    local formattedRating = string.format("%s Stars: %d", inputfile, gStarRating)

    -- Print final score and star rating
    print()
    print(formattedScore)
    print(formattedRating, "\n")

    -- Create output file
    local outputFilename = "output_"..inputfile

    -- Open output file
    local f = assert(io.open(outputFilename, "a"))

    -- Write summary (score and rating) to output file
    f:write("\n", formattedScore, "\n")
    f:write(formattedRating, "\n")

    -- Write total word count and total words w/ scores count to the output file
    f:write(string.format("Total Word Count: %s\n", gTotalWordCount))
    f:write(string.format("Words With Known Scores Found Count: %s", gWordsWithScoresFound))

    -- Calculate the percentage of words that had ratings and write that to the output file
    local percentageOfWordsWithScoresFound = (gWordsWithScoresFound / gTotalWordCount) * 100
    f:write(string.format("\nPercent Words w/ Scores Found: %.2f", percentageOfWordsWithScoresFound))

    -- Close output file
    f:close()
end

function checkArgsAndGetInputfile()
    -- if the user provided an input file to analyze, return it
    if arg[1] then
        return arg[1]
    -- If the user did not provide a file to analyze, return NoveReview.txt
    else
        return "NovelReview.txt"
    end
end

-- Main function to handle program start
function main()
    -- Local variable to store input filename
    local inputfile = checkArgsAndGetInputfile()

    -- Build the social sentiment table baesd on "socialsent.csv"
    buildSocialSentimentTable("socialsent.csv")

    -- Get the social sentiment score based on user input file
    getSocialSentimentScore(inputfile)

    -- Get the star rating based on the social sentiment score for the input file
    getStarRating()

    -- Print and write the analysis details to the CLI and to a generated output file
    outputAnalysisDetails(inputfile)
end

main()
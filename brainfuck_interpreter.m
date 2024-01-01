% Brayden Jonsson, January 2024
function exitcode = brainfuck_interpreter(filename)
fileID = fopen(filename, 'r');
instructions = fscanf(fileID, '%c');

array = zeros(1,30000);
dataPointer = 1;
instructionPointer = 1;
instructionCount = size(instructions, 2);
loopStarts = zeros(1,30000);
currentLoop = 0;

while instructionPointer <= instructionCount
    switch instructions(instructionPointer)
        case '>'
            dataPointer = dataPointer + 1;
            if dataPointer > 30000
                fprintf("Array Bounds Exceeded!")
                exitcode = -1;
                return
            end
            instructionPointer = instructionPointer + 1;
        case '<'
            dataPointer = dataPointer - 1;
            if dataPointer < 1
                fprintf("Array Bounds Exceeded!")
                exitcode = -1;
                return
            end
            instructionPointer = instructionPointer + 1;
        case '.'
            fprintf(char(array(dataPointer)))
            instructionPointer = instructionPointer + 1;
        case ','
            charInput = input();
            cleanedInput = mod(double(charInput(1)), 256);
            array(dataPointer) = cleanedInput;
            instructionPointer = instructionPointer + 1;
        case '+'
            array(dataPointer) = mod(array(dataPointer) + 1, 256);
            instructionPointer = instructionPointer + 1;
        case '-'
            array(dataPointer) = mod(array(dataPointer) - 1, 256);
            instructionPointer = instructionPointer + 1;
        case '['
            if array(dataPointer) == 0
                openBracketCounter = 0;
                instructionPointer = instructionPointer + 1;
                while instructionPointer <= instructionCount
                    if openBracketCounter == 0 && instructions(instructionPointer) == ']'
                        break;
                    elseif instructions(instructionPointer) == ']'
                        openBracketCounter = openBracketCounter - 1;
                    elseif instructions(instructionPointer) == '['
                        openBracketCounter = openBracketCounter + 1;
                    end
                    instructionPointer = instructionPointer + 1;
                end
                if instructions(instructionPointer) ~= ']' || openBracketCounter ~= 0
                    fprintf("Missing closing loop bracket!")
                    exitcode = -2;
                    return
                end
                instructionPointer = instructionPointer + 1;
            else
                currentLoop = currentLoop + 1;
                loopStarts(currentLoop) = instructionPointer;
                instructionPointer = instructionPointer + 1;
            end
        case ']'
            if currentLoop == 0
                fprintf("Missing opening loop bracket!")
                exitcode = -3;
                return
            end
            loopStart = loopStarts(currentLoop);
            currentLoop = currentLoop - 1;
            if array(dataPointer) == 0
                instructionPointer = instructionPointer + 1;
            else
                instructionPointer = loopStart;
            end
        otherwise
            instructionPointer = instructionPointer + 1;
    end
end
if currentLoop ~= 0
    fprintf("Missing closing loop bracket!")
    exitcode = -2;
    return
end
exitcode = 0;
end
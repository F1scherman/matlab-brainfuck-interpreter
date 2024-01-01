% Brayden Jonsson, January 2024
function exitcode = brainfuck_interpreter(filename)
fileID = fopen(filename, 'r');
instructions = fscanf(fileID, '%c');

array = zeros(1,30000);
dataPointer = 1;
instructionPointer = 1;
instructionCount = size(instructions, 2);
loopStart = -1;

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
                while instructionPointer <= instructionCount
                    if instructions(instructionPointer) == ']'
                        break;
                    end
                    instructionPointer = instructionPointer + 1;
                end
                if instructions(instructionPointer) ~= ']'
                    fprintf("Missing closing loop bracket!")
                    exitcode = -2;
                    return
                end
            else
                loopStart = instructionPointer;
                instructionPointer = instructionPointer + 1;
            end
        case ']'
            if loopStart == -1
                fprintf("Missing opening loop bracket!")
                exitcode = -3;
                return
            end
            if array(dataPointer) == 0
                loopStart = -1;
                instructionPointer = instructionPointer + 1;
            else
                instructionPointer = loopStart;
            end
        otherwise
            instructionPointer = instructionPointer + 1;
    end
end
if loopStart ~= -1
    fprintf("Missing closing loop bracket!")
    exitcode = -1;
    return
end
exitcode = 0;
end
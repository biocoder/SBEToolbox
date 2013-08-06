function lineParts = splitSentence(line)
lineParts = regexpi(line, '\|', 'split');
for n = 1:size(lineParts, 2)
    lineParts{n} = char(lineParts{n});
end
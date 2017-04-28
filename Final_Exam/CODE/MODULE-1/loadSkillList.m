function skillslist = loadskillList()
%Function reads the fixed skills list in Skills_List.txt and returns a
%cell array of the words
%   skillslist = loadskillList() reads the fixed skills list in Skills_List.txt
%   and returns a cell array of the words in skillslist.


%% Read the fixed skills list
fid = fopen('Skills_List.txt');


n = 10;  % Total number of skills 

skillslist = cell(n, 1);
for i = 1:n
    % Read line
    line = fgets(fid);
    [idx, skillName] = strtok(line, ' ');
    % Actual Word
    skillslist{i} = strtrim(skillName);
end
fclose(fid);

end

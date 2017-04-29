function skillList = loadSkillsList()
fid = fopen('skills_data.txt');


n = 10;  % Number of skills 

skillList = cell(n, 1);
for i = 1:n
    % Read line
    line = fgets(fid);
    % Word Index (can ignore since it will be = i)
    [idx, skillname] = strtok(line, ' ');
    % Actual Word
    skillList{i} = strtrim(skillname);
end
fclose(fid);

end

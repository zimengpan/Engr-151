function [path1, ColonyGrid] = bugPathPlanner(ObstacleGrid,Start,Goal)
    path1 = Start;
    s = length(ObstacleGrid);
    
    if isOut(s,Start)
        return;
    end
    
    ColonyGrid = ObstacleGrid;
    ColonyGrid(Start(1),Start(2)) = 2;
    ColonyGrid(Goal(1),Goal(2)) = 3;
    dis = Goal-Start == 0;
    
    while sum(dis) ~= 2     
        Past = Start;
        d = Goal - Start;
        angle = -d(1)/d(2);
        % Decide the direction of the next move
        if angle >= tan(0.125*pi) && angle < tan(0.375*pi) && d(1) < 0
            Start = [Start(1)-1 Start(2)+1];
        elseif (angle >= tan(0.375*pi) || angle < tan(0.625*pi)) && d(1) < 0
            Start = [Start(1)-1 Start(2)];
        elseif angle >= tan(0.625*pi) && angle < tan(0.875*pi) && d(1) < 0
            Start = Start - 1;
        elseif angle >= tan(0.875*pi) && angle < tan(1.125*pi) && d(2) < 0
            Start = [Start(1) Start(2)-1];
        elseif angle >= tan(1.125*pi) && angle < tan(1.375*pi)
            Start = [Start(1)+1 Start(2)-1];
        elseif angle >= tan(1.375*pi) || angle < tan(1.625*pi)
            Start = [Start(1)+1 Start(2)];
        elseif angle >= tan(1.625*pi) && angle < tan(1.875*pi)
            Start = Start + 1;
        elseif angle >= tan(1.875*pi) && angle < tan(0.125*pi)
            Start = [Start(1) Start(2)+1];
        end
        
        
        if isOut(s,Start)
            path1 = [path1;-2 -2];
            break
        end
        
        if ColonyGrid(Start(1),Start(2)) == 0
            % If the next move is clear, move to the next move
            path1 = [path1;Start];
            ColonyGrid(Start(1),Start(2)) = 4;
        elseif ColonyGrid(Start(1),Start(2)) == 2
            path1 = [path1;Start;-1 -1];
            break;
        elseif ColonyGrid(Start(1),Start(2)) == 4
            path1 = [path1;Start;-1 -1];
            break;
        elseif ColonyGrid(Start(1),Start(2)) == 3
            % If the next move is the terminal, stop and return
            path1 = [path1;Goal];
            break;          
        elseif ColonyGrid(Start(1),Start(2)) == 1
            % If the next move is obstacle, rotate the vector
            % counterclockwisely until a valid move
            try 
                while ColonyGrid(Start(1),Start(2)) == 1                   
                    Start = rotate(Past,Start);
                end
                if ColonyGrid(Start(1),Start(2)) == 4 || ColonyGrid(Start(1),Start(2)) == 2
                    % If the next move is the last move
                    path1 = [path1;Start;[-1 -1]];
                    break;
                else
                    % If the next move is clear
                    path1 = [path1;Start];
                    ColonyGrid(Start(1),Start(2)) = 4;
                end
            catch
                path1 = [path1;[-2 -2]];
                break;
            end
        end
    end
    
        function r = rotate(past,new)
        % Rotate the new vector counterclockwise
        t = new - past;
        if t(1) == 1 && t(2) == 1
            r = [past(1) past(2)+1];
        elseif t(1) == 1 && t(2) == 0
            r = past + 1;
        elseif t(1) == 1 && t(2) == -1
            r = [past(1)+1 past(2)];
        elseif t(1) == 0 && t(2) == -1
            r = [past(1)+1 past(2)-1];
        elseif t(1) == -1 && t(2) == -1
            r = [past(1) past(2)-1];
        elseif t(1) == -1 && t(2) == 0
            r = [past(1)-1 past(2)-1];
        elseif t(1) == -1 && t(2) == 1
            r = [past(1)-1 past(2)];
        elseif t(1) == 0 && t(2) == 1
            r = [past(1)-1 past(2)+1];
        end
    end

    function v = isOut(s, Start)
        % Identify if the vector is out of bound
        if Start(1) > s || Start(2) > s || Start(1) < 1 || Start(2) < 1
            v = 1;
        else
            v = 0;
        end
    end
end
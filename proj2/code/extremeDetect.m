 % detect extremes
    function YesOrNo = extremeDetect(octave, interval, x, y)
        value = octave(x,y,interval);
        neighbour = octave(x-1:x+1, y-1:y+1, interval-1: interval+1);
        if value == max(neighbour(:)) && value > 0
            YesOrNo = 1;
        elseif value == min(neighbour(:))
            YesOrNo = 1;
        else
            YesOrNo = 0;
        end
    end
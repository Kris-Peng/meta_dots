function dispVideo = playVideo(p,vIndx)


DrawText(p.frame.ptr,{'You are about to watch a clip. Please watch the entirety of the clip.',' ',...
    'Please let the experimenter know if you experience any issues with viewing the clip.',' ',...
    'Press space to start watching.'},'c');
Screen('Flip', p.frame.ptr);
WaitSecs(2);
WaitAnyPress(KbName('space'));

try  
    if p.condition{1} == '1'
        moviename = append('C:\Users\burne\Downloads\meta_dots-master\Videos\PositiveVideo\', ...
            int2str(vIndx(1)),'.mp4');
    elseif p.condition{1} == '2'
        moviename = append('C:\Users\burne\Downloads\meta_dots-master\Videos\NeutralVideo\', ...
            int2str(vIndx(1)),'.mp4');
    elseif p.condition{1} == '3'
        moviename = append('C:\Users\burne\Downloads\meta_dots-master\Videos\NegativeVideo\', ...
            int2str(vIndx(1)),'.mp4');
    end

%     moviename = 'C:\Users\burne\Downloads\meta_dots-master\Videos\NegativeVideo\1.mp4';
    movie = Screen('OpenMovie', p.frame.ptr, moviename);
    % Start playback engine:
    Screen('PlayMovie', movie, 1);
    tex = 1;
    % Playback loop: Runs until end of movie or keypress:
    while tex>0
        % Wait for next movie frame, retrieve texture handle to it
        tex = Screen('GetMovieImage', p.frame.ptr, movie);
        % Valid texture returned? A negative value means end of movie reached:
        if tex<=0
            % We're done, break out of loop:
            break;
        end
        % Draw the new texture immediately to screen:
        Screen('DrawTexture', p.frame.ptr, tex);
        % Update display:
        Screen('Flip', p.frame.ptr);
        % Release texture:
        Screen('Close', tex);
    end
    % Stop playback:
    Screen('PlayMovie', movie, 0);
    % Close movie:
    Screen('CloseMovie', movie);
catch %#ok<CTCH>
    sca;
    psychrethrow(psychlasterror);
end
WaitSecs(1);


[feeling RT] = collectConfidence(p.frame.ptr,p);
dispVideo.vFeeling = feeling;
WaitSecs(1);
[intensity RT] = collectConfidence(p.frame.ptr,p);
dispVideo.vIntensity = intensity;

DrawText(p.frame.ptr,{'Please press space bar to continue the experiment.'},'c');
Screen('Flip', p.frame.ptr);
WaitSecs(1);
WaitAnyPress(KbName('space'));

end
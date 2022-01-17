 function perceptWrapper
% Dots task for perceptual metacognition
% Sebastien Massoni, modified by SF 2013

clear all
clc
addpath('mypsychtoolbox')
%addpath('C:\toolbox\Psychtoolbox')
KbName('UnifyKeyNames');
PsychJavaTrouble()
%% Parameters
p = perceptGetParams;
Screen('TextSize',p.frame.ptr,24);

HideCursor;  
%% Introduct ion
DrawText(p.frame.ptr,{'Welcome to this experiment!',' ',...
    'Press space bar to find out what the task involves!'},'c');
Screen('Flip', p.frame.ptr);
WaitSecs(0.5);
WaitAnyPress(KbName('space'));

%% Example stimul i 

% DrawText(p.frame.ptr,{'You will see two circles on the screen',' ',...
%     'each with a number of dots inside.',' ',...
%     'Your task is to try to guess which circle contains the most points.',' ',...
%     'Then we will ask you to rate your confidence in your decision.',' ', ...
%     'Please press the space bar to continue'},'c');
% Screen('Flip', p.frame.ptr);
% WaitSecs(2);
% WaitAnyPress(KbName('space'));
% 
% DrawText(p.frame.ptr,'Here are some example stimuli', 'c');
% Screen('Flip', p.frame.ptr);
% WaitSecs(1.0);
% 
% n=[40 60];
% drawDots(p, n);
% DrawFormattedText(p.frame.ptr,'40 vs 60', 'center', p.my+p.stim.diam+50);
% t=Screen('Flip', p.frame.ptr);
% WaitSecs(3);
% 
% n=[50 30];
% drawDots(p, n);
% DrawFormattedText(p.frame.ptr,'50 vs 30', 'center', p.my+p.stim.diam+50);
% t=Screen('Flip', p.frame.ptr);
% WaitSecs(3);
% 
% n=[53 58];
% drawDots(p, n);
% DrawFormattedText(p.frame.ptr,'53 vs 58', 'center', p.my+p.stim.diam+50);
% t=Screen('Flip', p.frame.ptr);
% WaitSecs(3);
% 
% n=[35 25];
% drawDots(p, n);
% DrawFormattedText(p.frame.ptr,'35 vs 25', 'center', p.my+p.stim.diam+50);
% t=Screen('Flip', p.frame.ptr);
% WaitSecs(3);


% generate video sequence
vIndex=[1,2,3,4,5];
vIndx=randperm(length(vIndex));
% store sequence
vResults.sequence = vIndx;
% play video
dispVideo = playVideo(p,vIndx);
vIndx(1)=[];
vResults.vFeeling = dispVideo.vFeeling;
vResults.vIntensity = dispVideo.vIntensity;


Screen('TextSize',p.frame.ptr,24);
DrawText(p.frame.ptr,{'The first part of the task is to choose',' ',...
    'which circle contains the most points.',' ',...
    'We will next familiarise you with this part of the task.',' ', ...
    'Don''t worry if some of your decisions feel like guesses - it is a hard task!', ...
    ' ','Press the space bar to continue'},'c');
Screen('Flip',p.frame.ptr);
WaitSecs(2);
WaitAnyPress(KbName('space'));

%remember to delete this
%Screen('Closeall')

DrawText(p.frame.ptr,{'Training!',' ',' ','(Press space to start)'},'c');
Screen('Flip', p.frame.ptr);
WaitSecs(0.5);
WaitAnyPress(KbName('space')); 

Screen('FrameOval',p.frame.ptr,p.white,p.stim.rectL,p.stim.pen_width);
Screen('FrameOval',p.frame.ptr,p.white,p.stim.rectR,p.stim.pen_width);
t=Screen('Flip', p.frame.ptr);

% Training on task, no confidence rating
%put into function with arguments feedback, confidence,
%converge or continuous 

index=[1,2,3,4,5,6,7,8,9,10,11,12,13];
indx=randperm(length(index));

feedback = 1;
conf = 0;
ntrials = Inf;  
staircase_reversal = 8;
stepsize = 4;
adapt  = 1;
start_x = round(.5*p.stim.REF); % start at REF+50%REF
phase = 0;
rng(0,'twister');
results = perceptRunBlock(p, feedback, conf, ntrials, staircase_reversal, stepsize, adapt, start_x, phase,indx);
xc=median(results.contrast(results.i_trial_lastreversal:end)); % contrast at end of block

%% Training on task with confidence rating
DrawFormattedText(p.frame.ptr, ['We will now give you some practice at using the confidence scale. \n\n After you make a left/right choice,\n' ...
    'you will see a sliding scale to allow you to rate your confidence in getting the right answer.\n\n'...
    'You can move the cursor around on the scale using the left and right arrow keys\n'...
    'The left end of the scale means that you are less confident than normal, and\n'...
    'the right end of the scale means that you are more confident than normal.\n\n'...
    'However, please remember that this is a difficult task - it`s rare that you will be very confident!\n'...
    'As we are interested in relative changes in confidence, we encourage you to use the whole scale.\n\n' ...
    'There won''t be any more feedback as to whether you are right or wrong!\n\n' ...
    '(Press space bar to continue)'], 'center', 'center');
Screen('Flip', p.frame.ptr);
WaitSecs(0.5);
WaitAnyPress(KbName('space'));

feedback = 0;
conf = 1;
ntrials = 4;
staircase_reversal = Inf;
start_x = xc;
stepsize = 1;
adapt = 0;
phase = 0;
results = perceptRunBlock(p, feedback, conf, ntrials, staircase_reversal, stepsize, adapt, start_x, phase,indx);

% Main task blocks (4 blocks of 30 trials)
DrawFormattedText(p.frame.ptr, ['We will now ask you to do 4 blocks of 30 trials each, just like in the practice \n\n' ...
    'Please ask the experimenter to start the task! \n\n'], 'center', 'center');
Screen('Flip', p.frame.ptr);
WaitSecs(0.5);
WaitAnyPress(KbName('y'));
nblocks = 4;
feedback = 0;
conf = 1; 
ntrials = 10;
staircase_reversal = Inf;
stepsize = 1;
adapt = 0;
for b = 1:nblocks
    if isempty(vIndx) == 0
        dispVideo = playVideo(p,vIndx);
        vIndx(1)=[];
        vResults.vFeeling = [vResults.vFeeling, dispVideo.vFeeling];
        vResults.vIntensity = [vResults.vIntensity, dispVideo.vIntensity];
    end
    start_x = xc;
    phase = 1;
    results = perceptRunBlock(p, feedback, conf, ntrials, staircase_reversal, stepsize, adapt, start_x, phase,indx);
    xc=round(median(results.contrast(results.i_trial_lastreversal:end))); % contrast at end of block
    indx = results.indx;
    if b<nblocks
        DrawFormattedText(p.frame.ptr, ['The current block is over.', ' ', ...
        'Please ask the experimenter for the next step'], 'center', 'center'); 
        Screen('Flip', p.frame.ptr);
        WaitSecs(0.5);
        WaitAnyPress(KbName('y'));
    else 
        DrawFormattedText(p.frame.ptr, ['The experiment is over.' ...
        'Thank you for your participation! Press the space bar to quit.'], 'center', 'center');
        Screen('Flip', p.frame.ptr);
        WaitSecs(0.5);
        WaitAnyPress(KbName('space'));
    end       
    DATA(b).results = results;
    save(p.filename,'DATA');
end
% Save the data and exit
save([[pwd '\perceptData\'] 'videoResults' p.subID{1}],'vResults')
Screen('Closeall')

a.indx = 5;
a.ans = 3;
a = [a, a];
save([[pwd '\perceptData\'] 'testfile'],'a')
% result.indx = 6;
% result.ans = 4;
% a = [a, result];
% save([[pwd '\perceptData\'] 'testfile'],'a')

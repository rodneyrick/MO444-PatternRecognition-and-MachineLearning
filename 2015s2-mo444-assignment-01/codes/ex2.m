page_output_immediately(1)
more

function save_file (msg)
  filename = "D:\\MO444\\2015s2-mo444-assignment-01\\test.csv";
  fid = fopen(filename, 'a');
  fprintf(fid, '%s', msg);
  fclose(fid);
endfunction

file="D:\\MO444\\2015s2-mo444-assignment-01\\YearPredictionMSD.csv"
#file2000="C:\\Users\\Avell\\Desktop\\MO444B\\YearPredictionMSD_2000.csv"
data = csvread(file,[0,0,100000,91]);

#data = csvread(file);

#nRows =  rows(data); % number of rows
#nSample = 20000; % number of samples
#rndIDX = randi(nRows, nSample, 1); 
#newSample = data(rndIDX, :); 

trainingSize=20000;
testingSize=45000;

# y
y_all=data(1:(trainingSize+testingSize),1);

# x
x_all=data(1:(trainingSize+testingSize),2:91);
x_all=[x_all,x_all.^3];

#number of attributes
nAttr = columns(x_all);

#number of elements
nElem_all = rows(x_all);


#normalizedX
normX_all=x_all;
for i = 1:columns(x_all)
  normX_all(:,i)=(x_all(:,i)-min(x_all(:,i)))/(max(x_all(:,i))-min(x_all(:,i)));
endfor

#normalizedY
yNormalizator = (max(y_all)-min(y_all));
yMin = min(y_all);
normY_all=(y_all-yMin)/yNormalizator;

normY_all=y_all;

####discard bad columns
#x_all=x_all(:,theta<mean(abs(theta)));


#####
y=normY_all(1:trainingSize,:);
x=normX_all(1:trainingSize,:);

yTest=normY_all(trainingSize:(trainingSize+testingSize),:);
xTest=normX_all(trainingSize:(trainingSize+testingSize),:);

nElem=rows(x);

#####



#theta
theta=rand(1,nAttr,1);
theta=2*theta-1;
#theta(1)=1950;
bestTheta=theta;

bestThetaError = inf;

#alpha
alpha=0.04;#0.035#0.005
alphaAlpha=alpha*0.05;

#number of iterations
nIt=30000;


totalErrorHistory=[];
meanErrorHistory=[];

totalErrorHistoryTest=[];
meanErrorHistoryTest=[];

save_file("it,totalErrorTest,totalError,totalErrorHistory,alpha,alphaAlpha,mean_errorTest,mean_error,meanErrorHistory\n");

for it = 1: nIt
  it;

  #predict
  y_=x*transpose(theta);
  
  #calculate error
  error = (y-y_).^2;
  totalError = sum(error)/rows(error);
  
  if totalError<bestThetaError
    bestTheta=theta;
    bestThetaError=totalError;
  endif
  
  
  #update alpha and alphaAlpha
    if columns(totalErrorHistory)>1 
      totalErrorHistory(columns(totalErrorHistory)-1)/totalError;
      if (totalErrorHistory(columns(totalErrorHistory)-1)/totalError)<(1.0+alphaAlpha)
        alpha=alpha*0.9;
        alphaAlpha=alphaAlpha*0.9;
      else
        alpha=alpha*(1+alphaAlpha);
        alphaAlpha=alphaAlpha*(1+alphaAlpha*0.1);
      endif
    endif
    
    #log info
  if mod(it,100)==0
  
          #stop bounce-away
        theta=bestTheta;
        totalError=bestThetaError;
  
    #disp(it)
    #totalError
    totalErrorHistory=[totalErrorHistory,totalError];
    y_result = (y_*yNormalizator)+yMin;
    y_original = (y*yNormalizator)+yMin;
    mean_error = mean(abs(y_result-y_original));
    meanErrorHistory=[meanErrorHistory,mean_error];
    if columns(totalErrorHistory)>1 
      totalErrorHistory(columns(totalErrorHistory)-1)/totalError;
    endif
    
    #test
    yTest_=xTest*transpose(theta);
    errorTest = (yTest-yTest_).^2;
    totalErrorTest = sum(errorTest)/rows(errorTest);
    totalErrorHistoryTest=[totalErrorHistoryTest,totalErrorTest];
    y_resultTest = (yTest_*yNormalizator)+yMin;
    y_originalTest = (yTest*yNormalizator)+yMin;
    mean_errorTest = mean(abs(y_resultTest-y_originalTest));
    meanErrorHistoryTest=[meanErrorHistoryTest,mean_errorTest];
    
    save_file(int2str(it));
    save_file(",");
    save_file(num2str(totalErrorTest));
    save_file(",");
    save_file(num2str(totalError));
    save_file(",");
    save_file(num2str(alpha));
    save_file(",");
    save_file(num2str(alphaAlpha));
    save_file(",");
    save_file(num2str(mean_errorTest));
    save_file(",");
    save_file(num2str(mean_error));
    save_file("\n");
    
  endif
  
  if mod(it,1000)==0
         x=x(:,abs(theta)>(0.01*mean(abs(theta))));
         xTest=xTest(:,abs(theta)>(0.01*mean(abs(theta))));
         theta=theta(:,abs(theta)>(0.01*mean(abs(theta))));
         nAttr=columns(x);
  endif
  
  #improve
  corrector = alpha*(1/nElem)*transpose(x)*(y_-y);
  theta=theta-transpose(corrector);
endfor

y_result = (y_*yNormalizator)+yMin;
y_original = (y*yNormalizator)+yMin;

[y_original,y_result];

csvwrite('D:\\MO444\\2015s2-mo444-assignment-01\\y_original_result.csv', [y_original,y_result]);

final_error = y_result-y_original;
mean_error = mean(abs(final_error))

save_file("final_error,mean_error\n");
save_file(num2str(final_error));
save_file(",");
save_file(num2str(mean_error));
save_file("\n");

###########3

y_original = (y*yNormalizator)+yMin;


theta_exact = (pinv(x'*x))*x'*y;

y_exact=0;
y_exact=((x*theta_exact)*yNormalizator)+yMin;

final_error_exact = (y_exact-y_original);
mean_error_exact = mean(abs(final_error_exact));

save_file("metodo exato\n");
save_file("final_error_exact,mean_error_exact\n");
save_file(num2str(final_error_exact));
save_file(",");
save_file(num2str(mean_error_exact));
save_file("\n");

#test data
y_original_test = (yTest*yNormalizator)+yMin;

y_exact_test=0;
y_exact_test=((xTest*theta_exact)*yNormalizator)+yMin;

final_error_exact_test = (y_exact_test-y_original_test);
mean_error_exact_test = mean(abs(final_error_exact_test));


save_file("metodo exato\n");
save_file("final_error_exact_test,mean_error_exact_test\n");
save_file(num2str(final_error_exact_test));
save_file(",");
save_file(num2str(mean_error_exact_test));
save_file("\n");

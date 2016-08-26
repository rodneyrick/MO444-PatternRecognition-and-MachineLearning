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

# y
y=data(1:10000,1);

# x
x=data(1:10000,2:91);
x=[x,x.^3];

#number of attributes
nAttr = columns(x);

#number of elements
nElem = rows(x);


#normalizedX
normX=x;
for i = 1:columns(x)
  normX(:,i)=(x(:,i)-min(x(:,i)))/(max(x(:,i))-min(x(:,i)));
endfor

#normalizedY
yNormalizator = (max(y)-min(y));
yMin = min(y);
normY=(y-yMin)/yNormalizator;

#####
y=normY;
#####


#theta
theta=rand(1,nAttr,1);
theta=2*theta-1;
#theta(1)=1950;

#alpha
alpha=0.035#0.035#0.005

#number of iterations
nIt=10000;

save_file("it,totalError,alpha,mean_error\n");

totalErrorHistory=[];
meanErrorHistory=[];
for it = 1: nIt
  it;

  #predict
  y_=normX*transpose(theta);
  
  #calculate error
  error = (y-y_).^2;
  totalError = sum(error)/rows(error);
  if mod(it,100)==0
    it
    totalError
    totalErrorHistory=[totalErrorHistory,totalError];
    y_result = (y_*yNormalizator)+yMin;
    y_original = (y*yNormalizator)+yMin;
    mean_error = mean(abs(y_result-y_original))
    meanErrorHistory=[meanErrorHistory,mean_error];
    
    save_file(int2str(it));
    save_file(",");
    save_file(num2str(totalError));
    save_file(",");
    save_file(num2str(alpha));
    save_file(",");
    save_file(num2str(mean_error));
    save_file("\n");
  endif
  
  #improve
  corrector = alpha*(1/nElem)*transpose(normX)*(y_-y);
  theta=theta-transpose(corrector);
endfor

y_result = (y_*yNormalizator)+yMin;
y_original = (y*yNormalizator)+yMin;

[y_original,y_result];

csvwrite('D:\\MO444\\2015s2-mo444-assignment-01\\y_original_result.csv', [y_original,y_result]);

final_error = y_result-y_original;
mean_error = mean(abs(final_error));

save_file("final_error,mean_error\n");
save_file(num2str(final_error));
save_file(",");
save_file(num2str(mean_error));
save_file("\n");

###########3

theta_exact = (pinv(normX'*normX))*normX'*y;

y_exact=0;
y_exact=((normX*theta_exact)*yNormalizator)+yMin;

[y_original,y_exact];

csvwrite('D:\\MO444\\2015s2-mo444-assignment-01\\y_original_exact.csv', [y_original,y_result]);

final_error_exact = (y_exact-y_original)/rows(final_error);
mean_error_exact = mean(abs(final_error_exact));

save_file("metodo exato\n");
save_file("final_error_exact,mean_error_exact\n");
save_file(num2str(final_error_exact));
save_file(",");
save_file(num2str(mean_error_exact));
save_file("\n");

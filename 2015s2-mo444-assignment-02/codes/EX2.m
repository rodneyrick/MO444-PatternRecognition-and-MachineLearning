load "nnet-0.1.13.tar.gz"
more
filename="D:\MO444\2015s2-mo444-assignment-02\\2015s2-mo444-assignment-02.csv";
nRow=50000;
nCol=9;

#load data
raw_data=textread(filename,"%s",nRow,'delimiter','\n');

readErrorCount=0;

#parse data into 9 columns (some preproc is needed)
data=cell(nRow,nCol);
for i=1:length(raw_data)
  if (length(char(raw_data(i,:)))>0)
    split=strsplit(cell2mat(raw_data(i)),",");
    if (length(split)==nCol)
      data(i,:)=split;
    else
      i;
      readErrorCount=readErrorCount+1;
    endif
    
    
  endif
endfor

#entries with too many commas
readErrorCount

#randperm it
data=[data(1,:);data((randperm(length(data)-1)+1),:)];

#remove empty
data(find(cellfun(@isempty,data(:,1))),:)=[];
nRow=length(data);

header=data(1,:)

categoryClasses={"Category"};#2
categoryData=zeros(nRow,1);
categoryCol=2;

dayClasses={"DayOfWeek"};#4
dayData=zeros(nRow,1);
dayCol=4;

pdDistrictClasses={"PdDistrict"};#5
pdDistrictData=zeros(nRow,1);
pdDistrictCol=5;

timeData=zeros(nRow,1);
timeCol=1;

latData=zeros(nRow,1);
latCol=8;
longData=zeros(nRow,1);
longCol=9;

for i=2:nRow#length(data)

  if(mod(i,1000)==0)
	i
  endif
  
  #category
  if (length(char(data(i,categoryCol)))>0)
    category=cell2mat(data(i,categoryCol));
    if max(strcmp(category,categoryClasses))==0
      categoryClasses=cellstr([categoryClasses;category]);
    endif
    
    categoryData(i)=find(strcmp(category,categoryClasses));
    
  endif
  
  #day
  if (length(char(data(i,dayCol)))>0)
  
    day=cell2mat(data(i,dayCol));
    if max(strcmp(day,dayClasses))==0
      dayClasses=cellstr([dayClasses;day]);
    endif
    
    dayData(i)=find(strcmp(day,dayClasses));
    
  endif
  
  #pdDistrict
  if (length(char(data(i,pdDistrictCol)))>0)
  
    pdDistrict=cell2mat(data(i,pdDistrictCol));
    if max(strcmp(pdDistrict,pdDistrictClasses))==0
      pdDistrictClasses=cellstr([pdDistrictClasses;pdDistrict]);
    endif
    
    pdDistrictData(i)=find(strcmp(pdDistrict,pdDistrictClasses));
    
  endif
  
  #time
  if (length(char(data(i,timeCol)))>0)
    timestamp=strsplit(char(data(i,1)),' ');
    time=char(timestamp(2));
    numTime=str2num(char(strsplit(time,':')(1)))*60 + str2num(char(strsplit(time,':')(2)));
    timeData(i)=numTime;
  endif
  
  
  #latitude
  if (length(char(data(i,latCol)))>0)
    latData(i)=str2double(char(data(i,latCol)));  
  endif
  
  #longitude
  if (length(char(data(i,longCol)))>0)
    longData(i)=str2double(char(data(i,longCol)));  
  endif
  
endfor

#desc
descCol=3;
corpus={"Descript"};#3
corpusCount=[1];
  
for i=2:nRow#length(data)

  if(mod(i,1000)==0)
    i
  endif

  ##corpus
  if (length(char(data(i,descCol)))>0)
    words=strsplit(cell2mat(data(i,descCol)));
    
    for j=1:length(words)
      word=cell2mat(words(j));
      
     if(length(char(word))>3)
      
        if max(strcmp(word,corpus))==0
          corpus=cellstr({corpus;word});
          #corpus=cell2mat(corpus);
          corpusCount=[corpusCount 1];
        else
          corpusCount(strcmp(word,corpus))=corpusCount(strcmp(word,corpus))+1;
        endif
        
      endif
      
    endfor
    
   endif
   ##endCorpus
   
endfor

corpusRelevancyFactor=0;#0.0001;
corpusRelevancyThreshold=sum(corpusCount)*corpusRelevancyFactor;#0.0001;#10;

cleanCorpus=corpus(corpusCount>corpusRelevancyThreshold);
cleanCorpusCount=corpusCount(corpusCount>corpusRelevancyThreshold);

corpusMinWordLength=1;#3;


descData=0;
descData=zeros(nRow,length(cleanCorpus));

for i=2:nRow

  if(mod(i,1000)==0)
    i
  endif

  ##corpus
  if (length(char(data(i,descCol)))>0)
   words=strsplit(cell2mat(data(i,descCol)));
    
    for j=1:length(words)
      word=cell2mat(words(j));
      
     if(length(char(word))>corpusMinWordLength)
        wordOnCorpus=strcmp(word,cleanCorpus);
        if max(wordOnCorpus)!=0
          descData(i,wordOnCorpus)=descData(i,wordOnCorpus)+1;
        endif
        
      endif
      
    endfor
    
   endif  


endfor

#present the values
#[char(cleanCorpus),num2str(cleanCorpusCount')]

normDayData=(dayData-min(dayData))/(max(dayData)-min(dayData));
normTimeData=(timeData-min(timeData))/(max(timeData)-min(timeData));
normLatData=(latData-min(latData))/(max(latData)-min(latData));
normLongData=(longData-min(longData))/(max(longData)-min(longData));
normPdDistrictDataData=(pdDistrictData-min(pdDistrictData))/(max(pdDistrictData)-min(pdDistrictData));


x=[normDayData,normTimeData,normLatData,normLongData,normPdDistrictDataData,descData];
xCol=columns(x);

y=zeros(nRow,rows(categoryClasses));

for i=1:rows(categoryClasses)
	y(:,i)=(categoryData==i);
endfor
yCol=columns(y);

###LOGISTIC REGRESSION

function g = sigmoid(z)
%SIGMOID Compute sigmoid functoon
%   J = SIGMOID(z) computes the sigmoid of z.
% z can be a scalar, a vector, or a matrix.
g = zeros(size(z));
g = 1 ./ (1 + exp(-z));
endfunction

meanError=ones(1,yCol);
accuracy=zeros(1,yCol);
m=5000;#5000;#nRow;
mMax=25000;
mTest=25000;
theta=rand(yCol,xCol);
theta=theta';
yIndex=1;
baseAlpha=1000;#256.05;#128.05#64.05;#32.05;#16.05;#8.05;#4.05;#2.05;#1.05#0.505;
alpha=ones(1,yCol)*baseAlpha;
#nTest=5000;

for it=1:500
	it
	J=ones(1,yCol);
	for yIndex=1:yCol
		J(yIndex) = 1./m * ( -y(1:m,yIndex)' * log( sigmoid(x(1:m,:) * theta(:,yIndex)) ) - ( 1 - y(1:m,yIndex)' ) * log ( 1 - sigmoid( x(1:m,:) * theta(:,yIndex))) );
		grad = 1./m * x(1:m,:)' * (sigmoid(x(1:m,:) * theta(:,yIndex)) - y(1:m,yIndex));
		theta(:,yIndex)=theta(:,yIndex)-alpha(yIndex)*grad;
	endfor
#	mean(J)
#	min(J)
#	max(J)

	if(mod(it,10)==0)
	
		oldMeanError=meanError;
		meanError=ones(1,yCol);
		accuracy=zeros(1,yCol);
			for yIndex=1:yCol
				meanError(yIndex) = mean(abs(round(sigmoid(x(m:m+mTest,:) * theta(:,yIndex))) - y(m:m+mTest,yIndex)));
				
				if sum(y(m:m+mTest,yIndex)==1)>0
					accuracy(yIndex) = sum(round(sigmoid(x(m:m+mTest,:) * theta(:,yIndex)))(y(m:m+mTest,yIndex)==1))/sum(y(m:m+mTest,yIndex)==1);
				endif
				
				if(oldMeanError(yIndex)>meanError(yIndex))
					alpha(yIndex)=alpha(yIndex)*1.25;
				elseif (oldMeanError(yIndex)==meanError(yIndex))
					alpha(yIndex)=alpha(yIndex);
				else
					if(alpha(yIndex)>baseAlpha)
						alpha(yIndex)=baseAlpha;
					else
						alpha(yIndex)=alpha(yIndex)*0.55;
					endif
					
				endif
			
			endfor

			mean(meanError)
			mean(accuracy)
			mean(alpha)
			
		if m<mMax
			m=m+100;
		endif
			
	endif

endfor

goodTheta=theta;
finalTheta=theta;
meanError=ones(1,yCol);
accuracy=zeros(1,yCol);
for yIndex=1:yCol
	meanError(yIndex) = mean(abs(round(sigmoid(x(:,:) * theta(:,yIndex))) - y(:,yIndex)));
	
	if sum(y(:,yIndex)==1)>0
		accuracy(yIndex) = sum(round(sigmoid(x(:,:) * theta(:,yIndex)))(y(:,yIndex)==1))/sum(y(:,yIndex)==1);
	endif
	
endfor

mean(meanError)
mean(accuracy)


for i=1:yCol
	i
	categoryClasses(i)
	relevantPos=(find(finalTheta(:,i)>0.1*max(abs(finalTheta(:,i)))))';
	relevantPos
	corpus(relevantPos((relevantPos>=6))-5)
	
	#relevantNeg=(find(finalTheta(:,i)<-0.1*max(abs(finalTheta(:,i)))))';
	#relevantNeg
	#corpus(relevantNeg((relevantNeg>=6))-5)
endfor

##


###

###NEURAL NETWORKS###
nHidden=10;

minMaxValues = ones(xCol,2);##xCol
minMaxValues(:,1)=0;

neuralNetwork=newff(minMaxValues,[xCol,nHidden,yCol]);

aux=sim(neuralNetwork,(x(2,1:xCol))')

trainSize=1000;
for i=1:trainSize
  neuralNetwork=train(neuralNetwork,(x(i,1:xCol))',(y(i,:))');
endfor
#minMaxValues(1,:)=[min(x(:,1)) max(x(:,1))];






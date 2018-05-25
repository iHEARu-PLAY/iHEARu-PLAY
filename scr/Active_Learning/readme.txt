** Active Learning Algorithms**

We are happy to provide you the initial baseline active learning algorithms integrated in iHEARu-PLAY and kindly thank Dr. Zixing Zhang from Imperial College, UK for providing this baseline code. 

You can run this code with your data and obtained labels in the following way:
1. Copy the folder containing this file into a folder of your choice and enter into it; 
2. Add your .arff feature files to the feature folder
2. Revise configuration file as you wish (please change the weka path); 
3. Run "perl ./whole start end file.pl ... "
   -- "start" and "end" denote the iteration start point and end point; end-start means the  repeating times of learning process;
   -- "file.pl" denotes the specific  executing program
   -- For example, "perl ./whole 1 2 baseline_us.pl actv_l_us.pl"


Keywords: 
- baseline: passive learning;
- actv: active learning;
- m: medium confidence values;
- l: low confidence values;
- us: upsampling;


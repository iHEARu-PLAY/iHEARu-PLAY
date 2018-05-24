
######### parameters for corpus
# set corpus
$corpus = "gemep_aro";

#set class type
#$pos = "IDL";
#$neg = "NEG";
$pos = "aropos";
$neg = "aroneg";

# for IS11.conf
# $fPart1 = "1-111,149-259,297-1332,2147-3182";
# $fPart2 = "112-148,260-296,1333-2146,3183-4368";

# for IS09.conf_old
$fPart1 = "73-360";
$fPart2 = "2-72,361-384";

# for IS10.conf 
# $fPart1 = "1-21,337-735,1051-1582";
# $fPart2 = "22-336,736-1050";

######## parameters for learning
$InitNr = "30";
 
#set seleted number per iteration
$InstNr = "30";
$InstNr2 = "20"; # half of $InstNr
 
#set total iteration times
$iter = "20";

# for cooperative learning
$Nr_actv = "200";
$Nr_semi = "500";
$iter_co = "2";

####### parameters for classifier
# weka path 
$wekaPath = "~/tools/weka-3-7-1/weka.jar";

# SVM parameters 
$c = "0.01";
$c2 = "0.01";

$smpRate= "100.0";

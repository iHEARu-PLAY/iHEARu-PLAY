for i in baseline_us actv_l_us actv_m_us ; do 
	echo "$i" >> ../res/allResults_ua.txt;
	cat ../res/$i.all.ua >> ../res/allResults_ua.txt;
	echo "$i" >> ../res/allResults_wa.txt;
	cat ../res/$i.all.wa >> ../res/allResults_wa.txt;
done

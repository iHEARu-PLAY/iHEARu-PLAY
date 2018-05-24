for i in `seq 1 30`; do 
	for j in baseline_us actv_l_us actv_m_us; do
		perl extract_all.pl ../$i $j ../res
	done
done


for i in `seq 1 10`; do
	for j in baseline_us actv_us ; do
		perl extract_res.pl ../$i/$j/res ../$i/res/$j.res
	done
done


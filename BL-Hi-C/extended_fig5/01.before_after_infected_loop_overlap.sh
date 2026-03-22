bedtools pairtopair -a ../wt_loop.bedpe -b ../pi_loop.bedpe -type both > stable_loop.bedpe
bedtools pairtopair -a ../wt_loop.bedpe -b ../pi_loop.bedpe -type notboth > lost_loop.bedpe
bedtools pairtopair -a ../pi_loop.bedpe -b ../wt_loop.bedpe -type notboth > gained_loop.bedpe
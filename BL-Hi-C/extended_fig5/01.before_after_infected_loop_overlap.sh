bedtools pairtopair -a /path/to/hic/project/wt_loop.bedpe -b /path/to/hic/project/pi_loop.bedpe -type both > stable_loop.bedpe
bedtools pairtopair -a /path/to/hic/project/wt_loop.bedpe -b /path/to/hic/project/pi_loop.bedpe -type notboth > lost_loop.bedpe
bedtools pairtopair -a /path/to/hic/project/pi_loop.bedpe -b /path/to/hic/project/wt_loop.bedpe -type notboth > gained_loop.bedpe
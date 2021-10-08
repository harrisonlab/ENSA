
match query ID with Genome sequence
run crb-blast| rbb-blast on each pair.
select the hit hit higher number and starting at base 1
extract promoter sequence of x length from there. 

Lets start with NINS

awk 'sub(/^>/, "")' 
cut -f 3,5 ../GOMAP-0.3_GOMAP-input/gaf/e.agg_data/0.3_GOMAP-input.aggregate.gaf | sort > new.txt
cut -f 3,5 0.3_GOMAP-input.aggregate.gaf  | sort > old.txt
diff new.txt old.txt

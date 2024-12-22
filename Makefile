SHELL=/bin/bash
MTOOL=/net/work/people/zeman/mrptask-2019-data-neverzovano/mtool/main.py

ensample:
	treex -Len Read::Treex from=source-pcedt20/data/00/wsj_0001.treex.gz Write::MrpJSON > wsj.mrp
	for i in 20001001 20001002 ; do ( $(MTOOL) --read mrp --id $$i --write dot --ids --strings wsj.mrp wsj$$i.dot && dot -Tpng wsj$$i.dot > wsj$$i.png ) ; rm wsj$$i.dot ; done

XX=00
YY=18
ensample2:
	treex -Len Read::Treex from=source-pcedt20/data/$(XX)/wsj_$(XX)$(YY).treex.gz Write::MrpJSON > wsj$(XX)$(YY).mrp
	for i in $$(cat wsj$(XX)$(YY).mrp | perl -pe 's/^\{"id": "(\d+)".*/$$1 /') ; do ( $(MTOOL) --read mrp --id $$i --write dot --ids --strings wsj$(XX)$(YY).mrp wsj$$i.dot && dot -Tpng wsj$$i.dot > wsj$$i.png ) ; rm wsj$$i.dot ; done

# a similar technique ... soybeans etc.: 02/wsj_0209.mrp
enrunning:
	treex -Len Read::Treex from=source-pcedt20/data/02/wsj_0209.treex.gz Write::MrpJSON > enrunning.mrp
	$(MTOOL) --read mrp --id 20209013 --write dot --ids enrunning.mrp enrunning.dot
	dot -Tpng enrunning.dot > enrunning.png
	rm enrunning.dot

pcedt:
	treex -Len Read::Treex from='!source-pcedt20/data/[0-9][0-9]/*.treex.gz' Write::MrpJSON substitute={source-pcedt20/data}{mrp-pcedt20}

validate_pcedt:
	( for i in mrp-pcedt20/*/*.mrp ; do echo $$i ; $(MTOOL) --read mrp --validate all $$i ; done ) |& tee validation.log

cssample:
	treex -Lcs Read::PDT from=/net/data/pdt35/PDT3.5/data/tamw/train-1/mf930713_156.t.gz Write::MrpJSON > pdt.mrp
	for i in 01 02 03 04 05 06 07 08 09 10 ; do ( $(MTOOL) --read mrp --id 129307131560$$i --write dot --ids --strings pdt.mrp pdt$$i.dot && dot -Tpng pdt$$i.dot > pdt$$i.png ) ; rm pdt$$i.dot ; done

pdt:
	treex -Lcs Read::PDT from='!/net/data/pdt35/PDT3.5/data/tamw/*/*.t.gz' Write::MrpJSON substitute={/net/data/pdt35/PDT3.5/data/tamw}{mrp-pdt35}

validate_pdt:
	( for i in mrp-pdt35/*/*.mrp ; do echo $$i ; $(MTOOL) --read mrp --validate all $$i ; done ) |& tee validation.log

# Test vybraného grafu přímo z terminálu (ne z makefilu):
# cat mrp-pdt35/train-8/mf930713_163.mrp
# /lnet/spec/work/projects/mrptask/mtool/main.py --read mrp --id 12930713163019 --write dot --ids mrp-pdt35/train-8/mf930713_163.mrp pokus.dot && dot -Tpng pokus.dot > pokus.png ; rm pokus.dot
# Volba --strings vypíše úseky vstupního textu místo číselných kotev.
# /lnet/spec/work/projects/mrptask/mtool/main.py --read mrp --id 12930713163019 --write dot --ids --strings mrp-pdt35/train-8/mf930713_163.mrp pokus.dot && dot -Tpng pokus.dot > pokus.png ; rm pokus.dot

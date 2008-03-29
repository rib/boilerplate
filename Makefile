
install:
	for i in bashrc boilerplate.sh; do \
		sed "s,@BP_INST_PREFIX@,$$PWD,g" $$i.in>$$i; \
	done
	chmod +x ./boilerplate.sh

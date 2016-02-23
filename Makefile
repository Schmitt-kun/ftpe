all:
	rebar clean compile

run:
	werl -name ftpe  \
		-pa ./ebin \
		-eval "application:start(ftpe)"

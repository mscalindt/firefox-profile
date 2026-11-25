.PHONY: copy rel rel_tag replace srcs

PROFILE_DIR = ./src/mscalindt/
SRC_DIR = ./src/mscalindt/

rel:
	sh ./scripts/release.sh "$(PROFILE_DIR)"

copy:
	@test -n "$(PROFILE_DIR)" || \
	{ printf "%s\n" 'PROFILE_DIR variable cannot be empty.'; exit 2; }
	@test -n "$(SRC_DIR)" || \
	{ printf "%s\n" 'SRC_DIR variable cannot be empty.'; exit 2; }
	@test "$(PROFILE_DIR)" != "$(SRC_DIR)" || \
	{ printf "%s\n" 'Specify PROFILE_DIR to replace SRC_DIR.'; exit 2; }
	rm -rf "$(SRC_DIR)"
	cp -a "$(PROFILE_DIR)" "$(SRC_DIR)"

rel_tag:
	@test -n "$(NAME)" || { printf "%s\n" 'NAME is empty.'; exit 2; }
	git tag -m "$(NAME)" -s "$(NAME)" HEAD

replace:
	@test -n "$(PROFILE_DIR)" || \
	{ printf "%s\n" 'PROFILE_DIR variable cannot be empty.'; exit 2; }
	@test -n "$(SRC_DIR)" || \
	{ printf "%s\n" 'SRC_DIR variable cannot be empty.'; exit 2; }
	@test "$(PROFILE_DIR)" != "$(SRC_DIR)" || \
	{ printf "%s\n" 'Specify PROFILE_DIR to replace with ours.'; exit 2; }
	rm -rf "$(PROFILE_DIR)"
	cp -a "$(SRC_DIR)" "$(PROFILE_DIR)"

srcs:
	sh ./scripts/srcs.sh

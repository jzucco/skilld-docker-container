
.PHONY: split

# If the first argument is "split"
ifeq (split,$(firstword $(MAKECMDGOALS)))
  # Then use next strings as arguments
  ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
endif

## Enable a specific split of config (config_split)
split:
	$($@,$(MAKECMDGOALS))

# Message if no argument passed
ifeq ($(ARGS),)
	@echo "\nMachine name of split to enable is expected as argument \nFor exemple : \n - make split first // To enable first split\nor\n - make split default // To enable default config with no split\n"
	@exit 1
else
		@echo "YAY $(ARGS)"

# Disabling all active splits
	@echo "Disabling all active splits:"
ifneq ("$(wildcard scripts/makefile/config_split_disable_all.sh)","")
	@echo "- Script found : Executing..."
	@$(call php, /bin/sh ./scripts/makefile/config_split_disable_all.sh)
else
	@echo "- scripts/makefile/config_split_disable_all.sh file does not exist"
	@exit 1
endif

# Enabling selected split
	@echo "Enabling selected split : $(ARGS) ..."
ifeq ($(ARGS),default)
	@echo "No specific split to enable for $(ARGS) config..."
else
	@$(call php, drush config-set config_split.config_split.$(ARGS) status 1 -y)
endif

# Executing the rest of deploy commands
	@echo "Importing $(ARGS) config..."
	@$(call php, drush cim -y)
	@make localize
	@echo "Clearing cache..."
	@$(call php, drush cr)
	@make info


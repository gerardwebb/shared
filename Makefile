# Download Booty
BOOTY_URL := https://raw.githubusercontent.com/amplify-edge/booty/master/scripts

ifeq ($(OS),Windows_NT)
	BOOTY_URL:=$(BOOTY_URL)/install.ps1
else
	BOOTY_URL:=$(BOOTY_URL)/install.sh
endif

SHELLCMD :=
ADD_PATH :=
ifeq ($(OS),Windows_NT)
	SHELLCMD:=powershell -NoLogo -Sta -NoProfile -NonInteractive -ExecutionPolicy Unrestricted -Command "Invoke-WebRequest -useb $(BOOTY_URL) | Invoke-Expression"
	ADD_PATH:=export PATH=$$PATH:"/C/booty" # workaround for github CI
else
	SHELLCMD:=curl -fsSL $(BOOTY_URL) | bash
	ADD_PATH:=echo $$PATH
endif


## Build in CI
all: print dep build print-end

print:
	@echo
	@echo -- SHARED REPO : start --
	@echo

print-end:
	@echo
	@echo -- SHARED REPO ; end --
	@echo

## Print all settings
print-all: ## print
	@booty os-print
	@booty gw-print
	@booty list-installed

dep:
	$(SHELLCMD)
	$(ADD_PATH)
	@booty install-all
	@booty extract includes

build:
	# build
	cd ./tool && $(MAKE) all

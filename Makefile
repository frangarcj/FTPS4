ifndef ORBISDEV
$(error ORBISDEV, is not set)
endif

TITLE="FTPS4"
VERSION="1.00"
TITLE_ID="FRAN00004"
CONTENT_ID="IV0000-$(TITLE_ID)_00-FTPS400000000000"

target ?= ps4_elf_sce
TargetFile=homebrew.elf

include $(ORBISDEV)/make/ps4sdk.mk
LinkerFlags+=  -lkernel_stub  -lSceLibcInternal_stub  -lSceSysmodule_stub -lSceSystemService_stub -lSceNet_stub -lSceUserService_stub -lScePigletv2VSH_stub -lSceVideoOut_stub -lSceGnmDriver_stub -lorbisGl2 -lorbis -lScePad_stub -lSceAudioOut_stub -lSceIme_stub -lSceNetCtl_stub 
CompilerFlags +=-D__PS4__ -D__ORBIS__
IncludePath += -I$(ORBISDEV)/usr/include -I$(ORBISDEV)/usr/include/c++/v1 -I$(ORBISDEV)/usr/include/orbis
AUTH_INFO = 000000000000000000000000001C004000FF000000000080000000000000000000000000000000000000008000400040000000000000008000000000000000080040FFFF000000F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

all:: bin/$(CONTENT_ID).pkg

install:
	@cp $(OutPath)/homebrew.self /usr/local/orbisdev/git/ps4sh/bin/hostapp
	@echo "Installed!"
bin/homebrew.oelf: bin/homebrew.elf
	orbis-elf-create bin/homebrew.elf bin/homebrew.oelf
pkg/eboot.bin: bin/homebrew.oelf
	python $(ORBISDEV)/bin/make_fself.py --auth-info $(AUTH_INFO) bin/homebrew.oelf bin/homebrew.self --paid 0x3800000000000011
	mv bin/homebrew.self pkg/eboot.bin
pkg/sce_sys/param.sfo: 
	pkgTool sfo_new pkg/sce_sys/param.sfo
	pkgTool sfo_setentry pkg/sce_sys/param.sfo APP_TYPE --type Integer --maxsize 4 --value 1
	pkgTool sfo_setentry pkg/sce_sys/param.sfo APP_VER --type Utf8 --maxsize 8 --value $(VERSION)
	pkgTool sfo_setentry pkg/sce_sys/param.sfo ATTRIBUTE --type Integer --maxsize 4 --value 0
	pkgTool sfo_setentry pkg/sce_sys/param.sfo CATEGORY --type Utf8 --maxsize 4 --value "gde"
	pkgTool sfo_setentry pkg/sce_sys/param.sfo CONTENT_ID --type Utf8 --maxsize 48 --value $(CONTENT_ID)
	pkgTool sfo_setentry pkg/sce_sys/param.sfo DOWNLOAD_DATA_SIZE --type Integer --maxsize 4 --value 0
	pkgTool sfo_setentry pkg/sce_sys/param.sfo SYSTEM_VER --type Integer --maxsize 4 --value 0
	pkgTool sfo_setentry pkg/sce_sys/param.sfo TITLE --type Utf8 --maxsize 128 --value $(TITLE)
	pkgTool sfo_setentry pkg/sce_sys/param.sfo TITLE_ID --type Utf8 --maxsize 12 --value $(TITLE_ID)
	pkgTool sfo_setentry pkg/sce_sys/param.sfo VERSION --type Utf8 --maxsize 8 --value $(VERSION)
bin/$(CONTENT_ID).pkg: pkg/eboot.bin pkg/sce_sys/param.sfo
	cd pkg && pkgTool pkg_build project.gp4 . && mv *.pkg ../bin/
clean::
	rm -rf build bin pkg/eboot.bin pkg/sce_sys/param.sfo
SRC_DIR = src
SRCS = $(notdir $(wildcard $(SRC_DIR)/*.pas))
BIN_DIR = bin
TARGETS = $(patsubst %.pas, $(BIN_DIR)/%, $(SRCS))

all: $(TARGETS)
	
$(BIN_DIR)/%: $(SRC_DIR)/%.pas
	@if [ ! -d $(BIN_DIR) ]; then mkdir $(BIN_DIR); fi
	fpc $< -FE$(BIN_DIR)

clean:
	rm $(BIN_DIR)/*

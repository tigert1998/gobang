SRC_DIR = src
SRCS = $(notdir $(wildcard $(SRC_DIR)/*.pas))
BIN_DIR = bin
TARGETS = $(patsubst %.pas, $(BIN_DIR)/%, $(SRCS))

all: $(TARGETS)
	
$(BIN_DIR)/%: $(SRC_DIR)/%.pas
	fpc $< -FE$(BIN_DIR)

clean:
	rm $(BIN_DIR)/*

JAVAC = javac
JAVA = java
SRC_DIR = src
BIN_DIR = bin
MAIN_CLASS = Main

# Find all Java source files
SOURCES := $(wildcard $(SRC_DIR)/*.java)

# Default target: compile all Java files
all: $(BIN_DIR)/classes.timestamp

# Rule to compile all Java files together
$(BIN_DIR)/classes.timestamp: $(SOURCES)
	@mkdir -p $(BIN_DIR)
	$(JAVAC) -d $(BIN_DIR) $(SOURCES)
	touch $(BIN_DIR)/classes.timestamp

# Run the main class
run: all
	$(JAVA) -cp $(BIN_DIR) $(MAIN_CLASS) $(ARGS)

# Clean compiled files
clean:
	rm -rf $(BIN_DIR)/*.class $(BIN_DIR)/classes.timestamp
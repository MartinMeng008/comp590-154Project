module SRAM(
  input  clk,
  input  reset,
  input  [LOG_NUM_ROWS-1:0] readAddr,
  output [WIDTH-1:0] readData,
  input  [LOG_NUM_ROWS-1:0] writeAddr,
  input  [WIDTH-1:0] writeData,
  input  [WIDTH/WORD_SIZE-1:0] writeEnable
);
  parameter WIDTH = 512;
  parameter LOG_NUM_ROWS = 9;
  parameter WORD_SIZE = 64;
  localparam NUM_ROWS = 2**LOG_NUM_ROWS;

  logic[WIDTH-1:0] mem[NUM_ROWS-1:0];

  initial begin
    $display("Initializing %0dKB (%0dx%0d) memory", (WIDTH+7)/8 * NUM_ROWS/1024, WIDTH, NUM_ROWS);
  end

  integer i;
  always @ (posedge clk) begin
    if (reset) begin
      for (i = 0; i < NUM_ROWS; i += 1)
        mem[i] = 0;
    end
    else begin
      // read
      readData <= mem[readAddr];

      // write
      for (i = 0; i < WIDTH/WORD_SIZE; i += 1) begin
        if (writeEnable[i]) begin
          mem[writeAddr][i*WORD_SIZE +: WORD_SIZE] <= writeData[i*WORD_SIZE +: WORD_SIZE];
        end
      end
    end
  end
endmodule

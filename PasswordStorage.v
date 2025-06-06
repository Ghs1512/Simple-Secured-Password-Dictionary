module PasswordStorage(
    input             clk,
    input             write_en,
    input      [3:0]  write_addr,
    input      [7:0]  write_data,
    input      [3:0]  read_addr,
    output reg [7:0]  read_data
);
    reg [7:0] memory [0:9];
    integer i;

    initial begin
        for(i = 0; i < 10; i = i + 1)
            memory[i] = 8'd0;
    end

    always @(posedge clk) begin
        if (write_en) begin
            memory[write_addr] <= write_data;
        end
    end

    always @(*) begin
        read_data = memory[read_addr];
    end
endmodule
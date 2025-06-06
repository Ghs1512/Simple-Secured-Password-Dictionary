module Encrypter(
    input  [7:0] plain,
    input  [7:0] key,
    output [7:0] cipher
);
    wire [7:0] xor_result;
    assign xor_result = plain ^ key;
    assign cipher = {xor_result[6:0], xor_result[7]};  // Rotate left by 1
endmodule
module Decrypter(
    input  [7:0] cipher,
    input  [7:0] key,
    output [7:0] plain
);
    wire [7:0] rotated;
    assign rotated = {cipher[0], cipher[7:1]};  // Rotate right by 1
    assign plain = rotated ^ key;
endmodule
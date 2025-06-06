`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2025 11:49:28
// Design Name: 
// Module Name: TopModule
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TopModule(
    input        clk,
    input  [7:0] plain_in,
    input  [7:0] master_key,
    input  [3:0] addr_index,
    input        write_enable,
    input  [7:0] entered_master,
    output       unlocked,
    output [7:0] dec_out
);
    wire [7:0] enc_out;
    wire [7:0] stored_cipher;

    Encrypter encrypter_inst (
        .plain(plain_in),
        .key(master_key),
        .cipher(enc_out)
    );

    Decrypter decrypter_inst (
        .cipher(stored_cipher),
        .key(master_key),
        .plain(dec_out)
    );

    PasswordStorage storage_inst (
        .clk(clk),
        .write_en(write_enable),
        .write_addr(addr_index),
        .write_data(enc_out),
        .read_addr(addr_index),
        .read_data(stored_cipher)
    );

    MasterValidator #(.MASTER_PASS(8'hA5)) validator_inst (
        .entered_pass(entered_master),
        .unlocked(unlocked)
    );
endmodule

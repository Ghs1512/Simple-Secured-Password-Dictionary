`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.04.2025 11:53:37
// Design Name: 
// Module Name: Testbench
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


module testbench;
    reg clk;

    // Signals
    reg  [7:0] plain_in;
    wire [7:0] enc_out;
    reg  [7:0] master_key;
    reg  [7:0] entered_master;
    wire       unlocked;
    reg  [3:0] addr_index;
    reg        write_enable;
    wire [7:0] stored_cipher;
    wire [7:0] dec_out;

    // Instantiate Modules
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

    // User-entered password array
    reg [7:0] passwords [0:9];  // 10 passwords of 8-bit each

    integer i;
    initial begin
        // Initialize simulation signals
        clk = 0;
        master_key = 8'hA5;
        write_enable = 0;
        addr_index = 0;
        entered_master = 8'h00;

        // Manually input (simulate user-entered) plaintext passwords
        passwords[0] = 8'h12;
        passwords[1] = 8'h3A;
        passwords[2] = 8'h5F;
        passwords[3] = 8'h9B;
        passwords[4] = 8'h04;
        passwords[5] = 8'hE7;
        passwords[6] = 8'hAC;
        passwords[7] = 8'hD1;
        passwords[8] = 8'h23;
        passwords[9] = 8'h7C;

        $display("User entered 10 plaintext passwords.");
        $display("Beginning encryption and secure storage...\n");

        // Encrypt and store the passwords
        for (i = 0; i < 10; i = i + 1) begin
            plain_in = passwords[i];
            #1;
            addr_index = i;
            write_enable = 1;
            @(posedge clk);
            write_enable = 0;
            @(negedge clk);
            $display("Encrypted and stored password %0d: 0x%02h", i, enc_out);
        end

        $display("\nAttempting access with incorrect master password...");
        entered_master = 8'hFF;  // incorrect
        #1;
        if (unlocked)
            $display("ERROR: Dictionary unlocked with incorrect password!\n");
        else
            $display("Access DENIED. Dictionary remains locked.\n");

        $display("Attempting access with correct master password...");
        entered_master = master_key;
        #1;
        if (unlocked) begin
            $display("Access GRANTED. Decrypting stored passwords...\n");
            for (i = 0; i < 10; i = i + 1) begin
                addr_index = i;
                #1;
                $display("Password %0d decrypted: 0x%02h (expected: 0x%02h)", i, dec_out, passwords[i]);
            end
        end else begin
            $display("ERROR: Correct master password was rejected.");
        end

        $display("\nTestbench complete.");
        $finish;
    end

    // Clock: 10ns period
    always #5 clk = ~clk;
endmodule

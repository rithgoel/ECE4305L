`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2023 11:47:16 PM
// Design Name: 
// Module Name: param_left_shifter
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

parameter N = 3;

module param_left_shifter
    (
    input logic [(2**N)-1:0] a,
    input logic [N-1:0] amt,
    output logic [(2**N)-1:0] y
    );

logic [2**N-1:0] S[N-1];

//stage 0
assign S[0] = amt[0] ? {a[0], a[2**N-1:1]} : a;

// Middle stages
generate
    genvar i;
    for (i = 1; i < N-1; i=i+1)
        assign S[i] = amt[i] ? {S[i-1][2**N-1-(2**i):0] , S[i-1][2**N-1:2**N-2**i]}: S[i-1];
                    
endgenerate
            
           
           assign y = amt[N-1] ? {S[N-2][2**(N-1)-1:0], S[N-2][2**N-1:2**(N-1)]}:S[N-2];

endmodule

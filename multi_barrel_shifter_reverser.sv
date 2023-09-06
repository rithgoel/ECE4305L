`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2023 03:59:40 PM
// Design Name: 
// Module Name: multi_barrel_shifter_reverser
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

module multi_barrel_shifter_reverser
(

input logic [2**N-1:0] a,
input logic [N - 1:0] amt,
input logic lr, // 0 rotate right, 1 rotate left
output logic [2**N-1:0] y
);
    
    logic [2**N-1:0] out;
    logic [2**N-1:0] reversed_out;
    logic [2**N-1:0] reversed_data;
    
    reverser input_inverter(.a(a), .yRev(reversed_data));
    
    param_right_shifter bsR(.a((lr) ? reversed_data:a), .amt(amt), .y(out));
    
    reverser output_inverter(.a(a), .yRev(reversed_out));
    
    assign y = (lr) ? reversed_out:out;
   
endmodule
    

    
module reverser
(
    input logic [2**N-1:0] a,
    output logic [2**N-1:0] yRev
);    
genvar i;
generate
   for (i = 0; i < 2**N ; i = i+1)
     assign yRev[i] = a[2**N-1 -i];      
 endgenerate 
    
endmodule


// RIGHT SHIFTER
module param_right_shifter
    (
    input logic [2**N-1:0] a,
    input logic [N-1:0] amt,
    output logic [2**N-1:0] y
    );

logic [2**N-1:0] S[N-1];

//stage 0
assign S[0] = amt[0] ? {a[0], a[2**N-1:1]} : a;

// Middle stages
generate
    genvar i;
    for (i = 1; i < N-1; i=i+1)
        assign S[i] = amt[i] ? {S[i-1][2**i-1:0], S[i-1][2**N-1:2**i]}: S[i-1];
endgenerate

//final stage
assign y = amt[N-1] ? {S[N-2][2**(N-1)-1:0], S[N-2][2**N-1:2**(N-1)]}:S[N-2];

endmodule

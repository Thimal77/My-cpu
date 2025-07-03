

`include "cpu.v"

module cpu_tb;

    reg CLK, RESET;
    wire [31:0] PC;
    wire [31:0] INSTRUCTION;
    
    /* 
    ------------------------
     SIMPLE INSTRUCTION MEM
    ------------------------
    */
    
    // TODO: Initialize an array of registers (8x1024) named 'instr_mem' to be used as instruction memory
	reg [7:0] instr_mem [1023:0];
    
    // TODO: Create combinational logic to support CPU instruction fetching, given the Program Counter(PC) value 
    //       (make sure you include the delay for instruction fetching here)
	assign #2 INSTRUCTION = {instr_mem[PC+3], instr_mem[PC+2], instr_mem[PC+1], instr_mem[PC]};
    
initial begin
    // LOADI R1, 5
    {instr_mem[3], instr_mem[2], instr_mem[1], instr_mem[0]} = 
    32'b00000000_00000001_00000000_00000101; // R1 = 5

    // LOADI R2, 9
    {instr_mem[7], instr_mem[6], instr_mem[5], instr_mem[4]} = 
    32'b00000000_00000010_00000000_00001001; // R2 = 9

    // BNE R1, R2, +2 (should branch since 5 != 9)
    {instr_mem[11], instr_mem[10], instr_mem[9], instr_mem[8]} = 
    32'b00001000_00000001_00000001_00000010;

    // ADD R3, R1, R1 ( skipped)
    {instr_mem[15], instr_mem[14], instr_mem[13], instr_mem[12]} = 
    32'b00000010_00000011_00000001_00000001;

    // ADD R3, R2, R2 (should be executed after jump)
    {instr_mem[19], instr_mem[18], instr_mem[17], instr_mem[16]} = 
    32'b00000010_00000011_00000010_00000010;

    // BEQ R1, R2, +2 (should not branch since 5 != 9)
    {instr_mem[23], instr_mem[22], instr_mem[21], instr_mem[20]} = 
    32'b00000111_00000001_00000010_00000010;

    // LOADI R4, 7 (should execute)
    {instr_mem[27], instr_mem[26], instr_mem[25], instr_mem[24]} = 
    32'b00000000_00000100_00000000_00000111;

    // LOADI R5, 8 (should execute)
    {instr_mem[31], instr_mem[30], instr_mem[29], instr_mem[28]} = 
    32'b00000000_00000101_00000000_00001000;
end

    
    /* 
    -----
     CPU
    -----
    */
    cpu mycpu(PC, INSTRUCTION, CLK, RESET);
    integer i;

    initial
    begin
    
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, cpu_tb);
        for (i =0 ;i<8 ;i++ ) begin
            $dumpvars(1, cpu_tb.mycpu.my_reg.REGISTER[i]);
        end
        
        
        CLK = 1'b0;
        RESET = 1'b1;
        
        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution
		#5
		RESET = 1'b0;
        
        // finish simulation after some time
        #300
        $finish;
        
    end
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
        

endmodule
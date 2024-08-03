library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.common.all;

entity top_processor_FPGA is
	port ( 	next_instr : in STD_LOGIC;
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;

		-- for display
		seg_bits : out  STD_LOGIC_VECTOR (0 to 7);			  
		seg_an : out  STD_LOGIC_VECTOR (3 downto 0)
	);
end top_processor_FPGA;

architecture Behavioral of top_processor_FPGA is

component Display_Controller
	port ( 	clk : in STD_LOGIC;
		rst : in STD_LOGIC;

		opcode : in opcode_type;

	 	operand_1 : in STD_LOGIC_VECTOR (13 downto 0);
	 	operand_2 : in STD_LOGIC_VECTOR (13 downto 0);

	 	result : in STD_LOGIC_VECTOR (13 downto 0);
		overflow : in STD_LOGIC;

		seg_bits : out  STD_LOGIC_VECTOR (0 to 7);			  
		seg_an : out  STD_LOGIC_VECTOR (3 downto 0)
	     );
end component;

-- TODO add other components
component PC
    port (
        clk    : in STD_LOGIC;
        rst    : in STD_LOGIC;
        PC_in  : in STD_LOGIC_VECTOR (6 downto 0);
        PC_out : out STD_LOGIC_VECTOR (6 downto 0);
        PC_we  : in STD_LOGIC;
        PC_incr: in STD_LOGIC
    );
end component;

component Controller
	port ( 
		opcode : in opcode_type;

	 	operand_1 : out STD_LOGIC_VECTOR (13 downto 0);
	 	operand_2 : out STD_LOGIC_VECTOR (13 downto 0);

	 	result : in STD_LOGIC_VECTOR (13 downto 0);

		curr_PC : in STD_LOGIC_VECTOR (6 downto 0);

		new_PC : out STD_LOGIC_VECTOR (6 downto 0);
		PC_we : out STD_LOGIC;
		PC_incr : out STD_LOGIC;

		Rs1_data : in STD_LOGIC_VECTOR (13 downto 0);
		Rs2_data : in STD_LOGIC_VECTOR (13 downto 0);
		immediate : in STD_LOGIC_VECTOR (13 downto 0);

		Rd_we : out STD_LOGIC;
		Rd_data : out STD_LOGIC_VECTOR (13 downto 0)
	     );
end component;

component Registers 
	port ( 	
		clk : in STD_LOGIC;
		rst: in STD_LOGIC;

		Rs1_addr_in : in STD_LOGIC_VECTOR (2 downto 0);
		Rs1_data_out : out STD_LOGIC_VECTOR (13 downto 0);

		Rs2_addr_in : in STD_LOGIC_VECTOR (2 downto 0);
		Rs2_data_out : out STD_LOGIC_VECTOR (13 downto 0);

		Rd_addr_in : in STD_LOGIC_VECTOR (2 downto 0);
		Rd_data_in : in STD_LOGIC_VECTOR (13 downto 0);
		Rd_we : in STD_LOGIC
	     );
end component;


component ALU 
	port ( 	
		operand_1 : in STD_LOGIC_VECTOR (13 downto 0);
	 	operand_2 : in STD_LOGIC_VECTOR (13 downto 0);

	 	opcode : in opcode_type;

		result : out STD_LOGIC_VECTOR (13 downto 0);
		overflow : out STD_LOGIC

	     );
end component;

component Instructions_ROM 
	port (	
		address_in : in STD_LOGIC_VECTOR (6 downto 0);
		data_out : out STD_LOGIC_VECTOR (15 downto 0)
	     );
end component;


component Decoder
	port ( 	
		instruction_in : in STD_LOGIC_VECTOR (15 downto 0);

		opcode_out : out opcode_type;

		Rd_addr_out : out STD_LOGIC_VECTOR (2 downto 0);
		Rs1_addr_out : out STD_LOGIC_VECTOR (2 downto 0);
		Rs2_addr_out : out STD_LOGIC_VECTOR (2 downto 0);

		immediate_out : out STD_LOGIC_VECTOR (13 downto 0)
	     );
end component;



	--PC signals
     signal PC_we_internal, PC_incr_internal: STD_LOGIC;
	  signal curr_PC_internal, new_PC_internal : STD_LOGIC_VECTOR(6 downto 0);

	--Register signals 
    signal Rd_we_internal, overflow_internal : STD_LOGIC;
    signal Rs1_addr_internal, Rs2_addr_internal, Rd_addr_internal : STD_LOGIC_VECTOR(2 downto 0);
	 signal Rs1_data_internal, Rs2_data_internal, immediate_internal, Rd_data_internal : STD_LOGIC_VECTOR(13 downto 0);

	 -- instructions
    signal instruction_internal : STD_LOGIC_VECTOR (15 downto 0);
	    signal opcode_internal : opcode_type;


	-- ALU
    signal operand_1_internal : STD_LOGIC_VECTOR (13 downto 0);
    signal operand_2_internal : STD_LOGIC_VECTOR (13 downto 0);
    signal result_internal : STD_LOGIC_VECTOR (13 downto 0);
	
	
	-- pseudo clock for advancing processor to next instruction
    signal clk_proc : STD_LOGIC;

	-- display controller
    signal rst_disp : STD_LOGIC;

begin
	 clk_proc <= next_instr; 
	 rst_disp <= rst or clk_proc;
				
	    Instructions_ROM_inst : Instructions_ROM
        port map (curr_PC_internal, instruction_internal);

    Decoder_inst : Decoder
        port map (instruction_internal, opcode_internal, Rd_addr_internal, Rs1_addr_internal, Rs2_addr_internal, immediate_internal);

    Controller_inst : Controller
        port map (opcode_internal, operand_1_internal, operand_2_internal, result_internal, curr_PC_internal, new_PC_internal, PC_we_internal, PC_incr_internal, Rs1_data_internal, Rs2_data_internal, immediate_internal, Rd_we_internal, Rd_data_internal);
        
    PC_inst : PC
        port map (clk_proc, rst, new_PC_internal, curr_PC_internal, PC_we_internal, PC_incr_internal);

    Registers_inst : Registers
        port map (clk_proc, rst, Rs1_addr_internal, Rs1_data_internal, Rs2_addr_internal, Rs2_data_internal, Rd_addr_internal, Rd_data_internal, Rd_we_internal);

    ALU_inst : ALU
        port map (operand_1_internal, operand_2_internal, opcode_internal, result_internal, overflow_internal);
    
    Display_Controller_inst : Display_Controller
        port map (clk, rst_disp, opcode_internal, operand_1_internal, operand_2_internal, result_internal, overflow_internal, seg_bits, seg_an);

	
end Behavioral;
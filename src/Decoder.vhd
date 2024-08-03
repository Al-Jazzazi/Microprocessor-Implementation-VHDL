library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.common.all;

entity Decoder is
	port ( 	instruction_in : in STD_LOGIC_VECTOR (15 downto 0);

		opcode_out : out opcode_type;

		Rd_addr_out : out STD_LOGIC_VECTOR (2 downto 0);
		Rs1_addr_out : out STD_LOGIC_VECTOR (2 downto 0);
		Rs2_addr_out : out STD_LOGIC_VECTOR (2 downto 0);

		immediate_out : out STD_LOGIC_VECTOR (13 downto 0)
	     );
end Decoder;

architecture Behavioral of Decoder is

--TODO add signals as needed
signal opcode_internal : opcode_type;
signal instruction_change : STD_LOGIC_VECTOR (15 downto 0);

begin
	opcode_out <= opcode_internal;

	opcode_internal <= std_logic_vector_to_opcode_type( instruction_in(15 downto 12) );
	instruction_change <= instruction_in;
	--TODO implement extraction of remaining parts of the instruction
	
	--TODO derive immediate value, depending on opcode_internal
	
	Reg_Decoder: process (opcode_internal,instruction_change )
begin 
    Rd_addr_out <= "000"; 
    Rs1_addr_out <= "000";
    Rs2_addr_out <= "000";
    immediate_out <= "00000000000000";
    
    if opcode_internal =OP_AND or opcode_internal =OP_OR or opcode_internal =OP_XOR or opcode_internal =OP_ADD or opcode_internal =OP_SUB then 
        Rd_addr_out <= std_logic_vector(instruction_in(11 downto 9));
        Rs1_addr_out <= std_logic_vector(instruction_in(8 downto 6));
        Rs2_addr_out <= std_logic_vector(instruction_in(5 downto 3));
    elsif opcode_internal = OP_ANDI then 
		  Rd_addr_out <= std_logic_vector(instruction_in(11 downto 9));
        Rs1_addr_out <= std_logic_vector(instruction_in(8 downto 6));
        immediate_out <= "11111111" & std_logic_vector(instruction_in(5 downto 3)) & std_logic_vector(instruction_in(2 downto 0)) ;
	 elsif opcode_internal = OP_ORI or opcode_internal = OP_XORI then 
		  Rd_addr_out <= std_logic_vector(instruction_in(11 downto 9));
        Rs1_addr_out <= std_logic_vector(instruction_in(8 downto 6));
        immediate_out <= "00000000" & std_logic_vector(instruction_in(5 downto 3)) & std_logic_vector(instruction_in(2 downto 0)) ;
	  elsif opcode_internal = OP_SLL or opcode_internal = OP_SRL then 
		  Rd_addr_out <= std_logic_vector(instruction_in(11 downto 9));
        Rs1_addr_out <= std_logic_vector(instruction_in(8 downto 6));
        immediate_out <= "00000000000" &  std_logic_vector(instruction_in(2 downto 0)) ;  
		elsif opcode_internal = OP_ADDI or opcode_internal = OP_SUBI then 
		  Rd_addr_out <= std_logic_vector(instruction_in(11 downto 9));
        Rs1_addr_out <= std_logic_vector(instruction_in(8 downto 6));
		  immediate_out <= (15 downto 8 => instruction_in(5)) & std_logic_vector(instruction_in(5 downto 3)) & std_logic_vector(instruction_in(2 downto 0));
		  
		  
		elsif opcode_internal = OP_BLT or opcode_internal = OP_BE then 
		  Rs1_addr_out <= std_logic_vector(instruction_in(8 downto 6));
        Rs2_addr_out <= std_logic_vector(instruction_in(5 downto 3));
		  immediate_out <= (15 downto 8 => instruction_in(11)) &  std_logic_vector(instruction_in(11 downto 9)) & std_logic_vector(instruction_in(2 downto 0));
		  
		  
		elsif opcode_internal = OP_JMP then 
		  immediate_out <= (15 downto 8 => instruction_in(11)) &  std_logic_vector(instruction_in(11 downto 9)) & std_logic_vector(instruction_in(2 downto 0));
    end if; 
	 
end process;


	
end Behavioral;

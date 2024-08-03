
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.common.all;

entity Instructions_ROM is
	port (	address_in : in STD_LOGIC_VECTOR (6 downto 0);
		data_out : out STD_LOGIC_VECTOR (15 downto 0)
	     );
end Instructions_ROM;

architecture Behavioral of Instructions_ROM is

type ROM_type is array (0 to 127) of STD_LOGIC_VECTOR (15 downto 0);
signal rom : ROM_type;

begin
	data_out <= rom ( to_integer(unsigned(address_in)) );

	rom_process : process (address_in)
	begin
		-- LEAVE AS IS
		--
		-- reset ROM content completely with HLT operations; note that loop will be unrolled during synthesis
		for i in 0 to 127 loop 
			rom(i) <= opcode_type_to_std_logic_vector(OP_HALT) & (11 downto 0 => 'X'); 
		end loop;

		-- initialize ROM with binary code
		--
		
		-- TODO comment out and replace with your own binary code here
		--	
--		---- Initial Tests 
--		rom(0) <= opcode_type_to_std_logic_vector(OP_ADDI) & b"001" & b"000" & b"100_000"; -- R1: R0 + -32 = -32
--	rom(1) <= opcode_type_to_std_logic_vector(OP_ADDI) & b"010" & b"000" & b"100_000"; -- R2: R0 + -32 = -32
--		rom(2) <= opcode_type_to_std_logic_vector(OP_ADD)  & b"011" & b"001" & b"010" & b"000"; -- R3: R1 + R2 = -64
--		rom(3) <= opcode_type_to_std_logic_vector(OP_ADD)  & b"011" & b"011" & b"011" & b"000"; -- R3: R3 + R3 = -128
--	rom(4) <= opcode_type_to_std_logic_vector(OP_ADD)  & b"011" & b"011" & b"011" & b"000"; -- R3: R3 + R3 = -256
--		rom(5) <= opcode_type_to_std_logic_vector(OP_ADD)  & b"011" & b"011" & b"011" & b"000"; -- R3: R3 + R3 = -512
--        rom(6) <= opcode_type_to_std_logic_vector(OP_ADD)  & b"011" & b"011" & b"011" & b"000"; -- R3: R3 + R3 = -1024
--		rom(7) <= opcode_type_to_std_logic_vector(OP_ADD)  & b"011" & b"011" & b"011" & b"000"; -- R3: R3 + R3 = -2048
--		rom(8) <= opcode_type_to_std_logic_vector(OP_ADD)  & b"011" & b"011" & b"011" & b"000"; -- R3: R3 + R3 = -4096
--	rom(9) <= opcode_type_to_std_logic_vector(OP_ADD)  & b"011" & b"011" & b"011" & b"000"; -- R3: R3 + R3 = -8192
--		rom(10) <= opcode_type_to_std_logic_vector(OP_SUBI) & b"100" & b"011" & b"000_001"; -- R4: R3 - 1 = 8192 instead of -8193; overflow
--
--	
		
		
--		--Arithmetic Operations 
--The code is a loop that runs for 5 times (R1 times) and increments R2 by one in each iteration. 
--The iteration is implemented by BLT that checks if R0 is less than R1, and if that condition is true goes to line 3 (or more accurately jumps back two steps, creating a loop).

		rom(0) <= opcode_type_to_std_logic_vector(OP_ADDI) & b"001" & b"000" & b"000_101";
		rom(1) <= opcode_type_to_std_logic_vector(OP_ADDI) & b"010" & b"000" & b"000_000"; 
	   rom(2) <= opcode_type_to_std_logic_vector(OP_ADDI) & b"010" & b"010" & b"000_101"; 
		rom(3) <= opcode_type_to_std_logic_vector(OP_SUBI) & b"001" & b"001" & b"000_001"; 
		rom(4) <= opcode_type_to_std_logic_vector(OP_BLT) & b"111" & b"000" & b"001_110";


--
----	   -- Sum of Squares
----	--	; Initial setup
-- 			rom(0) <= opcode_type_to_std_logic_vector(OP_ADDI) & b"001" & b"000" & b"000_000";
--   			rom(1) <= opcode_type_to_std_logic_vector(OP_ADDI) & b"010" & b"000" & b"000_000";
--   			rom(2) <= opcode_type_to_std_logic_vector(OP_ADDI) & b"011" & b"000" & b"000_011";
--   			  rom(3) <= opcode_type_to_std_logic_vector(OP_ADD) & b"011" & b"000" & b"010_001";
--  			  rom(4) <= opcode_type_to_std_logic_vector(OP_ADD) & b"100" & b"000" & b"011_000";
--   		  	rom(5) <= opcode_type_to_std_logic_vector(OP_ADD) & b"011" & b"000" & b"011_101";
---- --
---- 
---- 		 --	; Loop to calculate sum of squares
---- 		--	 loop_start:
-- 					rom(3) <= opcode_type_to_std_logic_vector(OP_ADD) & b"101" & b"000" & b"011_000";
-- 					rom(4) <= opcode_type_to_std_logic_vector(OP_ADD) & b"100" & b"000" & b"000_000";
-- 
---- 			--	 ; Inner loop to compute square by 1000(ADD)ing 000(R0) to itself, 000(R0) times
---- 				-- square_loop:
-- 					   rom(5) <= opcode_type_to_std_logic_vector(OP_ADD) & b"100" & b"100" & b"011_000";   --R4 += R3
-- 					 	rom(6) <= opcode_type_to_std_logic_vector(OP_SUBI) & b"101" & b"101" & b"000_001";   -- R5--;     
-- 					 	rom(7) <= opcode_type_to_std_logic_vector(OP_BLT) & b"111" & b"000" & b"101_110"; --  2(UPDATE_SUM)
-- 					 	rom(8) <= opcode_type_to_std_logic_vector(OP_JMP) & b"111" & b"000" & b"000_101"; -- 3(square_loop)
-- 			-- 	.update_sum
-- 				rom(8) <= opcode_type_to_std_logic_vector(OP_ADD) & b"010" & b"010" & b"100_000";
--				rom(9) <= opcode_type_to_std_logic_vector(OP_SUBI) & b"011" & b"011" & b"000_001";
--				rom(10) <= opcode_type_to_std_logic_vector(OP_BLT) & b"111" & b"000" & b"011_001"; --(loop_start) 
--			 rom(11) <= opcode_type_to_std_logic_vector(OP_HALT) & b"111" & b"000" & b"011_001"; --(loop_start) 


		-- LEAVE AS IS
		--
		-- This dummy code below helps to infer all 7 registers (R1--R7) in the register file, without short-cuts into combinatorial
--		-- logic due to tool optimization; that is important to ensure the same baseline hardware configuration for all
		rom(121) <= opcode_type_to_std_logic_vector(OP_ADD) & b"001_001_000_000";
		rom(122) <= opcode_type_to_std_logic_vector(OP_ADD) & b"010_010_001_000";
	   rom(123) <= opcode_type_to_std_logic_vector(OP_ADD) & b"011_011_010_000";
		rom(124) <= opcode_type_to_std_logic_vector(OP_ADD) & b"100_100_011_000";
		rom(125) <= opcode_type_to_std_logic_vector(OP_ADD) & b"101_101_100_000";
		rom(126) <= opcode_type_to_std_logic_vector(OP_ADD) & b"110_110_101_000";
		rom(127) <= opcode_type_to_std_logic_vector(OP_ADD) & b"111_111_110_000";				

	end process;

end Behavioral;





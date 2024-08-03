library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.common.all;

entity Controller is
	port ( 	opcode : in opcode_type;

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
end Controller;

architecture Behavioral of Controller is

begin

control : process (opcode, Rs1_data, Rs2_data, result, immediate, curr_PC)
begin
	-- default assignments, can be overwritten below
	operand_1 <= Rs1_data;
	operand_2 <= Rs2_data;

	Rd_we <= '0';
	Rd_data <= result;

	PC_we <= '0';
	new_PC <= (6 downto 0 => 'X');

	PC_incr <= '0';

	-- regular operations with Rs1, Rs2, Rd
	-- TODO consider remaining cases
	    if opcode =OP_AND or opcode =OP_OR or opcode =OP_XOR or opcode =OP_ADD or opcode =OP_SUB then 

			Rd_we <= '1';
			PC_incr <= '1';
				Rd_data <= result;

		elsif opcode = OP_ANDI or opcode =OP_SUBI or  opcode = OP_ORI or opcode = OP_XORI or opcode =OP_ADDI 
		or opcode = OP_SLL or opcode = OP_SRL  then

			operand_2<= immediate;
			Rd_we <= '1';
			PC_incr <= '1';
				Rd_data <= result;

		elsif opcode = OP_BLT then 
		     if (signed(Rs1_data) < signed(Rs2_data)) then 
					operand_1<= "0000000" & curr_PC;
					operand_2 <= immediate;
					PC_we <= '1';
					new_PC <= STD_LOGIC_VECTOR(result(6 downto 0));
				else 
					PC_incr <= '1';
			  end if;
			  
		elsif opcode = OP_BE then 
		     if (signed(Rs1_data) = signed(Rs2_data)) then 
					operand_1<= "0000000" & curr_PC;
					operand_2 <= immediate;
					PC_we <= '1';
					new_PC <= STD_LOGIC_VECTOR(result(6 downto 0));
				else 
					PC_incr <= '1';
			  end if;
			  
		elsif opcode = OP_JMP then 
					operand_1<= "0000000" & curr_PC;
					operand_2 <= immediate;
					PC_we <= '1';
					new_PC <= STD_LOGIC_VECTOR(result(6 downto 0));
		

	-- only OP_HALT should remain
	else
		operand_1 <= (13 downto 0 => 'X');
		operand_2 <= (13 downto 0 => 'X');

		Rd_data <= (13 downto 0 => 'X');
	end if;
end process;

end Behavioral;


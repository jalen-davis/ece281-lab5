----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture Behavioral of ALU is -- (J)

    component ripple_adder is
        Port (
           A : in  STD_LOGIC_VECTOR(7 downto 0);
           B : in  STD_LOGIC_VECTOR(7 downto 0);
           Cin : in  STD_LOGIC;
           --subber : in STD_LOGIC;
           S : out  STD_LOGIC_VECTOR(7 downto 0);
           Cout : out  STD_LOGIC
           );
        end component ripple_adder;

    signal op_sum : std_logic_vector(7 downto 0);
    signal op_sub : std_logic_vector(7 downto 0);
    signal op_and : std_logic_vector(7 downto 0);
    signal op_or : std_logic_vector(7 downto 0);
    --signal sub : std_logic;
    signal cout_add : std_logic;
    signal cout_sub : std_logic;
    signal result : std_logic_vector(7 downto 0);
    signal overflow : std_logic;
    signal w_inverse_B : std_logic_vector(7 downto 0);
    
begin

    ripple_adder_add : ripple_adder port map (
        Cin    => '0',
		A     => i_A,
		B     => i_B,
--		subber => sub,
		S     => op_sum,
		Cout  => cout_add
	);
	
	
	
	w_inverse_B(0) <= not i_B(0); 
	w_inverse_B(1) <= not i_B(1); 
	w_inverse_B(2) <= not i_B(2);
	w_inverse_B(3) <= not i_B(3); 
	w_inverse_B(4) <= not i_B(4); 
	w_inverse_B(5) <= not i_B(5); 
	w_inverse_B(6) <= not i_B(6); 
	w_inverse_B(7) <= not i_B(7); 
	 
	
	
	ripple_adder_sub : ripple_adder port map(
	   Cin    => '1',
		A     => i_A,
		B     => w_inverse_B,
--		subber => sub,
		S     => op_sub,
		Cout  => cout_sub
	);
	
	


    

    --concurrent statements (J)
    --sub <= '1' when i_op = "001" else '0';
    op_and <= i_A and i_B;
    op_or <= i_A or i_B;

	-- output logic (J)
	with i_op select
	result <= op_sum when "000",
	           op_sub when "001",
	           op_and when "010",
	           op_or when "011",
	           "11111111" when others;
	                       
	o_result <= result;
	
	
	--NZCV flags
	o_flags(3) <= '1' when result(7) = '1' else
	              '0';
	
	o_flags(2) <= '1' when result = "00000000" else
	              '0';
	
	o_flags(1) <= '1' when i_op = "001" and cout_sub = '1' else
	              '1' when i_op = "000" and cout_add = '1' else
	              '0';
	
	o_flags(0) <= '1' when (i_B(7) = '0' and i_A(7) = '0' and result(7) = '1' and i_op = "000") else
	              '1' when (i_B(7) = '1' and i_A(7) = '1' and result(7) = '0' and i_op = "000") else
	              '1' when (w_inverse_B(7) = '0' and i_A(7) = '0' and result(7) = '1' and i_op = "001") else
	              '1' when (w_inverse_B(7) = '1' and i_A(7) = '1' and result(7) = '0' and i_op = "001") else
	              '0';




end Behavioral;

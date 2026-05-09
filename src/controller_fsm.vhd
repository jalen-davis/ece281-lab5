----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:42:49 PM
-- Design Name: 
-- Module Name: controller_fsm - FSM
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

entity controller_fsm is
    Port ( i_reset : in STD_LOGIC;
           i_adv : in STD_LOGIC;
           i_clk : in STD_LOGIC; -- (J)
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
end controller_fsm;

architecture FSM of controller_fsm is

    type sm_cycle is (s_cycle1, s_cycle2, s_cycle3, s_cycle4);
    signal f_Q, f_Q_next: sm_cycle;

begin

    f_Q_next <= s_cycle2 when (f_Q = s_cycle1 and i_adv = '1') else
                s_cycle3 when (f_Q = s_cycle2 and i_adv = '1') else
                s_cycle4 when (f_Q = s_cycle3 and i_adv = '1') else
                s_cycle1 when (f_Q = s_cycle4 and i_adv = '1') else
                f_Q;
                
    
    with f_Q select
        o_cycle <= "0001" when s_cycle1,
                   "0010" when s_cycle2,
                   "0100" when s_cycle3,
                   "1000" when s_cycle4,
                   
               "0001" when others;
               
    
    register_proc : process (i_clk, i_adv, i_reset)
    begin
        if i_reset = '1' then
            f_Q <= s_cycle1;
        elsif (rising_edge(i_clk)) then
            if i_adv = '1' then
                f_Q <= f_Q_next;    -- next state becomes current state
            end if;
        end if;
    end process register_proc;

end FSM;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2026 14:19:51
-- Design Name: 
-- Module Name: random_number_generator - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity random_number_generator is
    Port ( clk : in STD_LOGIC;
           clear : in STD_LOGIC;
           mode : in STD_LOGIC_VECTOR (1 downto 0);
           q_out : out STD_LOGIC_VECTOR (3 downto 0));
end random_number_generator;

architecture Behavioral of random_number_generator is

signal reg_state : STD_LOGIC_VECTOR(3 downto 0);
signal feedback  : std_logic; -- Semnalul XOR calculat in afara

begin

feedback <= (reg_state(0) xor reg_state(3));

process(clk, clear, mode)
begin
    if clear = '1' then
        reg_state <= "1101";
    end if;
    if rising_edge(clk) then
        if clear = '0' then
            case mode is
                when "11" => reg_state <= "1011";
                when "01" =>  -- shift right + feedback XOR
                    reg_state <= "0000";
                when others => null;
            end case;
        end if;
    end if;
end process;
q_out <= reg_state;
end Behavioral;
